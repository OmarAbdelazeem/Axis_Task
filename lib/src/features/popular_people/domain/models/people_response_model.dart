import 'package:axis_task/src/features/popular_people/domain/models/person_model.dart';

class PeopleResponseModel {
  final List<PersonModel> people;
  final bool isFromCache;
  final DateTime? lastUpdated;

  const PeopleResponseModel({
    required this.people,
    this.isFromCache = false,
    this.lastUpdated,
  });
} 