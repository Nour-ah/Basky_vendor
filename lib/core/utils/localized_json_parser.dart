/// Parses API fields that may be a plain string or `{ "en": "...", "ar": "..." }`.
String parseLocalizedJsonValue(
  dynamic value, {
  String preferredLanguageCode = 'en',
}) {
  if (value == null) return '';
  if (value is String) return value;

  if (value is Map) {
    final preferred = value[preferredLanguageCode]?.toString();
    if (preferred != null && preferred.isNotEmpty) return preferred;

    final en = value['en']?.toString();
    if (en != null && en.isNotEmpty) return en;

    final ar = value['ar']?.toString();
    if (ar != null && ar.isNotEmpty) return ar;

    for (final entry in value.entries) {
      final text = entry.value?.toString();
      if (text != null && text.isNotEmpty) return text;
    }
  }

  return value.toString();
}

bool isValidNetworkImageUrl(String? url) {
  final trimmed = url?.trim() ?? '';
  return trimmed.startsWith('http://') || trimmed.startsWith('https://');
}
