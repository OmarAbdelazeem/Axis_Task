import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:axis_task/src/core/network/error/dio_error_handler.dart';
import 'package:axis_task/src/core/network/error/exceptions.dart';
import 'package:axis_task/src/features/popular_people/data/data_sources/remote/abstract_people_api.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_model.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_image_model.dart';
import 'package:axis_task/src/features/popular_people/domain/models/people_params.dart';
import 'package:axis_task/src/features/popular_people/domain/models/tmdb_response_model.dart';
import 'package:axis_task/src/features/popular_people/constants/people_constants.dart';

class PeopleApiImpl extends AbstractPeopleApi {
  final Dio dio;
  static const String _baseUrl = PeopleConstants.TMDB_BASE_URL;
  static const String _token = PeopleConstants.TMDB_TOKEN;

  CancelToken cancelToken = CancelToken();
  
  // Configured Dio instance for TMDB API
  late final Dio _tmdbDio;

  PeopleApiImpl(this.dio) {
    _tmdbDio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => status! < 300,
        responseType: ResponseType.json,
      ),
    );
  }

  // Cancel all ongoing requests
  void cancelRequests() {
    cancelToken.cancel("Request cancelled by user");
  }

  // Reset cancel token for new requests
  void resetCancelToken() {
    cancelToken = CancelToken();
  }

  String _getPopularPeoplePath(PeopleParams params) {
    return '$_baseUrl${PeopleConstants.POPULAR_PEOPLE_ENDPOINT}?page=${params.page}&language=${params.language}';
  }

  String _getPersonDetailsPath(int personId) {
    return '$_baseUrl${PeopleConstants.PERSON_DETAILS_ENDPOINT}/$personId';
  }

  String _getPersonImagesPath(int personId) {
    return '$_baseUrl${PeopleConstants.PERSON_DETAILS_ENDPOINT}/$personId${PeopleConstants.PERSON_IMAGES_ENDPOINT}';
  }

  // Get Popular People
  @override
  Future<TmdbResponse<List<PersonModel>>> getPopularPeople(
    PeopleParams params,
  ) async {
    try {
      debugPrint("getPopularPeoplePath: ${_getPopularPeoplePath(params)}");
      debugPrint("Authorization header: Bearer $_token");

      final result = await _tmdbDio.get(
        _getPopularPeoplePath(params),
        cancelToken: cancelToken,
      );

      debugPrint("Response status: ${result.statusCode}");
      debugPrint("Response data: ${result.data}");

      if (result.data == null) {
        throw ServerException("Unknown Error", result.statusCode);
      }

      return TmdbResponse.fromJson<List<PersonModel>>(
        result.data,
        PersonModel.fromJsonList,
      );
    } on DioError catch (e) {
      debugPrint("DioError occurred: ${e.message}");
      debugPrint("DioError type: ${e.type}");
      debugPrint("DioError response status: ${e.response?.statusCode}");
      debugPrint("DioError response data: ${e.response?.data}");

      if (e.type == DioErrorType.cancel) {
        throw CancelTokenException("Request cancelled", e.response?.statusCode);
      } else {
        String errorMessage = "Unknown error occurred";
        if (e.response?.data != null && e.response?.data is Map) {
          errorMessage =
              e.response?.data['status_message'] ??
              e.response?.data['message'] ??
              "API Error: ${e.response?.statusCode}";
        } else {
          errorMessage = "Network error: ${e.message}";
        }
        throw ServerException(errorMessage, e.response?.statusCode);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  // Get Person Details
  @override
  Future<PersonModel> getPersonDetails(int personId) async {
    try {
      final result = await _tmdbDio.get(
        _getPersonDetailsPath(personId),
        cancelToken: cancelToken,
      );

      if (result.data == null) {
        throw ServerException("Unknown Error", result.statusCode);
      }

      return PersonModel.fromJson(result.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) {
        throw CancelTokenException("Request cancelled", e.response?.statusCode);
      } else {
        String errorMessage = "Unknown error occurred";
        if (e.response?.data != null && e.response?.data is Map) {
          errorMessage =
              e.response?.data['status_message'] ??
              e.response?.data['message'] ??
              "API Error: ${e.response?.statusCode}";
        } else {
          errorMessage = "Network error: ${e.message}";
        }
        throw ServerException(errorMessage, e.response?.statusCode);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  // Get Person Images
  @override
  Future<PersonImageModel> getPersonImages(int personId) async {
    try {
      final result = await _tmdbDio.get(
        _getPersonImagesPath(personId),
        cancelToken: cancelToken,
      );

      if (result.data == null) {
        throw ServerException("Unknown Error", result.statusCode);
      }

      return PersonImageModel.fromJson(result.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) {
        throw CancelTokenException("Request cancelled", e.response?.statusCode);
      } else {
        String errorMessage = "Unknown error occurred";
        if (e.response?.data != null && e.response?.data is Map) {
          errorMessage =
              e.response?.data['status_message'] ??
              e.response?.data['message'] ??
              "API Error: ${e.response?.statusCode}";
        } else {
          errorMessage = "Network error: ${e.message}";
        }
        throw ServerException(errorMessage, e.response?.statusCode);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }
}
