import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:axis_task/src/core/network/error/failures.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_model.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_image_model.dart';
import 'package:axis_task/src/features/popular_people/domain/models/people_params.dart';
import 'package:axis_task/src/features/popular_people/domain/models/people_response_model.dart';
import 'package:axis_task/src/features/popular_people/domain/repositories/abstract_people_repository.dart';
import 'package:axis_task/src/features/popular_people/domain/usecases/get_person_images_usecase.dart';

// Manual mock for testing
class MockAbstractPeopleRepository extends AbstractPeopleRepository {
  late Either<Failure, PersonImageModel> _getPersonImagesResult;
  int? lastGetPersonImagesId;

  void setGetPersonImagesResult(Either<Failure, PersonImageModel> result) {
    _getPersonImagesResult = result;
  }

  @override
  Future<Either<Failure, PersonImageModel>> getPersonImages(int personId) async {
    lastGetPersonImagesId = personId;
    return _getPersonImagesResult;
  }

  @override
  Future<Either<Failure, PeopleResponseModel>> getPopularPeople(PeopleParams params) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, PersonModel>> getPersonDetails(int personId) async {
    throw UnimplementedError();
  }
}

void main() {
  late GetPersonImagesUseCase useCase;
  late MockAbstractPeopleRepository mockRepository;

  setUp(() {
    mockRepository = MockAbstractPeopleRepository();
    useCase = GetPersonImagesUseCase(mockRepository);
  });

  // Test data
  const tPersonId = 1;
  final tPersonImageModel = PersonImageModel(
    id: tPersonId,
    profiles: [
      PersonImageProfile(filePath: '/image1.jpg', aspectRatio: 1.5, height: 400, width: 600),
      PersonImageProfile(filePath: '/image2.jpg', aspectRatio: 1.8, height: 350, width: 630),
      PersonImageProfile(filePath: '/image3.jpg', aspectRatio: 1.2, height: 500, width: 600),
    ],
  );

  group('GetPersonImagesUseCase', () {
    test(
      'should return PersonImageModel when repository call is successful',
      () async {
        // arrange
        mockRepository.setGetPersonImagesResult(Right(tPersonImageModel));

        // act
        final result = await useCase.call(tPersonId);

        // assert
        expect(result, Right(tPersonImageModel));
        expect(mockRepository.lastGetPersonImagesId, tPersonId);
      },
    );

    test(
      'should return ServerFailure when repository returns server error',
      () async {
        // arrange
        const tFailure = ServerFailure('Server error', 500);
        mockRepository.setGetPersonImagesResult(const Left(tFailure));

        // act
        final result = await useCase.call(tPersonId);

        // assert
        expect(result, const Left(tFailure));
        expect(mockRepository.lastGetPersonImagesId, tPersonId);
      },
    );

    test(
      'should return ServerFailure when person not found (404)',
      () async {
        // arrange
        const tFailure = ServerFailure('Person not found', 404);
        mockRepository.setGetPersonImagesResult(const Left(tFailure));

        // act
        final result = await useCase.call(tPersonId);

        // assert
        expect(result, const Left(tFailure));
        expect(mockRepository.lastGetPersonImagesId, tPersonId);
      },
    );

    test(
      'should handle different person IDs correctly',
      () async {
        // arrange
        const tDifferentPersonId = 999;
        final tDifferentPersonImageModel = PersonImageModel(
          id: tDifferentPersonId,
          profiles: [PersonImageProfile(filePath: '/different_image.jpg')],
        );
        mockRepository.setGetPersonImagesResult(Right(tDifferentPersonImageModel));

        // act
        final result = await useCase.call(tDifferentPersonId);

        // assert
        expect(result, Right(tDifferentPersonImageModel));
        expect(mockRepository.lastGetPersonImagesId, tDifferentPersonId);
      },
    );

    test(
      'should return CancelTokenFailure when request is cancelled',
      () async {
        // arrange
        const tFailure = CancelTokenFailure('Request cancelled', 0);
        mockRepository.setGetPersonImagesResult(const Left(tFailure));

        // act
        final result = await useCase.call(tPersonId);

        // assert
        expect(result, const Left(tFailure));
        expect(mockRepository.lastGetPersonImagesId, tPersonId);
      },
    );

    test(
      'should handle person with no images correctly',
      () async {
        // arrange
        final tEmptyPersonImageModel = PersonImageModel(
          id: tPersonId,
          profiles: [],
        );
        mockRepository.setGetPersonImagesResult(Right(tEmptyPersonImageModel));

        // act
        final result = await useCase.call(tPersonId);

        // assert
        expect(result, Right(tEmptyPersonImageModel));
        result.fold(
          (failure) => fail('Should return success'),
          (images) {
            expect(images.id, tPersonId);
            expect(images.profiles, isNotNull);
            expect(images.profiles!, isEmpty);
          },
        );
        expect(mockRepository.lastGetPersonImagesId, tPersonId);
      },
    );

    test(
      'should handle invalid person ID (negative numbers)',
      () async {
        // arrange
        const tInvalidPersonId = -1;
        const tFailure = ServerFailure('Invalid person ID', 400);
        mockRepository.setGetPersonImagesResult(const Left(tFailure));

        // act
        final result = await useCase.call(tInvalidPersonId);

        // assert
        expect(result, const Left(tFailure));
        expect(mockRepository.lastGetPersonImagesId, tInvalidPersonId);
      },
    );

    test(
      'should handle person with single image correctly',
      () async {
        // arrange
        final tSingleImageModel = PersonImageModel(
          id: tPersonId,
          profiles: [PersonImageProfile(filePath: '/single_image.jpg', height: 300, width: 200)],
        );
        mockRepository.setGetPersonImagesResult(Right(tSingleImageModel));

        // act
        final result = await useCase.call(tPersonId);

        // assert
        expect(result, Right(tSingleImageModel));
        result.fold(
          (failure) => fail('Should return success'),
          (images) {
            expect(images.id, tPersonId);
            expect(images.profiles, isNotNull);
            expect(images.profiles!.length, 1);
            expect(images.profiles!.first.filePath, '/single_image.jpg');
          },
        );
        expect(mockRepository.lastGetPersonImagesId, tPersonId);
      },
    );

    test(
      'should handle person with multiple images correctly',
      () async {
        // arrange
        final tMultipleImagesModel = PersonImageModel(
          id: tPersonId,
          profiles: [
            PersonImageProfile(filePath: '/image1.jpg'),
            PersonImageProfile(filePath: '/image2.jpg'),
            PersonImageProfile(filePath: '/image3.jpg'),
            PersonImageProfile(filePath: '/image4.jpg'),
            PersonImageProfile(filePath: '/image5.jpg'),
          ],
        );
        mockRepository.setGetPersonImagesResult(Right(tMultipleImagesModel));

        // act
        final result = await useCase.call(tPersonId);

        // assert
        expect(result, Right(tMultipleImagesModel));
        result.fold(
          (failure) => fail('Should return success'),
          (images) {
            expect(images.id, tPersonId);
            expect(images.profiles, isNotNull);
            expect(images.profiles!.length, 5);
            expect(images.profiles!.any((profile) => profile.filePath == '/image1.jpg'), true);
            expect(images.profiles!.any((profile) => profile.filePath == '/image5.jpg'), true);
          },
        );
        expect(mockRepository.lastGetPersonImagesId, tPersonId);
      },
    );

    test(
      'should pass correct person ID to repository',
      () async {
        // arrange
        const tCustomPersonId = 12345;
        mockRepository.setGetPersonImagesResult(Right(tPersonImageModel));

        // act
        await useCase.call(tCustomPersonId);

        // assert
        expect(mockRepository.lastGetPersonImagesId, tCustomPersonId);
      },
    );
  });
} 