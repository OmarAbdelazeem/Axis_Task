part of 'people_bloc.dart';

abstract class PeopleEvent extends Equatable {
  const PeopleEvent();

  @override
  List<Object?> get props => [];
}

class OnGettingPeopleEvent extends PeopleEvent {
  final int page;
  final String searchText;
  final bool withLoading;

  const OnGettingPeopleEvent({
    this.page = 1,
    this.searchText = '',
    this.withLoading = true,
  });

  @override
  List<Object?> get props => [page, searchText, withLoading];
}

class OnSearchingPeopleEvent extends PeopleEvent {
  final String text;

  const OnSearchingPeopleEvent(this.text);

  @override
  List<Object?> get props => [text];
}
