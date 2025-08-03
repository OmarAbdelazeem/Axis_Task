import 'package:equatable/equatable.dart';
import 'package:axis_task/src/features/popular_people/constants/people_constants.dart';

class PeopleParams extends Equatable {
  final int page;
  final String language;

  const PeopleParams({
    this.page = 1,
    this.language = PeopleConstants.DEFAULT_LANGUAGE,
  });

  @override
  List<Object?> get props => [page, language];
} 