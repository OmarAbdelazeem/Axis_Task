import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:axis_task/src/core/helper/helper.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_model.dart';
import 'package:axis_task/src/features/popular_people/constants/people_constants.dart';

class PersonCardWidget extends StatelessWidget {
  final PersonModel person;
  final VoidCallback onTap;

  const PersonCardWidget({
    Key? key,
    required this.person,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 15.h),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(12.sp),
          child: Row(
            children: [
              // Person Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: person.profilePath != null
                    ? CachedNetworkImage(
                        imageUrl: '${PeopleConstants.TMDB_IMAGE_BASE_URL}${PeopleConstants.TMDB_SMALL_SIZE}${person.profilePath}',
                        width: 80.w,
                        height: 80.h,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 80.w,
                          height: 80.h,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 40.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 80.w,
                          height: 80.h,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 40.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    : Container(
                        width: 80.w,
                        height: 80.h,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: 40.sp,
                          color: Colors.grey[600],
                        ),
                      ),
              ),
              SizedBox(width: 15.w),
              // Person Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person.name ?? 'Unknown',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5.h),
                    if (person.knownForDepartment != null)
                      Text(
                        person.knownForDepartment!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    SizedBox(height: 5.h),
                    if (person.popularity != null)
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16.sp,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            '${person.popularity!.toStringAsFixed(1)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 