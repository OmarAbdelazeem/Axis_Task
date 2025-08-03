import 'package:dartz/dartz.dart';
import 'package:axis_task/src/core/network/error/failures.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_model.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_image_model.dart';
import 'package:axis_task/src/features/popular_people/domain/models/people_params.dart';
import 'package:axis_task/src/features/popular_people/domain/models/people_response_model.dart';

abstract class AbstractPeopleRepository {
  Future<Either<Failure, PeopleResponseModel>> getPopularPeople(PeopleParams params);
  Future<Either<Failure, PersonModel>> getPersonDetails(int personId);
  Future<Either<Failure, PersonImageModel>> getPersonImages(int personId);
} 