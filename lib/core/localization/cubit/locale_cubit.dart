import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cache_helper/local_storage.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(const LocaleState(Locale('ar', 'AE')));

  /// Initialize the locale from cache or device settings
  Future<void> getSavedLocale() async {
    final cachedLanguageCode = await LocalStorage.getLanguage();

    if (cachedLanguageCode != null) {
      emit(LocaleState(Locale(cachedLanguageCode)));
    } else {
      // Check device locale
      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
      if (deviceLocale.languageCode == 'en') {
        await LocalStorage.saveLanguage('en');
        emit(const LocaleState(Locale('en', 'US')));
      } else {
        await LocalStorage.saveLanguage('ar');
        emit(const LocaleState(Locale('ar', 'AE')));
      }
    }
  }

  /// Change and save the locale
  Future<void> changeLocale(String languageCode) async {
    await LocalStorage.saveLanguage(languageCode);
    emit(LocaleState(Locale(languageCode)));
  }
}
