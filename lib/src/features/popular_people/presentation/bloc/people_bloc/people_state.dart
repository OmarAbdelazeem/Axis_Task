part of 'people_bloc.dart';

abstract class PeopleState extends Equatable {
  const PeopleState();

  @override
  List<Object?> get props => [];
}

class LoadingGetPeopleState extends PeopleState {}

class SuccessGetPeopleState extends PeopleState {
  final List<PersonModel> people;
  final bool isFromCache;
  final DateTime? lastUpdated;

  const SuccessGetPeopleState(
    this.people, {
    this.isFromCache = false,
    this.lastUpdated,
  });

  @override
  List<Object?> get props => [people, isFromCache, lastUpdated];
}

class ErrorGetPeopleState extends PeopleState {
  final String message;

  const ErrorGetPeopleState(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchingPeopleState extends PeopleState {
  final List<PersonModel> people;

  const SearchingPeopleState(this.people);

  @override
  List<Object?> get props => [people];
}

// Person Details States
class LoadingGetPersonDetailsState extends PeopleState {}

class SuccessGetPersonDetailsState extends PeopleState {
  final PersonModel person;

  const SuccessGetPersonDetailsState(this.person);

  @override
  List<Object?> get props => [person];
}

class ErrorGetPersonDetailsState extends PeopleState {
  final String message;

  const ErrorGetPersonDetailsState(this.message);

  @override
  List<Object?> get props => [message];
}

// Person Images States
class LoadingGetPersonImagesState extends PeopleState {}

class SuccessGetPersonImagesState extends PeopleState {
  final PersonImageModel images;

  const SuccessGetPersonImagesState(this.images);

  @override
  List<Object?> get props => [images];
}

class ErrorGetPersonImagesState extends PeopleState {
  final String message;

  const ErrorGetPersonImagesState(this.message);

  @override
  List<Object?> get props => [message];
} 