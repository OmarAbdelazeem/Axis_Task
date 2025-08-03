import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:axis_task/src/features/popular_people/presentation/pages/people_page.dart';
import 'package:axis_task/src/features/popular_people/presentation/pages/person_details_page.dart';
import 'package:axis_task/src/features/popular_people/presentation/pages/image_viewer_page.dart';
import 'package:axis_task/src/shared/presentation/pages/main_page.dart';
import 'package:axis_task/src/shared/presentation/pages/photo_view_page.dart';

import 'package:axis_task/src/features/popular_people/domain/models/person_model.dart';

class AppRouter {
  static String currentRoute = "/";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    currentRoute = settings.name ?? "/";
    switch (settings.name) {



      // Photo view page
      case '/photo_view_page':
        return CupertinoPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) {
            Map<String, dynamic>? args =
                settings.arguments as Map<String, dynamic>?;
            assert(args != null, "You should pass 'path' and 'fromNet'");
            return PhotoViewPage(
              path: args!['path'],
              fromNet: args['fromNet'],
            );
          },
        );

      // Movies page
      case '/people_page':
        return CupertinoPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => const PeoplePage(),
        );

      // Person Details page
      case '/person_details_page':
        return CupertinoPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) {
            assert(settings.arguments != null, "PersonModel is required");
            return PersonDetailsPage(
              person: settings.arguments as PersonModel,
            );
          },
        );

      // Image Viewer page
      case '/image_viewer_page':
        return CupertinoPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) {
            Map<String, dynamic>? args =
                settings.arguments as Map<String, dynamic>?;
            assert(args != null, "You should pass 'imageUrl' and 'personName'");
            return ImageViewerPage(
              imageUrl: args!['imageUrl'],
              personName: args['personName'],
            );
          },
        );

      // Main page
      case '/main_page':
        return CupertinoPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => const MainPage(),
        );
      default:
        return CupertinoPageRoute(
          settings: RouteSettings(name: settings.name),
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
