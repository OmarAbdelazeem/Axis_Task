import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:axis_task/src/shared/presentation/pages/background_page.dart';
import 'package:axis_task/src/shared/presentation/widgets/app_loader.dart';
import 'package:axis_task/src/shared/presentation/widgets/custom_app_bar_widget.dart';
import 'package:axis_task/src/shared/presentation/widgets/reload_widget.dart';
import 'package:axis_task/src/shared/presentation/widgets/text_field_widget.dart';
import 'package:axis_task/src/core/helper/helper.dart';
import 'package:axis_task/src/core/utils/injections.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_model.dart';
import 'package:axis_task/src/features/popular_people/domain/usecases/get_popular_people_usecase.dart';
import 'package:axis_task/src/features/popular_people/domain/usecases/get_person_details_usecase.dart';
import 'package:axis_task/src/features/popular_people/domain/usecases/get_person_images_usecase.dart';
import 'package:axis_task/src/features/popular_people/presentation/bloc/people_bloc/people_bloc.dart';
import 'package:axis_task/src/features/popular_people/presentation/widgets/person_card_widget.dart';
import 'package:axis_task/src/core/router/app_route_enum.dart';
import 'package:axis_task/src/shared/presentation/widgets/offline_indicator_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  PeopleBloc _bloc = PeopleBloc(
    getPopularPeopleUseCase: sl<GetPopularPeopleUseCase>(),
    getPersonDetailsUseCase: sl<GetPersonDetailsUseCase>(),
    getPersonImagesUseCase: sl<GetPersonImagesUseCase>(),
  );

  // Key for scaffold to open drawer
  GlobalKey<ScaffoldState> _key = GlobalKey();

  // Refresh controller for list view
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool isSearching = false;

  // Search text field
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();

  // Pagination
  int currentPage = 1;
  bool isLoadingMore = false;

  @override
  void initState() {
    // Call event to get popular people
    callPeople();
    super.initState();
  }

  void callPeople() {
    _bloc.add(OnGettingPeopleEvent(page: currentPage, withLoading: true));
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundPage(
      scaffoldKey: _key,
      withDrawer: true,
      child: Column(
        children: [
          // Custom App Bar
          CustomAppBarWidget(
            title: isSearching
                ? TextFieldWidget(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    hintText: "Search",
                    onChanged: (value) {
                      _bloc.add(
                        OnSearchingPeopleEvent(
                          (value?.trim() ?? ""),
                        ),
                      );
                    },
                    suffixIcon: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          isSearching = !isSearching;
                          if (isSearching) {
                            _searchFocusNode.requestFocus();
                          } else {
                            _searchFocusNode.unfocus();
                            _searchController.clear();
                            callPeople();
                          }
                        });
                      },
                      icon: Icon(
                        Icons.close,
                        size: 20,
                      ),
                    ),
                  )
                : Text(
                    "Popular People",
                   style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w600),
                  ),
            actions: [
              !isSearching
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isSearching = !isSearching;
                          if (isSearching) {
                            _searchFocusNode.requestFocus();
                          } else {
                            _searchFocusNode.unfocus();
                            _searchController.clear();
                            callPeople();
                          }
                        });
                      },
                      icon: Icon(
                        Icons.search,
                        size: 20,
                      ),
                    )
                  : Container(),
            ],
          ),
          // Content
          Expanded(
            child: BlocConsumer<PeopleBloc, PeopleState>(
              bloc: _bloc,
              listener: (context, state) {
                if (state is ErrorGetPeopleState) {
                  _refreshController.refreshFailed();
                  _refreshController.loadComplete();
                  setState(() {
                    isLoadingMore = false;
                  });
                } else if (state is SuccessGetPeopleState) {
                  _refreshController.refreshCompleted();
                  _refreshController.loadComplete();
                  setState(() {
                    isLoadingMore = false;
                  });
                }
              },
              builder: (context, state) {
                if (state is LoadingGetPeopleState) {
                  return AppLoader();
                } else if (state is ErrorGetPeopleState) {
                  return ReloadWidget.error(
                    content: state.message,
                    onPressed: () {
                      currentPage = 1;
                      callPeople();
                    },
                  );
                } else if (state is SuccessGetPeopleState ||
                    state is SearchingPeopleState) {
                  List<PersonModel> people = [];
                  bool isFromCache = false;
                  DateTime? lastUpdated;

                  if (state is SuccessGetPeopleState) {
                    people = state.people;
                    isFromCache = state.isFromCache;
                    lastUpdated = state.lastUpdated;
                  } else if (state is SearchingPeopleState) {
                    people = state.people;
                  }
                  debugPrint(
                      "DEBUG: People length: ${people.length}, isFromCache: $isFromCache");

                  return Column(
                    children: [
                      // Show offline indicator if data is from cache
                      if (isFromCache)
                        OfflineIndicatorWidget(
                          lastUpdated: lastUpdated,
                          onRefresh: () {
                            currentPage = 1;
                            callPeople();
                          },
                        ),
                      // Content
                      Expanded(
                        child: SmartRefresher(
                          controller: _refreshController,
                          onRefresh: () {
                            currentPage = 1;
                            callPeople();
                          },
                          onLoading: () {
                            print(
                                "DEBUG: onLoading called, isLoadingMore: $isLoadingMore, currentPage: $currentPage");
                            // Only load more if not in offline mode
                            if (!isLoadingMore && !isFromCache) {
                              setState(() {
                                isLoadingMore = true;
                              });
                              currentPage++;
                              print("DEBUG: Loading page: $currentPage");
                              _bloc.add(OnGettingPeopleEvent(
                                page: currentPage,
                                searchText: _searchController.text.trim(),
                                withLoading: false,
                              ));
                            } else if (isFromCache) {
                              print(
                                  "DEBUG: Offline mode - no more pagination needed");
                              // Complete the loading since we have all data
                              _refreshController.loadComplete();
                              setState(() {
                                isLoadingMore = false;
                              });
                            }
                          },
                          enablePullDown: true,
                          enablePullUp:
                              !isFromCache, // Disable pull up in offline mode
                          child: people.isEmpty
                              ? Center(
                                  child: Text(
                                    "No people found",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.all(15.sp),
                                  itemCount: people.length,
                                  itemBuilder: (context, index) {
                                    return PersonCardWidget(
                                      person: people[index],
                                      onTap: () {
                                        // Navigate to person details
                                        Navigator.pushNamed(
                                          context,
                                          AppRouteEnum.personDetailsPage.name,
                                          arguments: people[index],
                                        );
                                      },
                                    );
                                  },
                                ),
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    _refreshController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}
