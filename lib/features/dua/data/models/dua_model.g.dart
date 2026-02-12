// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dua_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DuaModelAdapter extends TypeAdapter<DuaModel> {
  @override
  final int typeId = 14;

  @override
  DuaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DuaModel(
      id: fields[0] as String,
      arabic: fields[1] as String,
      transliteration: fields[2] as String,
      translation: fields[3] as String,
      reference: fields[4] as String,
      isBookmarked: fields[5] as bool,
      isRecited: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DuaModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.arabic)
      ..writeByte(2)
      ..write(obj.transliteration)
      ..writeByte(3)
      ..write(obj.translation)
      ..writeByte(4)
      ..write(obj.reference)
      ..writeByte(5)
      ..write(obj.isBookmarked)
      ..writeByte(6)
      ..write(obj.isRecited);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DuaModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
