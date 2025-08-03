part of 'person_images_bloc.dart';

abstract class PersonImagesState extends Equatable {
  const PersonImagesState();

  @override
  List<Object?> get props => [];
}

class PersonImagesInitial extends PersonImagesState {}

class LoadingPersonImagesState extends PersonImagesState {}

class SuccessPersonImagesState extends PersonImagesState {
  final PersonImageModel images;

  const SuccessPersonImagesState(this.images);

  @override
  List<Object?> get props => [images];
}

class ErrorPersonImagesState extends PersonImagesState {
  final String message;

  const ErrorPersonImagesState(this.message);

  @override
  List<Object?> get props => [message];
} 