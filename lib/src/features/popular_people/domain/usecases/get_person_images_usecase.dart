import 'package:dartz/dartz.dart';
import 'package:axis_task/src/core/network/error/failures.dart';
import 'package:axis_task/src/core/utils/usecases/usecase.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_image_model.dart';
import 'package:axis_task/src/features/popular_people/domain/repositories/abstract_people_repository.dart';

class GetPersonImagesUseCase implements UseCase<PersonImageModel, int> {
  final AbstractPeopleRepository repository;

  GetPersonImagesUseCase(this.repository);

  @override
  Future<Either<Failure, PersonImageModel>> call(int personId) async {
    return await repository.getPersonImages(personId);
  }
} 