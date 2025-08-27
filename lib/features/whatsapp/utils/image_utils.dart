import 'dart:io';

import 'package:flutter/material.dart';

class ImageUtils {
  static const String _basePath = 'assets/images/whatsapp';

  static const String inviteMemberAndroidDark =
      '$_basePath/invite_member_android_dark.png';
  static const String inviteMemberAndroidLight =
      '$_basePath/invite_member_android_light.png';
  static const String inviteMemberIosDark =
      '$_basePath/invite_member_ios_dark.png';
  static const String inviteMemberIosLight =
      '$_basePath/invite_member_ios_light.png';

  static const String copyLinkAndroidDark =
      '$_basePath/copy_link_android_dark.png';
  static const String copyLinkAndroidLight =
      '$_basePath/copy_link_android_light.png';
  static const String copyLinkIosDark = '$_basePath/copy_link_ios_dark.png';
  static const String copyLinkIosLight = '$_basePath/copy_link_ios_light.png';

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

  static String getInviteMemberImagePath(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isIOS = Platform.isIOS || Platform.isMacOS;
    if (isDarkMode) {
      return isIOS ? inviteMemberIosDark : inviteMemberAndroidDark;
    } else {
      return isIOS ? inviteMemberIosLight : inviteMemberAndroidLight;
    }
  }

  static String getCopyLinkImagePath(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isIOS = Platform.isIOS || Platform.isMacOS;
    if (isDarkMode) {
      return isIOS ? copyLinkIosDark : copyLinkAndroidDark;
    } else {
      return isIOS ? copyLinkIosLight : copyLinkAndroidLight;
    }
  }

  static String getGroupPermissionImagePath(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isIOS = Platform.isIOS || Platform.isMacOS;
    if (isDarkMode) {
      return isIOS ? permissonIosDark : permissonAndroidDark;
    } else {
      return isIOS ? permissonIosLight : permissonAndroidLight;
    }
  }

  static String getInviteLinkImagePath(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isIOS = Platform.isIOS || Platform.isMacOS;
    if (isDarkMode) {
      return isIOS ? inviteLinkIosDark : inviteLinkAndroidDark;
    } else {
      return isIOS ? inviteLinkIosLight : inviteLinkAndroidLight;
    }
  }
}
