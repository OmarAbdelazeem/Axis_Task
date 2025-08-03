import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:axis_task/src/core/router/app_route_enum.dart';
import 'package:axis_task/src/shared/presentation/pages/background_page.dart';
import 'package:axis_task/src/shared/presentation/widgets/arrow_back_button_widget.dart';
import 'package:photo_view/photo_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () {
                  Navigator.pushNamed(context, AppRouteEnum.peoplePage.name);
                }, child: Text("People")),
                SizedBox(height: 20.h),
                ElevatedButton(onPressed: () {
                  Navigator.pushNamed(context, AppRouteEnum.articlesPage.name);
                }, child: Text("Articles"))
              ],
            ),
        ),
      ),
    );
  }


}
