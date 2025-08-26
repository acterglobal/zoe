import 'dart:io';

import 'package:flutter/material.dart';

class ImageUtils {
  static const String _basePath = 'assets/images/whatsapp/';

  static const String permissonAndroidDark =
      '$_basePath/permisson_android_dark.png';
  static const String permissonAndroidLight =
      '$_basePath/permisson_android_light.png';
  static const String permissonIosDark = '$_basePath/permisson_ios_dark.png';
  static const String permissonIosLight = '$_basePath/permisson_ios_light.png';

  static const String inviteLinkAndroidDark =
      '$_basePath/invite_link_android_dark.png';
  static const String inviteLinkAndroidLight =
      '$_basePath/invite_link_android_light.png';
  static const String inviteLinkIosDark = '$_basePath/invite_link_ios_dark.png';
  static const String inviteLinkIosLight =
      '$_basePath/invite_link_ios_light.png';

  static String getImagePath({
    required BuildContext context,
    bool isGroupPermission = false,
    bool isInviteLink = false,
  }) {
    if (!isGroupPermission && !isInviteLink) return '';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isIOS = Platform.isIOS || Platform.isMacOS;
    if (isDarkMode) {
      if (isIOS) {
        return isGroupPermission ? permissonIosDark : inviteLinkIosDark;
      } else {
        return isGroupPermission ? permissonAndroidDark : inviteLinkAndroidDark;
      }
    } else {
      if (isIOS) {
        return isGroupPermission ? permissonIosLight : inviteLinkIosLight;
      } else {
        return isGroupPermission
            ? permissonAndroidLight
            : inviteLinkAndroidLight;
      }
    }
  }
}
