// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_progress_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuranProgressModelAdapter extends TypeAdapter<QuranProgressModel> {
  @override
  final int typeId = 13;

  @override
  QuranProgressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuranProgressModel(
      currentPage: fields[0] as int,
      pagesReadToday: fields[1] as int,
      lastReadTimestamp: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, QuranProgressModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.currentPage)
      ..writeByte(1)
      ..write(obj.pagesReadToday)
      ..writeByte(2)
      ..write(obj.lastReadTimestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranProgressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
