part of 'person_details_bloc.dart';

abstract class PersonDetailsEvent extends Equatable {
  const PersonDetailsEvent();

  @override
  List<Object?> get props => [];
}

class OnGettingPersonDetailsEvent extends PersonDetailsEvent {
  final int personId;

  const OnGettingPersonDetailsEvent(this.personId);

  @override
  List<Object?> get props => [personId];
} 