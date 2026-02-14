import 'package:dartz/dartz.dart';
import '../error/failures.dart';

class LocationResult {
  final double lat;
  final double lng;
  final String? city;
  final String? country;

  LocationResult({
    required this.lat,
    required this.lng,
    this.city,
    this.country,
  });
}

abstract class LocationService {
  Future<Either<Failure, LocationResult>> getCurrentLocation();
  Future<LocationResult?> getLastKnownLocation();
}
