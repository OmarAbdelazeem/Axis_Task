// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonHiveModelAdapter extends TypeAdapter<PersonHiveModel> {
  @override
  final int typeId = 0;

  @override
  PersonHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonHiveModel()
      ..id = fields[0] as int?
      ..name = fields[1] as String?
      ..profilePath = fields[2] as String?
      ..popularity = fields[3] as double?
      ..knownForDepartment = fields[4] as String?
      ..biography = fields[5] as String?
      ..birthday = fields[6] as String?
      ..deathday = fields[7] as String?
      ..placeOfBirth = fields[8] as String?
      ..homepage = fields[9] as String?
      ..imdbId = fields[10] as String?
      ..alsoKnownAs = (fields[11] as List?)?.cast<String>()
      ..gender = fields[12] as int?
      ..lastUpdated = fields[13] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, PersonHiveModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.profilePath)
      ..writeByte(3)
      ..write(obj.popularity)
      ..writeByte(4)
      ..write(obj.knownForDepartment)
      ..writeByte(5)
      ..write(obj.biography)
      ..writeByte(6)
      ..write(obj.birthday)
      ..writeByte(7)
      ..write(obj.deathday)
      ..writeByte(8)
      ..write(obj.placeOfBirth)
      ..writeByte(9)
      ..write(obj.homepage)
      ..writeByte(10)
      ..write(obj.imdbId)
      ..writeByte(11)
      ..write(obj.alsoKnownAs)
      ..writeByte(12)
      ..write(obj.gender)
      ..writeByte(13)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
