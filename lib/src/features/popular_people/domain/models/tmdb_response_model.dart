import 'package:flutter/foundation.dart';

class TmdbResponse<T> {
  TmdbResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  late final int? page;
  late final T? results;
  late final int? totalPages;
  late final int? totalResults;

  static fromJson<T>(Map<dynamic, dynamic> json, Function tFromJson) {
    return TmdbResponse<T>(
      page: json['page'],
      results: tFromJson(json['results']),
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    if (other is TmdbResponse) {
      return other.results is List
          ? listEquals(other.results, results as List)
          : other.results == results;
    }

    return false;
  }
} 