// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adhkar_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdhkarModelAdapter extends TypeAdapter<AdhkarModel> {
  @override
  final int typeId = 15;

  @override
  AdhkarModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdhkarModel(
      id: fields[0] as String,
      arabic: fields[1] as String,
      transliteration: fields[2] as String,
      translation: fields[3] as String,
      repetitions: fields[4] as int,
      reference: fields[5] as String,
      category: fields[6] as String,
      currentCount: fields[7] as int,
      lastResetDate: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AdhkarModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.arabic)
      ..writeByte(2)
      ..write(obj.transliteration)
      ..writeByte(3)
      ..write(obj.translation)
      ..writeByte(4)
      ..write(obj.repetitions)
      ..writeByte(5)
      ..write(obj.reference)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.currentCount)
      ..writeByte(8)
      ..write(obj.lastResetDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdhkarModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
