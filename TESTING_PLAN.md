# 🧪 Testing Plan for Axis Task App

## 📋 Overview
This document outlines the critical features that need unit testing to ensure app reliability, maintainability, and bug-free functionality.

## 🎯 Critical Features for Unit Testing

### 1. 🏗️ Domain Layer (Use Cases) - HIGH PRIORITY

#### A. GetPopularPeopleUseCase
**File**: `lib/src/features/popular_people/domain/usecases/get_popular_people_usecase.dart`
**Tests**:
- ✅ Success case with valid data
- ✅ Failure case with server error
- ✅ Cached data response
- ✅ Different page numbers
- ✅ Empty response handling

#### B. GetPersonDetailsUseCase
**File**: `lib/src/features/popular_people/domain/usecases/get_person_details_usecase.dart`
**Tests**:
- ✅ Success case with valid person ID
- ✅ Failure case with invalid person ID
- ✅ Network error handling
- ✅ Empty person data

#### C. GetPersonImagesUseCase
**File**: `lib/src/features/popular_people/domain/usecases/get_person_images_usecase.dart`
**Tests**:
- ✅ Success case with images
- ✅ Failure case with no images
- ✅ Invalid person ID handling
- ✅ Network error handling

### 2. 🗄️ Data Layer (Repository) - HIGH PRIORITY

#### A. PeopleRepositoryImpl
**File**: `lib/src/features/popular_people/data/repositories/people_repository_impl.dart`
**Tests**:
- ✅ Network success → cache data
- ✅ Network failure → return cached data
- ✅ No cache → return error
- ✅ Pagination handling
- ✅ Cache append functionality
- ✅ Error propagation

### 3. 🎮 Presentation Layer (BLoCs) - HIGH PRIORITY

#### A. PeopleBloc
**File**: `lib/src/features/popular_people/presentation/bloc/people_bloc/people_bloc.dart`
**Tests**:
- ✅ Loading state transitions
- ✅ Success state with data
- ✅ Error state handling
- ✅ Search functionality
- ✅ Pagination logic
- ✅ Offline mode handling
- ✅ Search filtering

#### B. PersonDetailsBloc
**File**: `lib/src/features/popular_people/presentation/bloc/person_details_bloc/person_details_bloc.dart`
**Tests**:
- ✅ Loading state
- ✅ Success state with person details
- ✅ Error state
- ✅ State transitions

#### C. PersonImagesBloc
**File**: `lib/src/features/popular_people/presentation/bloc/person_images_bloc/person_images_bloc.dart`
**Tests**:
- ✅ Loading state
- ✅ Success state with images
- ✅ Error state
- ✅ State transitions

### 4. 🔧 Core Utilities - HIGH PRIORITY

#### A. ImageSaver
**File**: `lib/src/core/utils/image_saver.dart`
**Tests**:
- ✅ Permission handling (granted/denied)
- ✅ Image download success/failure
- ✅ Platform-specific saving (iOS/Android)
- ✅ Simulator detection
- ✅ Error handling
- ✅ File cleanup
- ✅ Album creation

#### B. PermissionHelper
**File**: `lib/src/core/utils/permission_helper.dart`
**Tests**:
- ✅ Android permissions (storage, manageExternalStorage)
- ✅ iOS permissions (photosAddOnly)
- ✅ Permission status checking
- ✅ Platform detection
- ✅ Permission request flow

### 5. 🌐 Network Layer - MEDIUM PRIORITY

#### A. PeopleApiImpl
**File**: `lib/src/features/popular_people/data/data_sources/remote/people_api_impl.dart`
**Tests**:
- ✅ Successful API calls
- ✅ Network errors
- ✅ Invalid responses
- ✅ Cancel token functionality
- ✅ URL construction
- ✅ Response parsing

#### B. DioErrorHandler
**File**: `lib/src/core/network/error/dio_error_handler.dart`
**Tests**:
- ✅ All error types (timeout, network, server errors)
- ✅ Error message formatting
- ✅ Status code handling
- ✅ Unknown error handling

### 6. 💾 Local Storage - MEDIUM PRIORITY

#### A. PeopleLocalDataSourceImpl
**File**: `lib/src/features/popular_people/data/data_sources/local/people_local_data_source.dart`
**Tests**:
- ✅ Save/retrieve people data
- ✅ Cache management
- ✅ Metadata handling
- ✅ Error scenarios
- ✅ Box operations
- ✅ Data conversion

### 7. 🎨 UI Components - LOW PRIORITY

#### A. PermissionDialogWidget
**File**: `lib/src/shared/presentation/widgets/permission_dialog_widget.dart`
**Tests**:
- ✅ Dialog display
- ✅ Platform-specific messages
- ✅ Button interactions
- ✅ Settings navigation

## 📊 Testing Priority Matrix

| Component | Priority | Complexity | Impact | Test Coverage |
|-----------|----------|------------|--------|---------------|
| GetPopularPeopleUseCase | 🔥 HIGH | Low | High | 100% |
| PeopleRepositoryImpl | 🔥 HIGH | Medium | High | 100% |
| PeopleBloc | 🔥 HIGH | Medium | High | 100% |
| ImageSaver | 🔥 HIGH | High | High | 90% |
| PermissionHelper | 🔥 HIGH | Medium | High | 100% |
| GetPersonDetailsUseCase | ⚡ MEDIUM | Low | Medium | 90% |
| GetPersonImagesUseCase | ⚡ MEDIUM | Low | Medium | 90% |
| PersonDetailsBloc | ⚡ MEDIUM | Low | Medium | 90% |
| PersonImagesBloc | ⚡ MEDIUM | Low | Medium | 90% |
| PeopleApiImpl | ⚡ MEDIUM | Medium | Medium | 80% |
| DioErrorHandler | ⚡ MEDIUM | Low | Medium | 100% |
| PeopleLocalDataSourceImpl | 📝 LOW | Medium | Low | 80% |
| PermissionDialogWidget | 📝 LOW | Low | Low | 70% |

## 🧪 Test Structure Guidelines

### 1. Test File Naming
```
test/
├── features/
│   └── popular_people/
│       ├── domain/
│       │   └── usecases/
│       │       └── get_popular_people_usecase_test.dart
│       ├── data/
│       │   └── repositories/
│       │       └── people_repository_impl_test.dart
│       └── presentation/
│           └── bloc/
│               └── people_bloc/
│                   └── people_bloc_test.dart
└── core/
    └── utils/
        ├── image_saver_test.dart
        └── permission_helper_test.dart
```

### 2. Test Structure Template
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  late ComponentUnderTest component;
  late MockDependency mockDependency;

  setUp(() {
    mockDependency = MockDependency();
    component = ComponentUnderTest(mockDependency);
  });

  group('ComponentUnderTest', () {
    test('should do something when condition is met', () async {
      // arrange
      when(mockDependency.method()).thenReturn(expectedValue);

      // act
      final result = await component.method();

      // assert
      expect(result, expectedResult);
      verify(mockDependency.method());
      verifyNoMoreInteractions(mockDependency);
    });

    test('should handle error when condition fails', () async {
      // arrange
      when(mockDependency.method()).thenThrow(Exception('Error'));

      // act
      final result = await component.method();

      // assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<Failure>());
    });
  });
}
```

### 3. Test Categories
- **Unit Tests**: Test individual components in isolation
- **Integration Tests**: Test component interactions
- **Widget Tests**: Test UI components
- **Golden Tests**: Test UI visual consistency

## 🚀 Implementation Steps

### Phase 1: Critical Path (Week 1)
1. ✅ GetPopularPeopleUseCase tests
2. ✅ PeopleRepositoryImpl tests
3. ✅ PeopleBloc tests
4. ✅ ImageSaver tests
5. ✅ PermissionHelper tests

### Phase 2: Secondary Features (Week 2)
1. ✅ GetPersonDetailsUseCase tests
2. ✅ GetPersonImagesUseCase tests
3. ✅ PersonDetailsBloc tests
4. ✅ PersonImagesBloc tests
5. ✅ PeopleApiImpl tests

### Phase 3: Supporting Features (Week 3)
1. ✅ DioErrorHandler tests
2. ✅ PeopleLocalDataSourceImpl tests
3. ✅ PermissionDialogWidget tests
4. ✅ Integration tests
5. ✅ Widget tests

## 📈 Success Metrics

- **Test Coverage**: >90% for critical components
- **Test Execution**: <30 seconds for full test suite
- **Code Quality**: All tests pass consistently
- **Bug Reduction**: 80% fewer production bugs
- **Maintainability**: Easy to add new tests

## 🔧 Testing Tools

- **Framework**: Flutter Test
- **Mocking**: Mockito
- **Coverage**: lcov
- **CI/CD**: GitHub Actions
- **Reports**: HTML coverage reports

## 📝 Notes

- Focus on **business logic** first
- Test **error scenarios** thoroughly
- Use **meaningful test names**
- Keep tests **fast and isolated**
- **Mock external dependencies**
- Test **edge cases** and **boundary conditions** 