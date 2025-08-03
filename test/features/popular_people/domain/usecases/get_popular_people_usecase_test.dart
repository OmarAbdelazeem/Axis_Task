import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:axis_task/src/core/network/error/failures.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_model.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_image_model.dart';
import 'package:axis_task/src/features/popular_people/domain/models/people_params.dart';
import 'package:axis_task/src/features/popular_people/domain/models/people_response_model.dart';
import 'package:axis_task/src/features/popular_people/domain/repositories/abstract_people_repository.dart';
import 'package:axis_task/src/features/popular_people/domain/usecases/get_popular_people_usecase.dart';

// Manual mock for testing
class MockAbstractPeopleRepository extends AbstractPeopleRepository {
  late Either<Failure, PeopleResponseModel> _getPopularPeopleResult;
  late Either<Failure, PersonModel> _getPersonDetailsResult;
  late Either<Failure, PersonImageModel> _getPersonImagesResult;
  
  PeopleParams? lastGetPopularPeopleParams;
  int? lastGetPersonDetailsId;
  int? lastGetPersonImagesId;

  void setGetPopularPeopleResult(Either<Failure, PeopleResponseModel> result) {
    _getPopularPeopleResult = result;
  }

  void setGetPersonDetailsResult(Either<Failure, PersonModel> result) {
    _getPersonDetailsResult = result;
  }

  void setGetPersonImagesResult(Either<Failure, PersonImageModel> result) {
    _getPersonImagesResult = result;
  }

  @override
  Future<Either<Failure, PeopleResponseModel>> getPopularPeople(PeopleParams params) async {
    lastGetPopularPeopleParams = params;
    return _getPopularPeopleResult;
  }

  @override
  Future<Either<Failure, PersonModel>> getPersonDetails(int personId) async {
    lastGetPersonDetailsId = personId;
    return _getPersonDetailsResult;
  }

  @override
  Future<Either<Failure, PersonImageModel>> getPersonImages(int personId) async {
    lastGetPersonImagesId = personId;
    return _getPersonImagesResult;
  }
}

void main() {
  late GetPopularPeopleUseCase useCase;
  late MockAbstractPeopleRepository mockRepository;

  setUp(() {
    mockRepository = MockAbstractPeopleRepository();
    useCase = GetPopularPeopleUseCase(mockRepository);
  });

  // Test data
  const tPage = 1;
  const tParams = PeopleParams(page: tPage);
  
  final tPeople = [
    PersonModel(
      id: 1,
      name: 'John Doe',
      profilePath: '/john_doe.jpg',
      popularity: 8.5,
    ),
    PersonModel(
      id: 2,
      name: 'Jane Smith',
      profilePath: '/jane_smith.jpg',
      popularity: 7.2,
    ),
  ];
  
  final tResponse = PeopleResponseModel(
    people: tPeople,
    isFromCache: false,
    lastUpdated: DateTime(2024, 1, 1),
  );

  group('GetPopularPeopleUseCase', () {
    test(
      'should return PeopleResponseModel when repository call is successful',
      () async {
        // arrange
        mockRepository.setGetPopularPeopleResult(Right(tResponse));

        // act
        final result = await useCase.call(tParams);

        // assert
        expect(result, Right(tResponse));
        expect(mockRepository.lastGetPopularPeopleParams, tParams);
      },
    );

    test(
      'should return ServerFailure when repository returns server error',
      () async {
        // arrange
        const tFailure = ServerFailure('Server error', 500);
        mockRepository.setGetPopularPeopleResult(const Left(tFailure));

        // act
        final result = await useCase.call(tParams);

        // assert
        expect(result, const Left(tFailure));
        expect(mockRepository.lastGetPopularPeopleParams, tParams);
      },
    );

    test(
      'should return cached data when repository returns cached response',
      () async {
        // arrange
        final tCachedResponse = PeopleResponseModel(
          people: tPeople,
          isFromCache: true,
          lastUpdated: DateTime(2024, 1, 1),
        );
        mockRepository.setGetPopularPeopleResult(Right(tCachedResponse));

        // act
        final result = await useCase.call(tParams);

        // assert
        expect(result, Right(tCachedResponse));
        result.fold(
          (failure) => fail('Should return success'),
          (response) {
            expect(response.isFromCache, true);
            expect(response.people, tPeople);
          },
        );
        expect(mockRepository.lastGetPopularPeopleParams, tParams);
      },
    );

    test(
      'should handle different page numbers correctly',
      () async {
        // arrange
        const tPage2 = 2;
        const tParams2 = PeopleParams(page: tPage2);
        mockRepository.setGetPopularPeopleResult(Right(tResponse));

        // act
        final result = await useCase.call(tParams2);

        // assert
        expect(result, Right(tResponse));
        expect(mockRepository.lastGetPopularPeopleParams, tParams2);
      },
    );

    test(
      'should return CancelTokenFailure when repository returns cancel error',
      () async {
        // arrange
        const tFailure = CancelTokenFailure('Request cancelled', 0);
        mockRepository.setGetPopularPeopleResult(const Left(tFailure));

        // act
        final result = await useCase.call(tParams);

        // assert
        expect(result, const Left(tFailure));
        expect(mockRepository.lastGetPopularPeopleParams, tParams);
      },
    );

    test(
      'should handle empty people list correctly',
      () async {
        // arrange
        final tEmptyResponse = PeopleResponseModel(
          people: [],
          isFromCache: false,
          lastUpdated: DateTime(2024, 1, 1),
        );
        mockRepository.setGetPopularPeopleResult(Right(tEmptyResponse));

        // act
        final result = await useCase.call(tParams);

        // assert
        expect(result, Right(tEmptyResponse));
        result.fold(
          (failure) => fail('Should return success'),
          (response) {
            expect(response.people, isEmpty);
            expect(response.isFromCache, false);
          },
        );
        expect(mockRepository.lastGetPopularPeopleParams, tParams);
      },
    );

    test(
      'should pass correct parameters to repository',
      () async {
        // arrange
        const tCustomPage = 5;
        const tCustomParams = PeopleParams(page: tCustomPage);
        mockRepository.setGetPopularPeopleResult(Right(tResponse));

        // act
        await useCase.call(tCustomParams);

        // assert
        expect(mockRepository.lastGetPopularPeopleParams, tCustomParams);
      },
    );
  });
} 