// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith_cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HadithCacheModelAdapter extends TypeAdapter<HadithCacheModel> {
  @override
  final int typeId = 17;

  @override
  HadithCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HadithCacheModel(
      text: fields[0] as String,
      book: fields[1] as String,
      reference: fields[2] as String,
      narrator: fields[3] as String?,
      fetchedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HadithCacheModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.book)
      ..writeByte(2)
      ..write(obj.reference)
      ..writeByte(3)
      ..write(obj.narrator)
      ..writeByte(4)
      ..write(obj.fetchedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HadithCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
