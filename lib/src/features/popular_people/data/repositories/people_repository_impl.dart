import 'package:dartz/dartz.dart';
import 'package:axis_task/src/core/network/error/failures.dart';
import 'package:axis_task/src/core/network/error/exceptions.dart';
import 'package:axis_task/src/features/popular_people/domain/repositories/abstract_people_repository.dart';
import 'package:axis_task/src/features/popular_people/data/data_sources/remote/abstract_people_api.dart';
import 'package:axis_task/src/features/popular_people/data/data_sources/local/people_local_data_source.dart';
import 'package:axis_task/src/features/popular_people/domain/models/people_response_model.dart';
import 'package:axis_task/src/features/popular_people/domain/models/people_params.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_model.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_image_model.dart';
import 'package:axis_task/src/core/utils/log/app_logger.dart';

class PeopleRepositoryImpl extends AbstractPeopleRepository {
  final AbstractPeopleApi peopleApi;
  final PeopleLocalDataSource localDataSource;

  PeopleRepositoryImpl(this.peopleApi, this.localDataSource);

  // Get Popular People
  @override
  Future<Either<Failure, PeopleResponseModel>> getPopularPeople(PeopleParams params) async {
    try {
      // Try to get data from remote API
      final result = await peopleApi.getPopularPeople(params);
      final people = result.results ?? [];
      
      // Cache the data for offline use (accumulate with existing data)
      if (people.isNotEmpty) {
        if (params.page == 1) {
          // First page: replace all cached data
          logger.info("Caching first page with ${people.length} people");
          await localDataSource.cachePeople(people);
        } else {
          // Subsequent pages: append to existing cached data
          logger.info("Appending page ${params.page} with ${people.length} people");
          await localDataSource.appendPeople(people);
        }
      }
      
      return Right(PeopleResponseModel(
        people: people,
        isFromCache: false,
        lastUpdated: DateTime.now(),
      ));
    } on ServerException catch (e) {
      logger.warning("Server error: ${e.message}");
      
      // Try to get cached data as fallback
      try {
        final cachedResult = await localDataSource.getCachedPeople();
        return cachedResult.fold(
          (failure) {
            logger.warning("No cached data available: ${failure.errorMessage}");
            return Left(ServerFailure(e.message, e.statusCode));
          },
          (cachedPeople) {
            logger.info("Using cached data with ${cachedPeople.length} people");
            return Right(PeopleResponseModel(
              people: cachedPeople,
              isFromCache: true,
              lastUpdated: DateTime.now(), // We don't have the actual cache timestamp
            ));
          },
        );
      } catch (cacheError) {
        logger.severe("Cache error: $cacheError");
        return Left(ServerFailure(e.message, e.statusCode));
      }
    } catch (e) {
      logger.severe("Unexpected error: $e");
      return Left(ServerFailure(e.toString(), null));
    }
  }

  // Get Person Details
  @override
  Future<Either<Failure, PersonModel>> getPersonDetails(int personId) async {
    try {
      final result = await peopleApi.getPersonDetails(personId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }

  // Get Person Images
  @override
  Future<Either<Failure, PersonImageModel>> getPersonImages(int personId) async {
    try {
      final result = await peopleApi.getPersonImages(personId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on CancelTokenException catch (e) {
      return Left(CancelTokenFailure(e.message, e.statusCode));
    }
  }
} 