import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:axis_task/src/shared/presentation/pages/background_page.dart';
import 'package:axis_task/src/shared/presentation/widgets/app_loader.dart';
import 'package:axis_task/src/shared/presentation/widgets/custom_app_bar_widget.dart';
import 'package:axis_task/src/shared/presentation/widgets/reload_widget.dart';
import 'package:axis_task/src/shared/presentation/widgets/cached_image_widget.dart';
import 'package:axis_task/src/core/utils/injections.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_model.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_image_model.dart';
import 'package:axis_task/src/features/popular_people/domain/usecases/get_person_details_usecase.dart';
import 'package:axis_task/src/features/popular_people/domain/usecases/get_person_images_usecase.dart';
import 'package:axis_task/src/features/popular_people/presentation/bloc/person_details_bloc/person_details_bloc.dart';
import 'package:axis_task/src/features/popular_people/presentation/bloc/person_images_bloc/person_images_bloc.dart';
import 'package:axis_task/src/features/popular_people/constants/people_constants.dart';
import 'package:axis_task/src/core/router/app_route_enum.dart';

class PersonDetailsPage extends StatefulWidget {
  final PersonModel person;

  const PersonDetailsPage({Key? key, required this.person}) : super(key: key);

  @override
  State<PersonDetailsPage> createState() => _PersonDetailsPageState();
}

class _PersonDetailsPageState extends State<PersonDetailsPage> {
  PersonDetailsBloc _personDetailsBloc = PersonDetailsBloc(
    getPersonDetailsUseCase: sl<GetPersonDetailsUseCase>(),
  );
  
  PersonImagesBloc _personImagesBloc = PersonImagesBloc(
    getPersonImagesUseCase: sl<GetPersonImagesUseCase>(),
  );

  // Key for scaffold to open drawer
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Load person details and images
    _personDetailsBloc.add(OnGettingPersonDetailsEvent(widget.person.id!));
    _personImagesBloc.add(OnGettingPersonImagesEvent(widget.person.id!));
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
            showBackButton: true,
            title: Text(
              widget.person.name ?? "Person Details",
              style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w600),
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(15.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Person Header Section
                  _buildPersonHeader(),
                  SizedBox(height: 20.h),
                  
                  // Person Details Section
                  _buildPersonDetails(),
                  SizedBox(height: 20.h),
                  
                  // Person Images Section
                  _buildPersonImages(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Image
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: widget.person.profilePath != null
              ? CachedImageWidget(
                  imageUrl: "${PeopleConstants.TMDB_IMAGE_BASE_URL}${PeopleConstants.TMDB_THUMBNAIL_SIZE}${widget.person.profilePath}",
                  width: 120.w,
                  height: 180.h,
                )
              : Container(
                  width: 120.w,
                  height: 180.h,
                  color: Colors.grey[300],
                  child: Icon(Icons.person, size: 50.sp),
                ),
        ),
        SizedBox(width: 15.w),
        
        // Person Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.person.name ?? "Unknown",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              if (widget.person.knownForDepartment != null) ...[
                Text(
                  widget.person.knownForDepartment!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8.h),
              ],
              if (widget.person.popularity != null) ...[
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      "Popularity: ${widget.person.popularity!.toStringAsFixed(1)}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonDetails() {
    return BlocBuilder<PersonDetailsBloc, PersonDetailsState>(
      bloc: _personDetailsBloc,
      builder: (context, state) {
        if (state is LoadingPersonDetailsState) {
          return AppLoader();
        } else if (state is ErrorPersonDetailsState) {
          return ReloadWidget.error(
            content: state.message,
            onPressed: () {
              _personDetailsBloc.add(OnGettingPersonDetailsEvent(widget.person.id!));
            },
          );
        } else if (state is SuccessPersonDetailsState) {
          final person = state.person;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Biography",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              if (person.biography != null && person.biography!.isNotEmpty)
                Text(
                  person.biography!,
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              else
                Text(
                  "No biography available.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              SizedBox(height: 20.h),
              
              // Additional Details
              if (person.birthday != null) ...[
                _buildDetailRow("Birthday", person.birthday!),
              ],
              if (person.placeOfBirth != null) ...[
                _buildDetailRow("Place of Birth", person.placeOfBirth!),
              ],
              if (person.homepage != null) ...[
                _buildDetailRow("Homepage", person.homepage!),
              ],
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              "$label:",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonImages() {
    return BlocBuilder<PersonImagesBloc, PersonImagesState>(
      bloc: _personImagesBloc,
      builder: (context, state) {
        if (state is LoadingPersonImagesState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Images",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              AppLoader(),
            ],
          );
        } else if (state is ErrorPersonImagesState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Images",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              ReloadWidget.error(
                content: state.message,
                onPressed: () {
                  _personImagesBloc.add(OnGettingPersonImagesEvent(widget.person.id!));
                },
              ),
            ],
          );
        } else if (state is SuccessPersonImagesState) {
          final images = state.images;
          if (images.profiles?.isEmpty ?? true) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Images",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "No images available.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            );
          }
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Images",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: PeopleConstants.GRID_CROSS_AXIS_COUNT,
                  crossAxisSpacing: PeopleConstants.GRID_CROSS_AXIS_SPACING.w,
                  mainAxisSpacing: PeopleConstants.GRID_MAIN_AXIS_SPACING.h,
                  childAspectRatio: PeopleConstants.GRID_CHILD_ASPECT_RATIO,
                ),
                itemCount: images.profiles?.length ?? 0,
                itemBuilder: (context, index) {
                  final image = images.profiles![index];
                  final imageUrl = "${PeopleConstants.TMDB_IMAGE_BASE_URL}${PeopleConstants.TMDB_ORIGINAL_SIZE}${image.filePath}";
                  final thumbnailUrl = "${PeopleConstants.TMDB_IMAGE_BASE_URL}${PeopleConstants.TMDB_THUMBNAIL_SIZE}${image.filePath}";
                  
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouteEnum.photoViewPage.name,
                        arguments: {
                          "path": imageUrl,
                          "fromNet": true,
                        },
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Hero(
                        tag: imageUrl,
                        child: CachedImageWidget(
                          imageUrl: thumbnailUrl,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  @override
  void dispose() {
    _personDetailsBloc.close();
    _personImagesBloc.close();
    super.dispose();
  }
} 