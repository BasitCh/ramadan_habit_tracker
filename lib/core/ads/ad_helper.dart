import 'dart:io';

class AdHelper {
  static String get homeBannerAdUnitId {
    if (Platform.isAndroid) {
      // TODO: Replace with your REAL Android Banner Ad Unit ID
      // Example: 'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx'
      return 'YOUR_ANDROID_BANNER_AD_UNIT_ID';
    }
    if (Platform.isIOS) {
      // TODO: Replace with your REAL iOS Banner Ad Unit ID
      // Example: 'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx'
      return 'YOUR_IOS_BANNER_AD_UNIT_ID';
    }
    throw UnsupportedError('Unsupported platform');
  }
}
