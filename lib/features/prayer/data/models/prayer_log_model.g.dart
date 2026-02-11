// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrayerLogModelAdapter extends TypeAdapter<PrayerLogModel> {
  @override
  final int typeId = 2;

  @override
  PrayerLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrayerLogModel(
      date: fields[0] as DateTime,
      prayers: (fields[1] as Map).cast<String, bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, PrayerLogModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.prayers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
