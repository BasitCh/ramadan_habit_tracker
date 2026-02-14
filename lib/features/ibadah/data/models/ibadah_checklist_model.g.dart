// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ibadah_checklist_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IbadahChecklistModelAdapter extends TypeAdapter<IbadahChecklistModel> {
  @override
  final int typeId = 16;

  @override
  IbadahChecklistModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IbadahChecklistModel(
      dateKey: fields[0] as String,
      items: (fields[1] as List).cast<String>(),
      values: (fields[2] as List).cast<bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, IbadahChecklistModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.dateKey)
      ..writeByte(1)
      ..write(obj.items)
      ..writeByte(2)
      ..write(obj.values);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IbadahChecklistModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
