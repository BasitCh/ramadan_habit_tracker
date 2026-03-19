import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:ramadan_habit_tracker/app/theme/app_colors.dart';
import 'package:ramadan_habit_tracker/core/services/location_service.dart';
import 'package:ramadan_habit_tracker/di/injection_container.dart';

enum _PermissionStatus { checking, denied }

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  _PermissionStatus _status = _PermissionStatus.checking;
  bool _isPermanentlyDenied = false;
  bool _isServiceDisabled = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
    _requestPermissionAndNavigate();
  }

  Future<void> _requestPermissionAndNavigate() async {
    // Let animation play first
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    await _checkAndRequest();
  }

  Future<void> _checkAndRequest() async {
    try {
      final locationService = sl<LocationService>();
      final result = await locationService.getCurrentLocation();
      if (!mounted) return;
      result.fold(
        (failure) {
          setState(() {
            _status = _PermissionStatus.denied;
            _isPermanentlyDenied = failure.message.contains('permanently denied');
            _isServiceDisabled = failure.message.contains('services are disabled');
          });
        },
        (_) => context.go('/home'),
      );
    } catch (_) {
      if (mounted) setState(() => _status = _PermissionStatus.denied);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F6FF), AppColors.primaryLight],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _status == _PermissionStatus.denied
            ? _buildPermissionRequired(context)
            : _buildSplashContent(context),
      ),
    );
  }

  Widget _buildSplashContent(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height * 0.2,
          left: MediaQuery.of(context).size.width * 0.15,
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) => Opacity(
              opacity: _fadeAnimation.value * 0.2,
              child: const Icon(
                Icons.dark_mode,
                size: 60,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.25,
          right: MediaQuery.of(context).size.width * 0.2,
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) => Opacity(
              opacity: _fadeAnimation.value * 0.15,
              child: const Icon(
                Icons.star,
                size: 30,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(scale: _scaleAnimation.value, child: child),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ',
                  style: TextStyle(
                    fontSize: 22,
                    color: AppColors.textPrimary.withValues(alpha: 0.6),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 64),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD97D).withValues(alpha: 0.3),
                        blurRadius: 80,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.mosque_rounded,
                    size: 120,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 64),
                Text(
                  'NOOR PLANNER',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 8,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 1,
                      color: AppColors.textPrimary.withValues(alpha: 0.2),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'SPIRITUAL COMPANION',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 6,
                        color: AppColors.textPrimary.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 32,
                      height: 1,
                      color: AppColors.textPrimary.withValues(alpha: 0.2),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 80,
          left: 0,
          right: 0,
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) =>
                Opacity(opacity: _fadeAnimation.value * 0.4, child: child),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(1),
                const SizedBox(width: 12),
                _buildDot(2),
                const SizedBox(width: 12),
                _buildDot(3),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionRequired(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on,
                size: 44,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Location Required',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              _isServiceDisabled
                  ? 'Please enable location services on your device. Noor Planner uses your location to calculate accurate prayer times.'
                  : _isPermanentlyDenied
                      ? 'Location permission was denied. Please open App Settings and grant location access to continue.'
                      : 'Noor Planner requires your location to calculate accurate prayer times for your city.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (_isServiceDisabled) {
                    await Geolocator.openLocationSettings();
                  } else if (_isPermanentlyDenied) {
                    await Geolocator.openAppSettings();
                  }
                  if (mounted) await _checkAndRequest();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.settings),
                label: Text(
                  _isServiceDisabled
                      ? 'Open Location Settings'
                      : _isPermanentlyDenied
                          ? 'Open App Settings'
                          : 'Grant Permission',
                ),
              ),
            ),
            if (!_isServiceDisabled && !_isPermanentlyDenied) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async => _checkAndRequest(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.textPrimary.withValues(alpha: value),
          ),
        );
      },
    );
  }
}
