import 'package:flutter/widgets.dart';

extension LocalizationExtension on BuildContext {
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';

  String getLocalizedValue(String ar, String en) {
    return isArabic ? ar : en;
  }
}

class LocalizationUtils {
  static String getLocalizedField(
    BuildContext context,
    Map<String, dynamic> data,
    String fieldName,
  ) {
    final isArabic = context.isArabic;
    if (isArabic) {
      // Try Arabic first, then fallback to English/Default
      return data['${fieldName}Ar'] ?? data[fieldName] ?? '';
    } else {
      // Try English/Default first, then fallback to Arabic
      return data[fieldName] ?? data['${fieldName}Ar'] ?? '';
    }
  }
}
