import 'package:dartz/dartz.dart';
import 'package:axis_task/src/core/network/error/failures.dart';
import 'package:axis_task/src/core/utils/usecases/usecase.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_model.dart';
import 'package:axis_task/src/features/popular_people/domain/repositories/abstract_people_repository.dart';

class GetPersonDetailsUseCase implements UseCase<PersonModel, int> {
  final AbstractPeopleRepository repository;

  GetPersonDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, PersonModel>> call(int personId) async {
    return await repository.getPersonDetails(personId);
  }
} 