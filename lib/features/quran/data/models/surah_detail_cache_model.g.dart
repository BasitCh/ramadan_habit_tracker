// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah_detail_cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SurahDetailCacheModelAdapter extends TypeAdapter<SurahDetailCacheModel> {
  @override
  final int typeId = 19;

  @override
  SurahDetailCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SurahDetailCacheModel(
      number: fields[0] as int,
      name: fields[1] as String,
      englishName: fields[2] as String,
      englishNameTranslation: fields[3] as String,
      numberOfAyahs: fields[4] as int,
      revelationType: fields[5] as String,
      ayahNumbers: (fields[6] as List).cast<int>(),
      arabicAyahs: (fields[7] as List).cast<String>(),
      translations: (fields[8] as List).cast<String>(),
      fetchedAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SurahDetailCacheModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.englishName)
      ..writeByte(3)
      ..write(obj.englishNameTranslation)
      ..writeByte(4)
      ..write(obj.numberOfAyahs)
      ..writeByte(5)
      ..write(obj.revelationType)
      ..writeByte(6)
      ..write(obj.ayahNumbers)
      ..writeByte(7)
      ..write(obj.arabicAyahs)
      ..writeByte(8)
      ..write(obj.translations)
      ..writeByte(9)
      ..write(obj.fetchedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurahDetailCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
