// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonImageModel _$PersonImageModelFromJson(Map<String, dynamic> json) =>
    PersonImageModel(
      id: (json['id'] as num?)?.toInt(),
      profiles: (json['profiles'] as List<dynamic>?)
          ?.map((e) => PersonImageProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PersonImageModelToJson(PersonImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profiles': instance.profiles,
    };

PersonImageProfile _$PersonImageProfileFromJson(Map<String, dynamic> json) =>
    PersonImageProfile(
      aspectRatio: (json['aspect_ratio'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toInt(),
      iso6391: json['iso6391'] as String?,
      filePath: json['file_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: (json['vote_count'] as num?)?.toInt(),
      width: (json['width'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PersonImageProfileToJson(PersonImageProfile instance) =>
    <String, dynamic>{
      'aspect_ratio': instance.aspectRatio,
      'height': instance.height,
      'iso6391': instance.iso6391,
      'file_path': instance.filePath,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'width': instance.width,
    };
