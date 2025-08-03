import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:axis_task/src/core/network/error/failures.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_model.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_image_model.dart';
import 'package:axis_task/src/features/popular_people/domain/models/people_params.dart';
import 'package:axis_task/src/features/popular_people/domain/models/people_response_model.dart';
import 'package:axis_task/src/features/popular_people/domain/repositories/abstract_people_repository.dart';
import 'package:axis_task/src/features/popular_people/domain/usecases/get_person_details_usecase.dart';

// Manual mock for testing
class MockAbstractPeopleRepository extends AbstractPeopleRepository {
  late Either<Failure, PersonModel> _getPersonDetailsResult;
  int? lastGetPersonDetailsId;

  void setGetPersonDetailsResult(Either<Failure, PersonModel> result) {
    _getPersonDetailsResult = result;
  }

  @override
  Future<Either<Failure, PersonModel>> getPersonDetails(int personId) async {
    lastGetPersonDetailsId = personId;
    return _getPersonDetailsResult;
  }

  @override
  Future<Either<Failure, PeopleResponseModel>> getPopularPeople(PeopleParams params) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, PersonImageModel>> getPersonImages(int personId) async {
    throw UnimplementedError();
  }
}

void main() {
  late GetPersonDetailsUseCase useCase;
  late MockAbstractPeopleRepository mockRepository;

  setUp(() {
    mockRepository = MockAbstractPeopleRepository();
    useCase = GetPersonDetailsUseCase(mockRepository);
  });

  // Test data
  const tPersonId = 1;
  final tPersonModel = PersonModel(
    id: tPersonId,
    name: 'John Doe',
    biography: 'Famous actor and producer',
    birthday: '1980-01-01',
    placeOfBirth: 'New York, USA',
    profilePath: '/john_doe.jpg',
    popularity: 8.5,
    knownForDepartment: 'Acting',
  );

  group('GetPersonDetailsUseCase', () {
    test(
      'should return PersonModel when repository call is successful',
      () async {
        // arrange
        mockRepository.setGetPersonDetailsResult(Right(tPersonModel));

        // act
        final result = await useCase.call(tPersonId);

        // assert
        expect(result, Right(tPersonModel));
        expect(mockRepository.lastGetPersonDetailsId, tPersonId);
      },
    );

    test(
      'should return ServerFailure when repository returns server error',
      () async {
        // arrange
        const tFailure = ServerFailure('Server error', 500);
        mockRepository.setGetPersonDetailsResult(const Left(tFailure));

        // act
        final result = await useCase.call(tPersonId);

        // assert
        expect(result, const Left(tFailure));
        expect(mockRepository.lastGetPersonDetailsId, tPersonId);
      },
    );

    test(
      'should return ServerFailure when person not found (404)',
      () async {
        // arrange
        const tFailure = ServerFailure('Person not found', 404);
        mockRepository.setGetPersonDetailsResult(const Left(tFailure));

        // act
        final result = await useCase.call(tPersonId);

        // assert
        expect(result, const Left(tFailure));
        expect(mockRepository.lastGetPersonDetailsId, tPersonId);
      },
    );

    test(
      'should handle different person IDs correctly',
      () async {
        // arrange
        const tDifferentPersonId = 999;
        final tDifferentPersonModel = PersonModel(
          id: tDifferentPersonId,
          name: 'Jane Smith',
          biography: 'Talented actress',
          profilePath: '/jane_smith.jpg',
          popularity: 7.2,
        );
        mockRepository.setGetPersonDetailsResult(Right(tDifferentPersonModel));

        // act
        final result = await useCase.call(tDifferentPersonId);

        // assert
        expect(result, Right(tDifferentPersonModel));
        expect(mockRepository.lastGetPersonDetailsId, tDifferentPersonId);
      },
    );

    test(
      'should return CancelTokenFailure when request is cancelled',
      () async {
        // arrange
        const tFailure = CancelTokenFailure('Request cancelled', 0);
        mockRepository.setGetPersonDetailsResult(const Left(tFailure));

        // act
        final result = await useCase.call(tPersonId);

        // assert
        expect(result, const Left(tFailure));
        expect(mockRepository.lastGetPersonDetailsId, tPersonId);
      },
    );

    test(
      'should handle invalid person ID (negative numbers)',
      () async {
        // arrange
        const tInvalidPersonId = -1;
        const tFailure = ServerFailure('Invalid person ID', 400);
        mockRepository.setGetPersonDetailsResult(const Left(tFailure));

        // act
        final result = await useCase.call(tInvalidPersonId);

        // assert
        expect(result, const Left(tFailure));
        expect(mockRepository.lastGetPersonDetailsId, tInvalidPersonId);
      },
    );

    test(
      'should handle person with minimal data correctly',
      () async {
        // arrange
        final tMinimalPersonModel = PersonModel(
          id: tPersonId,
          name: 'Minimal Person',
          profilePath: null,
          popularity: 0.0,
        );
        mockRepository.setGetPersonDetailsResult(Right(tMinimalPersonModel));

        // act
        final result = await useCase.call(tPersonId);

        // assert
        expect(result, Right(tMinimalPersonModel));
        result.fold(
          (failure) => fail('Should return success'),
          (person) {
            expect(person.id, tPersonId);
            expect(person.name, 'Minimal Person');
            expect(person.profilePath, null);
            expect(person.popularity, 0.0);
          },
        );
        expect(mockRepository.lastGetPersonDetailsId, tPersonId);
      },
    );

    test(
      'should pass correct person ID to repository',
      () async {
        // arrange
        const tCustomPersonId = 12345;
        mockRepository.setGetPersonDetailsResult(Right(tPersonModel));

        // act
        await useCase.call(tCustomPersonId);

        // assert
        expect(mockRepository.lastGetPersonDetailsId, tCustomPersonId);
      },
    );
  });
} 