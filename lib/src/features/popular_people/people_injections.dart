import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:axis_task/src/core/network/network_info.dart';
import 'package:axis_task/src/features/popular_people/data/data_sources/remote/people_api_impl.dart';
import 'package:axis_task/src/features/popular_people/data/data_sources/remote/abstract_people_api.dart';
import 'package:axis_task/src/features/popular_people/data/data_sources/local/people_local_data_source.dart';
import 'package:axis_task/src/features/popular_people/data/repositories/people_repository_impl.dart';
import 'package:axis_task/src/features/popular_people/domain/repositories/abstract_people_repository.dart';
import 'package:axis_task/src/features/popular_people/domain/usecases/get_popular_people_usecase.dart';
import 'package:axis_task/src/features/popular_people/domain/usecases/get_person_details_usecase.dart';
import 'package:axis_task/src/features/popular_people/domain/usecases/get_person_images_usecase.dart';
import 'package:axis_task/src/features/popular_people/presentation/bloc/people_bloc/people_bloc.dart';
import 'package:axis_task/src/features/popular_people/presentation/bloc/person_details_bloc/person_details_bloc.dart';
import 'package:axis_task/src/features/popular_people/presentation/bloc/person_images_bloc/person_images_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final sl = GetIt.instance;

Future<void> initPeopleInjections() async {
  // Data sources
  sl.registerLazySingleton<AbstractPeopleApi>(
    () => PeopleApiImpl(sl<Dio>()),
  );
  
  sl.registerLazySingleton<PeopleLocalDataSource>(
    () => PeopleLocalDataSourceImpl(),
  );

  // Network info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(Connectivity()),
  );

  // Repository
  sl.registerLazySingleton<AbstractPeopleRepository>(
    () => PeopleRepositoryImpl(sl<AbstractPeopleApi>(), sl<PeopleLocalDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton(
    () => GetPopularPeopleUseCase(sl<AbstractPeopleRepository>()),
  );
  sl.registerLazySingleton(
    () => GetPersonDetailsUseCase(sl<AbstractPeopleRepository>()),
  );
  sl.registerLazySingleton(
    () => GetPersonImagesUseCase(sl<AbstractPeopleRepository>()),
  );

  // BLoCs
  sl.registerFactory(
    () => PeopleBloc(
      getPopularPeopleUseCase: sl<GetPopularPeopleUseCase>(),
      getPersonDetailsUseCase: sl<GetPersonDetailsUseCase>(),
      getPersonImagesUseCase: sl<GetPersonImagesUseCase>(),
    ),
  );
  
  sl.registerFactory(
    () => PersonDetailsBloc(
      getPersonDetailsUseCase: sl<GetPersonDetailsUseCase>(),
    ),
  );
  
  sl.registerFactory(
    () => PersonImagesBloc(
      getPersonImagesUseCase: sl<GetPersonImagesUseCase>(),
    ),
  );
} 