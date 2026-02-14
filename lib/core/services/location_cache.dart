import 'package:hive/hive.dart';
import 'location_cache_model.dart';
import 'location_service.dart';

abstract class LocationCache {
  Future<void> saveLocation(LocationResult location);
  Future<LocationResult?> getLastLocation();
}

class LocationCacheImpl implements LocationCache {
  final Box<LocationCacheModel> box;

  LocationCacheImpl(this.box);

  @override
  Future<void> saveLocation(LocationResult location) async {
    final model = LocationCacheModel(
      city: location.city,
      country: location.country,
      lat: location.lat,
      lng: location.lng,
      updatedAt: DateTime.now(),
    );
    await box.put('last_location', model);
  }

  @override
  Future<LocationResult?> getLastLocation() async {
    final model = box.get('last_location');
    if (model != null) {
      return LocationResult(
        lat: model.lat,
        lng: model.lng,
        city: model.city,
        country: model.country,
      );
    }
    return null;
  }
}
