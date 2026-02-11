// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fasting_day_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FastingDayModelAdapter extends TypeAdapter<FastingDayModel> {
  @override
  final int typeId = 4;

  @override
  FastingDayModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FastingDayModel(
      date: fields[0] as DateTime,
      completed: fields[1] as bool,
      notes: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FastingDayModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.completed)
      ..writeByte(2)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FastingDayModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
