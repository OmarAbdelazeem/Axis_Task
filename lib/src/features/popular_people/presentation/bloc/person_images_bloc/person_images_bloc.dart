import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:axis_task/src/core/network/error/failures.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_image_model.dart';
import 'package:axis_task/src/features/popular_people/domain/usecases/get_person_images_usecase.dart';

part 'person_images_event.dart';
part 'person_images_state.dart';

class PersonImagesBloc extends Bloc<PersonImagesEvent, PersonImagesState> {
  final GetPersonImagesUseCase getPersonImagesUseCase;

  PersonImagesBloc({
    required this.getPersonImagesUseCase,
  }) : super(PersonImagesInitial()) {
    on<OnGettingPersonImagesEvent>(_onGettingPersonImagesEvent);
  }

  // Getting person images event
  _onGettingPersonImagesEvent(
      OnGettingPersonImagesEvent event, Emitter<PersonImagesState> emitter) async {
    emitter(LoadingPersonImagesState());

    final result = await getPersonImagesUseCase.call(event.personId);
    
    result.fold((l) {
      emitter(ErrorPersonImagesState(l.errorMessage));
    }, (r) {
      emitter(SuccessPersonImagesState(r));
    });
  }
} 