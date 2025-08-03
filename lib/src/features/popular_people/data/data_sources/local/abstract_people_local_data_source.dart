import 'package:dartz/dartz.dart';
import 'package:axis_task/src/core/network/error/failures.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_model.dart';

abstract class AbstractPeopleLocalDataSource {
  Future<Either<Failure, List<PersonModel>>> getCachedPeople();
  Future<Either<Failure, void>> cachePeople(List<PersonModel> people);
  Future<Either<Failure, void>> appendPeople(List<PersonModel> people);
  Future<Either<Failure, void>> clearCache();
  Future<Either<Failure, bool>> hasCachedData();
  Future<Either<Failure, DateTime?>> getLastUpdated();
} 