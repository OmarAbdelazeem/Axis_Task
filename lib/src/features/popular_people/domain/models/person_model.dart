import 'package:json_annotation/json_annotation.dart';

part 'person_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PersonModel {
  int? id;
  String? name;
  String? profilePath;
  double? popularity;
  String? knownForDepartment;
  String? biography;
  String? birthday;
  String? deathday;
  String? placeOfBirth;
  String? homepage;
  String? imdbId;
  List<Map<String, dynamic>>? knownFor;
  List<String>? alsoKnownAs;
  int? gender;

  PersonModel({
    this.id,
    this.name,
    this.profilePath,
    this.popularity,
    this.knownForDepartment,
    this.biography,
    this.birthday,
    this.deathday,
    this.placeOfBirth,
    this.homepage,
    this.imdbId,
    this.knownFor,
    this.alsoKnownAs,
    this.gender,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) =>
      _$PersonModelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonModelToJson(this);

  static List<PersonModel> fromJsonList(List? json) {
    return json?.map((e) => PersonModel.fromJson(e)).toList() ?? [];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    if (other is PersonModel) {
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;
} 