class PeopleConstants {
  // TMDB API Configuration
  static const String TMDB_BASE_URL = 'https://api.themoviedb.org/3';
  static const String TMDB_IMAGE_BASE_URL = 'https://image.tmdb.org';
  static const String TMDB_TOKEN =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmOWNhNTFhODBhNjZjNzkzYmFhMzhmOTZhN2Q1MWNhYyIsIm5iZiI6MTU5NjQ4MjY0My4xNSwic3ViIjoiNWYyODY0NTNkYmJiNDIwMDMzZTQ1NzE0Iiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.inq_kmNIk_w90ZxUZ3LOaclE27d5lnFPZnq3G4OfXZk';

  // Image Sizes
  static const String TMDB_THUMBNAIL_SIZE = '/t/p/w500';
  static const String TMDB_ORIGINAL_SIZE = '/t/p/original';
  static const String TMDB_SMALL_SIZE = '/t/p/w200';

  // API Endpoints
  static const String POPULAR_PEOPLE_ENDPOINT = '/person/popular';
  static const String PERSON_DETAILS_ENDPOINT = '/person';
  static const String PERSON_IMAGES_ENDPOINT = '/images';

  // UI Constants
  static const int GRID_CROSS_AXIS_COUNT = 3;
  static const double GRID_CHILD_ASPECT_RATIO = 0.7;
  static const double GRID_CROSS_AXIS_SPACING = 8.0;
  static const double GRID_MAIN_AXIS_SPACING = 8.0;

  // Hive Configuration
  static const String PEOPLE_BOX_NAME = 'people_box';
  static const String PEOPLE_METADATA_BOX_NAME = 'people_metadata_box';
  static const String LAST_UPDATE_KEY = 'last_update';

  // Cache Configuration
  static const int CACHE_VALIDITY_HOURS = 24;

  // Pagination
  static const int DEFAULT_PAGE_SIZE = 20;
  static const String DEFAULT_LANGUAGE = 'en-US';
}
