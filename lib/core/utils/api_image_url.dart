import '../network/api_constants.dart';

/// Builds a full URL for API image paths (`image_url`, storage paths, etc.).
String? resolveApiImageUrl(String? raw) {
  if (raw == null) return null;
  final value = raw.trim();
  if (value.isEmpty) return null;
  if (value.startsWith('http://') || value.startsWith('https://')) {
    return value;
  }
  if (value.startsWith('/')) {
    return '${ApiConstants.baseUrl}$value';
  }
  return '${ApiConstants.baseUrl}/$value';
}
