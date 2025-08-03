part of 'person_images_bloc.dart';

abstract class PersonImagesEvent extends Equatable {
  const PersonImagesEvent();

  @override
  List<Object?> get props => [];
}

class OnGettingPersonImagesEvent extends PersonImagesEvent {
  final int personId;

  const OnGettingPersonImagesEvent(this.personId);

  @override
  List<Object?> get props => [personId];
} 