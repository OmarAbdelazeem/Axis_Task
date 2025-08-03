part of 'person_details_bloc.dart';

abstract class PersonDetailsState extends Equatable {
  const PersonDetailsState();

  @override
  List<Object?> get props => [];
}

class PersonDetailsInitial extends PersonDetailsState {}

class LoadingPersonDetailsState extends PersonDetailsState {}

class SuccessPersonDetailsState extends PersonDetailsState {
  final PersonModel person;

  const SuccessPersonDetailsState(this.person);

  @override
  List<Object?> get props => [person];
}

class ErrorPersonDetailsState extends PersonDetailsState {
  final String message;

  const ErrorPersonDetailsState(this.message);

  @override
  List<Object?> get props => [message];
} 