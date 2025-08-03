enum AppRouteEnum {
  articlesPage,
  articleDetailsPage,
  weViewPage,
  photoViewPage,
  mainPage,
  peoplePage,
  personDetailsPage,
  imageViewerPage
}

extension AppRouteExtension on AppRouteEnum {
  String get name {
    switch (this) {
      case AppRouteEnum.articlesPage:
        return "/articles_page";

      case AppRouteEnum.articleDetailsPage:
        return "/article_details_page";

      case AppRouteEnum.weViewPage:
        return "/web_view_page";

      case AppRouteEnum.photoViewPage:
        return "/photo_view_page";

      case AppRouteEnum.mainPage:
        return "/main_page";

      case AppRouteEnum.peoplePage:
        return "/people_page";

      case AppRouteEnum.personDetailsPage:
        return "/person_details_page";

      case AppRouteEnum.imageViewerPage:
        return "/image_viewer_page";

      default:
        return "/articles_page";
    }
  }
}
