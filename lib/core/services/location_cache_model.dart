import 'package:hive/hive.dart';

part 'location_cache_model.g.dart';

@HiveType(typeId: 20)
class LocationCacheModel extends HiveObject {
  @HiveField(0)
  final String? city;

  @HiveField(1)
  final String? country;

  @HiveField(2)
  final double lat;

  @HiveField(3)
  final double lng;

  @HiveField(4)
  final DateTime updatedAt;

  LocationCacheModel({
    this.city,
    this.country,
    required this.lat,
    required this.lng,
    required this.updatedAt,
  });
}
