import 'dart:io';

class AppConstants {
  //-----------------------------------------------------------#
  // App Information
  //-----------------------------------------------------------#
  static const String appName = 'Zoe';

  //-----------------------------------------------------------#
  // Store Information
  //-----------------------------------------------------------#
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=app.hellozoe';
  static const String appStoreUrl =
      'https://apps.apple.com/us/app/zoe-nextgen-productivity/id6751025071';

  static String get storeUrl {
    if (Platform.isAndroid) return playStoreUrl;
    if (Platform.isIOS) return appStoreUrl;
    return "";
  }

  //-----------------------------------------------------------#
  // Contact Email
  //-----------------------------------------------------------#
  static const String contactEmail = 'hello@hellozoe.app';

  //-----------------------------------------------------------#
  // App URLs
  //-----------------------------------------------------------#
  static const String appDomainUrl = 'https://hellozoe.app';
  static const String termsAndConditionsUrl = '$appDomainUrl/terms';
  static const String privacyPolicyUrl = '$appDomainUrl/privacy';
}
