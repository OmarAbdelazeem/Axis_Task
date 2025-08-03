import 'package:axis_task/src/core/helper/helper.dart';
import 'package:axis_task/src/core/router/app_route_enum.dart';
import 'package:axis_task/src/core/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    Future.delayed(
      Duration(
        seconds: 1,
      ),
      () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouteEnum.peoplePage.name,
          (route) => false,
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15.sp),
          child: Icon(Icons.movie_creation_outlined,size: 100.sp,),
        ),
      ),
    );
  }
}
