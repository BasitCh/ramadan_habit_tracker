import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ramadan_habit_tracker/core/services/location_service.dart';
import 'package:ramadan_habit_tracker/di/injection_container.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';

class MasjidLocatorPage extends StatefulWidget {
  const MasjidLocatorPage({super.key});

  @override
  State<MasjidLocatorPage> createState() => _MasjidLocatorPageState();
}

class _MasjidLocatorPageState extends State<MasjidLocatorPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final LocationService _locationService = sl<LocationService>();

  CameraPosition? _initialPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    final locationResult = await _locationService.getCurrentLocation();
    locationResult.fold(
      (failure) {
        // Fallback to London if permission denied or error
        if (mounted) {
          setState(() {
            _initialPosition = const CameraPosition(
              target: LatLng(51.5074, -0.1278),
              zoom: 14,
            );
            _isLoading = false;
          });
        }
      },
      (loc) {
        if (mounted) {
          setState(() {
            _initialPosition = CameraPosition(
              target: LatLng(loc.lat, loc.lng),
              zoom: 14,
            );
            _isLoading = false;
          });
        }
      },
    );
  }

  Future<void> _openExternalMap() async {
    // Search for "masjid" nearby
    final Uri url = Uri.parse('geo:0,0?q=masjid');
    if (!await launchUrl(url)) {
      // If geo: scheme fails (e.g. simulator), try google maps web
      final Uri webUrl = Uri.parse(
        'https://www.google.com/maps/search/masjid/',
      );
      await launchUrl(webUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Masjids'), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _initialPosition!,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: ElevatedButton.icon(
                    onPressed: _openExternalMap,
                    icon: const Icon(Icons.map, color: Colors.white),
                    label: const Text('Search in Google Maps'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
