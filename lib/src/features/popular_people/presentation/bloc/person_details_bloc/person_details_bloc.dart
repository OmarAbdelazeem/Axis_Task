import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:axis_task/src/core/network/error/failures.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_model.dart';
import 'package:axis_task/src/features/popular_people/domain/usecases/get_person_details_usecase.dart';

part 'person_details_event.dart';
part 'person_details_state.dart';

class PersonDetailsBloc extends Bloc<PersonDetailsEvent, PersonDetailsState> {
  final GetPersonDetailsUseCase getPersonDetailsUseCase;

  PersonDetailsBloc({
    required this.getPersonDetailsUseCase,
  }) : super(PersonDetailsInitial()) {
    on<OnGettingPersonDetailsEvent>(_onGettingPersonDetailsEvent);
  }

  // Getting person details event
  _onGettingPersonDetailsEvent(
      OnGettingPersonDetailsEvent event, Emitter<PersonDetailsState> emitter) async {
    emitter(LoadingPersonDetailsState());

    final result = await getPersonDetailsUseCase.call(event.personId);
    
    result.fold((l) {
      emitter(ErrorPersonDetailsState(l.errorMessage));
    }, (r) {
      emitter(SuccessPersonDetailsState(r));
    });
  }
} 