import 'dart:io';

class AdHelper {
  static String get homeBannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6133760272441806/1880768582';
    }
    if (Platform.isIOS) {
      // TODO: Replace with your REAL iOS Banner Ad Unit ID if different
      // Currently using the same one or placeholder if you only have one.
      // Based on typical AdMob setup, iOS needs its own unit ID.
      return 'YOUR_IOS_BANNER_AD_UNIT_ID';
    }
    throw UnsupportedError('Unsupported platform');
  }
}
