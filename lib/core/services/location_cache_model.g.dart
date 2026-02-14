// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationCacheModelAdapter extends TypeAdapter<LocationCacheModel> {
  @override
  final int typeId = 20;

  @override
  LocationCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationCacheModel(
      city: fields[0] as String?,
      country: fields[1] as String?,
      lat: fields[2] as double,
      lng: fields[3] as double,
      updatedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LocationCacheModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.city)
      ..writeByte(1)
      ..write(obj.country)
      ..writeByte(2)
      ..write(obj.lat)
      ..writeByte(3)
      ..write(obj.lng)
      ..writeByte(4)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
