import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:axis_task/src/core/utils/log/app_logger.dart';
import 'package:axis_task/src/features/popular_people/people_injections.dart';

final sl = GetIt.instance;

Future<void> initInjections() async {
  await initDioInjections();
  await initPeopleInjections();
}

Future<void> initDioInjections() async {
  initRootLogger();
  
  // Register Dio instance
  sl.registerLazySingleton<Dio>(() => Dio());
}
