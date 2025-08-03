import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:axis_task/src/core/styles/app_colors.dart';
import 'package:axis_task/src/core/helper/helper.dart';

class CustomAppBarWidget extends StatelessWidget {
  final double? height;
  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBarWidget({
    Key? key,
    this.height,
    this.leading,
    this.title,
    this.actions,
    this.backgroundColor,
    this.showBackButton = false,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 60.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
      decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
                color: AppColors.darkGray.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(0, 4))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Leading (Back Button or Custom Leading)
          if (leading != null || showBackButton) ...{
            leading ?? _buildBackButton(context),
            SizedBox(
              width: Helper.getHorizontalSpace(),
            ),
          },

          // Title
          if (title != null) ...{
            Expanded(
              child: Center(child: title!),
            ),
            SizedBox(
              width: Helper.getHorizontalSpace(),
            ),
          },

          // Actions
          if (actions != null) ...{
            Row(
              children: actions!.map((e) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                  ),
                  child: e,
                );
              }).toList(),
            ),
          }
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: onBackPressed ?? () => Navigator.of(context).pop(),
      child: Icon(
        Icons.arrow_back_ios_new,
        size: 20.w,
        color: AppColors.black,
      ),
    );
  }
}
