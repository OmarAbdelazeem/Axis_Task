import 'package:json_annotation/json_annotation.dart';

part 'person_image_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PersonImageModel {
  int? id;
  List<PersonImageProfile>? profiles;

  PersonImageModel({
    this.id,
    this.profiles,
  });

  factory PersonImageModel.fromJson(Map<String, dynamic> json) =>
      _$PersonImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonImageModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PersonImageProfile {
  double? aspectRatio;
  int? height;
  String? iso6391;
  String? filePath;
  double? voteAverage;
  int? voteCount;
  int? width;

  PersonImageProfile({
    this.aspectRatio,
    this.height,
    this.iso6391,
    this.filePath,
    this.voteAverage,
    this.voteCount,
    this.width,
  });

  factory PersonImageProfile.fromJson(Map<String, dynamic> json) =>
      _$PersonImageProfileFromJson(json);

  Map<String, dynamic> toJson() => _$PersonImageProfileToJson(this);
} 