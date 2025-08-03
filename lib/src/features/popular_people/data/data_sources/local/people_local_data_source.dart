import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:axis_task/src/core/network/error/failures.dart';
import 'package:axis_task/src/features/popular_people/data/models/person_hive_model.dart';
import 'package:axis_task/src/features/popular_people/constants/people_constants.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_model.dart';

abstract class PeopleLocalDataSource {
  Future<Either<Failure, List<PersonModel>>> getCachedPeople();
  Future<Either<Failure, void>> cachePeople(List<PersonModel> people);
  Future<Either<Failure, void>> appendPeople(List<PersonModel> people);
  Future<Either<Failure, void>> clearCache();
  Future<Either<Failure, bool>> hasCachedData();
  Future<Either<Failure, DateTime?>> getLastUpdated();
}

class PeopleLocalDataSourceImpl implements PeopleLocalDataSource {
  static const String _boxName = PeopleConstants.PEOPLE_BOX_NAME;
  static const String _metadataBoxName = PeopleConstants.PEOPLE_METADATA_BOX_NAME;
  static const String _lastUpdateKey = PeopleConstants.LAST_UPDATE_KEY;

  @override
  Future<Either<Failure, List<PersonModel>>> getCachedPeople() async {
    try {
      final box = await Hive.openBox<PersonHiveModel>(_boxName);
      final people = box.values.toList();
      
      if (people.isEmpty) {
        return Left(ServerFailure('No cached data available', null));
      }

      // Convert Hive models to PersonModel
      final personModels = people.map((hiveModel) => hiveModel.toPersonModel()).toList();
      
      return Right(personModels);
    } catch (e) {
      return Left(ServerFailure('Failed to retrieve cached data: ${e.toString()}', null));
    }
  }

  @override
  Future<Either<Failure, void>> cachePeople(List<PersonModel> people) async {
    try {
      final box = await Hive.openBox<PersonHiveModel>(_boxName);
      
      // Clear existing data
      await box.clear();
      
      // Convert PersonModel to HiveModel and store
      final hiveModels = people.map((person) => PersonHiveModel.fromPersonModel(person)).toList();
      
      // Store each person with their ID as key
      for (final hiveModel in hiveModels) {
        if (hiveModel.id != null) {
          await box.put(hiveModel.id.toString(), hiveModel);
        }
      }
      
      // Store last update timestamp in metadata box
      final metadataBox = await Hive.openBox(_metadataBoxName);
      await metadataBox.put(_lastUpdateKey, DateTime.now());
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to cache data: ${e.toString()}', null));
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      final box = await Hive.openBox<PersonHiveModel>(_boxName);
      await box.clear();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to clear cache: ${e.toString()}', null));
    }
  }

  @override
  Future<Either<Failure, bool>> hasCachedData() async {
    try {
      final box = await Hive.openBox<PersonHiveModel>(_boxName);
      final metadataBox = await Hive.openBox(_metadataBoxName);
      final hasData = box.isNotEmpty && metadataBox.containsKey(_lastUpdateKey);
      
                        if (hasData) {
                    // Check if data is not too old (e.g., less than 24 hours)
                    final lastUpdate = metadataBox.get(_lastUpdateKey) as DateTime?;
                    if (lastUpdate != null) {
                      final difference = DateTime.now().difference(lastUpdate);
                      return Right(difference.inHours < PeopleConstants.CACHE_VALIDITY_HOURS);
                    }
                  }
      
      return const Right(false);
    } catch (e) {
      return Left(ServerFailure('Failed to check cached data: ${e.toString()}', null));
    }
  }

  @override
  Future<Either<Failure, void>> appendPeople(List<PersonModel> people) async {
    try {
      final box = await Hive.openBox<PersonHiveModel>(_boxName);
      
      // Convert PersonModel to HiveModel and store
      final hiveModels = people.map((person) => PersonHiveModel.fromPersonModel(person)).toList();

      // Store each person with their ID as key (this will update existing entries)
      for (final hiveModel in hiveModels) {
        if (hiveModel.id != null) {
          await box.put(hiveModel.id.toString(), hiveModel);
        }
      }

      // Update last update timestamp in metadata box
      final metadataBox = await Hive.openBox(_metadataBoxName);
      await metadataBox.put(_lastUpdateKey, DateTime.now());

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to append people data: ${e.toString()}', null));
    }
  }

  @override
  Future<Either<Failure, DateTime?>> getLastUpdated() async {
    try {
      final metadataBox = await Hive.openBox(_metadataBoxName);
      final lastUpdate = metadataBox.get(_lastUpdateKey) as DateTime?;
      return Right(lastUpdate);
    } catch (e) {
      return Left(ServerFailure('Failed to get last updated time: ${e.toString()}', null));
    }
  }
} 