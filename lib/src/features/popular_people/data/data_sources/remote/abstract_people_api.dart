import 'package:axis_task/src/features/popular_people/domain/models/person_model.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_image_model.dart';
import 'package:axis_task/src/features/popular_people/domain/models/people_params.dart';
import 'package:axis_task/src/features/popular_people/domain/models/tmdb_response_model.dart';

abstract class AbstractPeopleApi {
  Future<TmdbResponse<List<PersonModel>>> getPopularPeople(PeopleParams params);
  Future<PersonModel> getPersonDetails(int personId);
  Future<PersonImageModel> getPersonImages(int personId);
} 