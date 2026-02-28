import 'package:flutter/material.dart';
import '../localization/translation/ar_translation.dart';
import '../localization/translation/en_translation.dart';

class AppStrings {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': enTranslation,
    'ar': arTranslation,
  };

  static String tr(BuildContext context, String key) {
    try {
      final locale = Localizations.localeOf(context).languageCode;
      return _localizedValues[locale]?[key] ??
          _localizedValues['ar']?[key] ??
          key;
    } catch (e) {
      return key;
    }
  }
}
