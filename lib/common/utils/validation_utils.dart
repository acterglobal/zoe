import 'package:zoe/common/utils/common_utils.dart';

class ValidationUtils {
  static bool isValidName(String name) {
    if (name.isEmpty) return false;
    return true;
  }

  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;

    url = CommonUtils.getUrlWithProtocol(url);

    final urlRegex = RegExp(
      r'((([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,})|' // domain
      r'localhost|' // localhost
      r'(\d{1,3}\.){3}\d{1,3})' // OR ip (v4)
      r'(:\d+)?' // optional port
      r'(\/[^\s]*)?$', // optional path
      caseSensitive: false,
    );

    if (urlRegex.hasMatch(url)) {
      try {
        final uri = Uri.parse(url);
        return uri.hasScheme && uri.hasAuthority;
      } catch (e) {
        return false;
      }
    }

    return false;
  }

  static bool isValidWhatsAppGroupLink(String link) {
    final whatsappGroupLinkPattern = RegExp(
      r'^https?:\/\/chat\.whatsapp\.com\/([A-Za-z0-9]{22})(?:\/)?(?:\?[^\s#]*)?$',
    );
    return whatsappGroupLinkPattern.hasMatch(link);
  }
}
