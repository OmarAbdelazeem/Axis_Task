import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:axis_task/src/core/network/error/failures.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_model.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_image_model.dart';
import 'package:axis_task/src/features/popular_people/domain/models/people_params.dart';
import 'package:axis_task/src/features/popular_people/domain/usecases/get_popular_people_usecase.dart';
import 'package:axis_task/src/features/popular_people/domain/usecases/get_person_details_usecase.dart';
import 'package:axis_task/src/features/popular_people/domain/usecases/get_person_images_usecase.dart';
import 'package:axis_task/src/core/utils/log/app_logger.dart';

part 'people_event.dart';
part 'people_state.dart';

class PeopleBloc extends Bloc<PeopleEvent, PeopleState> {
  final GetPopularPeopleUseCase getPopularPeopleUseCase;
  final GetPersonDetailsUseCase getPersonDetailsUseCase;
  final GetPersonImagesUseCase getPersonImagesUseCase;

  // List of people for search functionality
  List<PersonModel> allPeople = [];

  // Track if we're in offline mode
  bool isOfflineMode = false;

  PeopleBloc({
    required this.getPopularPeopleUseCase,
    required this.getPersonDetailsUseCase,
    required this.getPersonImagesUseCase,
  }) : super(LoadingGetPeopleState()) {
    on<OnGettingPeopleEvent>(_onGettingPeopleEvent);
    on<OnSearchingPeopleEvent>(_onSearchingPeopleEvent);
  }

  // Getting people event
  _onGettingPeopleEvent(
      OnGettingPeopleEvent event, Emitter<PeopleState> emitter) async {
    logger.info("Getting people for page: ${event.page}");

    if (event.withLoading) {
      emitter(LoadingGetPeopleState());
    }

    final result = await getPopularPeopleUseCase.call(
      PeopleParams(page: event.page),
    );

    result.fold((l) {
      logger.warning("Error getting people: ${l.errorMessage}");
      if (l is CancelTokenFailure) {
        emitter(LoadingGetPeopleState());
      } else {
        emitter(ErrorGetPeopleState(l.errorMessage));
      }
    }, (r) {
      logger.info("Success getting people for page ${event.page}, count: ${r.people.length}");

      // Track offline mode
      isOfflineMode = r.isFromCache;

      // Handle data differently based on online/offline mode
      if (r.isFromCache) {
        // Offline mode: Load all cached data at once
        logger.info("Offline mode - loading all cached data");
        allPeople = r.people;
      } else {
        // Online mode: Add to existing list for pagination
        if (event.page == 1) {
          allPeople = r.people;
        } else {
          allPeople.addAll(r.people);
        }
      }

      logger.info("Total people in list: ${allPeople.length}, isOfflineMode: $isOfflineMode");
      // Return filtered list based on search with cache info
      emitter(SuccessGetPeopleState(
        _runFilter(event.searchText),
        isFromCache: r.isFromCache,
        lastUpdated: r.lastUpdated,
      ));
    });
  }

  // Searching event
  _onSearchingPeopleEvent(
      OnSearchingPeopleEvent event, Emitter<PeopleState> emitter) async {
    emitter(
      SearchingPeopleState(
        _runFilter(event.text),
      ),
    );
  }

  // Filter function for search
  List<PersonModel> _runFilter(String text) {
    List<PersonModel> results = [];
    if (text.isEmpty) {
      results = List.from(allPeople);
    } else {
      results = allPeople.where((person) {
        return (person.name ?? '').toLowerCase().contains(text.toLowerCase());
      }).toList();
    }
    return results;
  }
}
