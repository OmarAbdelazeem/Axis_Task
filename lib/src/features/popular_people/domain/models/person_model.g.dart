// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonModel _$PersonModelFromJson(Map<String, dynamic> json) => PersonModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      profilePath: json['profile_path'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      knownForDepartment: json['known_for_department'] as String?,
      biography: json['biography'] as String?,
      birthday: json['birthday'] as String?,
      deathday: json['deathday'] as String?,
      placeOfBirth: json['place_of_birth'] as String?,
      homepage: json['homepage'] as String?,
      imdbId: json['imdb_id'] as String?,
      knownFor: (json['known_for'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      alsoKnownAs: (json['also_known_as'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      gender: (json['gender'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PersonModelToJson(PersonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profile_path': instance.profilePath,
      'popularity': instance.popularity,
      'known_for_department': instance.knownForDepartment,
      'biography': instance.biography,
      'birthday': instance.birthday,
      'deathday': instance.deathday,
      'place_of_birth': instance.placeOfBirth,
      'homepage': instance.homepage,
      'imdb_id': instance.imdbId,
      'known_for': instance.knownFor,
      'also_known_as': instance.alsoKnownAs,
      'gender': instance.gender,
    };
