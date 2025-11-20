
String? extractSheetIdFromUri(Uri uri) {
  if (uri.scheme != 'https') return null;
  if (uri.host.toLowerCase() != 'hellozoe.app') return null;
  final segments = uri.pathSegments;
  if (segments.length < 2) return null;
  if (segments.first != 'sheet') return null;
  final sheetId = segments[1];
  if (sheetId.isEmpty) return null;
  return sheetId;
}