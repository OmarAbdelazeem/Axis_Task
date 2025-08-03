import 'package:hive/hive.dart';
import 'package:axis_task/src/features/popular_people/domain/models/person_model.dart';

part 'person_hive_model.g.dart';

@HiveType(typeId: 0)
class PersonHiveModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? profilePath;

  @HiveField(3)
  double? popularity;

  @HiveField(4)
  String? knownForDepartment;

  @HiveField(5)
  String? biography;

  @HiveField(6)
  String? birthday;

  @HiveField(7)
  String? deathday;

  @HiveField(8)
  String? placeOfBirth;

  @HiveField(9)
  String? homepage;

  @HiveField(10)
  String? imdbId;

  @HiveField(11)
  List<String>? alsoKnownAs;

  @HiveField(12)
  int? gender;

  @HiveField(13)
  DateTime? lastUpdated;

  // Convert from PersonModel to PersonHiveModel
  static PersonHiveModel fromPersonModel(PersonModel person) {
    return PersonHiveModel()
      ..id = person.id
      ..name = person.name
      ..profilePath = person.profilePath
      ..popularity = person.popularity
      ..knownForDepartment = person.knownForDepartment
      ..biography = person.biography
      ..birthday = person.birthday
      ..deathday = person.deathday
      ..placeOfBirth = person.placeOfBirth
      ..homepage = person.homepage
      ..imdbId = person.imdbId
      ..alsoKnownAs = person.alsoKnownAs
      ..gender = person.gender
      ..lastUpdated = DateTime.now();
  }

  // Convert from PersonHiveModel to PersonModel
  PersonModel toPersonModel() {
    return PersonModel(
      id: id,
      name: name,
      profilePath: profilePath,
      popularity: popularity,
      knownForDepartment: knownForDepartment,
      biography: biography,
      birthday: birthday,
      deathday: deathday,
      placeOfBirth: placeOfBirth,
      homepage: homepage,
      imdbId: imdbId,
      alsoKnownAs: alsoKnownAs,
      gender: gender,
    );
  }
} 