import 'package:dartz/dartz.dart';
import 'package:axis_task/src/core/network/error/failures.dart';
import 'package:axis_task/src/core/utils/usecases/usecase.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_model.dart';
import 'package:axis_task/src/features/popular_people/domain/models/people_params.dart';
import 'package:axis_task/src/features/popular_people/domain/models/people_response_model.dart';
import 'package:axis_task/src/features/popular_people/domain/repositories/abstract_people_repository.dart';

class GetPopularPeopleUseCase implements UseCase<PeopleResponseModel, PeopleParams> {
  final AbstractPeopleRepository repository;

  GetPopularPeopleUseCase(this.repository);

  @override
  Future<Either<Failure, PeopleResponseModel>> call(PeopleParams params) async {
    return await repository.getPopularPeople(params);
  }
} 