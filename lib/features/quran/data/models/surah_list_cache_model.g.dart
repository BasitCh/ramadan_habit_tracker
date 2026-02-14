// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah_list_cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SurahListCacheModelAdapter extends TypeAdapter<SurahListCacheModel> {
  @override
  final int typeId = 18;

  @override
  SurahListCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SurahListCacheModel(
      numbers: (fields[0] as List).cast<int>(),
      names: (fields[1] as List).cast<String>(),
      englishNames: (fields[2] as List).cast<String>(),
      englishNameTranslations: (fields[3] as List).cast<String>(),
      ayahCounts: (fields[4] as List).cast<int>(),
      revelationTypes: (fields[5] as List).cast<String>(),
      fetchedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SurahListCacheModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.numbers)
      ..writeByte(1)
      ..write(obj.names)
      ..writeByte(2)
      ..write(obj.englishNames)
      ..writeByte(3)
      ..write(obj.englishNameTranslations)
      ..writeByte(4)
      ..write(obj.ayahCounts)
      ..writeByte(5)
      ..write(obj.revelationTypes)
      ..writeByte(6)
      ..write(obj.fetchedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurahListCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
