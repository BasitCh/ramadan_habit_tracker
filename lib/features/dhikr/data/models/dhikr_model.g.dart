// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dhikr_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DhikrModelAdapter extends TypeAdapter<DhikrModel> {
  @override
  final int typeId = 5;

  @override
  DhikrModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DhikrModel(
      id: fields[0] as String,
      name: fields[1] as String,
      targetCount: fields[2] as int,
      currentCount: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DhikrModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.targetCount)
      ..writeByte(3)
      ..write(obj.currentCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DhikrModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
