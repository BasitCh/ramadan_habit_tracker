import 'package:dartz/dartz.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../error/failures.dart';
import 'location_cache.dart';
import 'location_service.dart';

class LocationServiceImpl implements LocationService {
  final LocationCache locationCache;

  LocationServiceImpl({required this.locationCache});

  @override
  Future<Either<Failure, LocationResult>> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Left(LocationFailure('Location services are disabled.'));
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Left(LocationFailure('Location permissions are denied'));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Left(
        LocationFailure(
          'Location permissions are permanently denied, we cannot request permissions.',
        ),
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition();

      String? city;
      String? country;

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          city =
              placemarks.first.locality ??
              placemarks.first.subAdministrativeArea;
          country = placemarks.first.country;
        }
      } catch (e) {
        // Geocoding failed, but we still have coordinates
      }

      final result = LocationResult(
        lat: position.latitude,
        lng: position.longitude,
        city: city,
        country: country,
      );

      // Cache the new location
      await locationCache.saveLocation(result);

      return Right(result);
    } catch (e) {
      return Left(LocationFailure(e.toString()));
    }
  }

  @override
  Future<LocationResult?> getLastKnownLocation() async {
    return locationCache.getLastLocation();
  }
}
