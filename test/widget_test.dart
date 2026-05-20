import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spider_restaurant/core/cache_helper/local_storage.dart';
import 'package:spider_restaurant/core/localization/cubit/locale_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorage.init();
  });

  group('LocaleCubit Tests', () {
    test('initial state is Locale(ar)', () {
      final cubit = LocaleCubit();
      expect(cubit.state.locale, const Locale('ar'));
      cubit.close();
    });

    test('getSavedLocale returns default Arabic if no language is cached', () async {
      final cubit = LocaleCubit();
      await cubit.getSavedLocale();
      final expectedLocale = WidgetsBinding.instance.platformDispatcher.locale.languageCode == 'en' ? const Locale('en') : const Locale('ar');
      expect(cubit.state.locale, expectedLocale);
      cubit.close();
    });

    test('changeLocale changes the language and saves it', () async {
      final cubit = LocaleCubit();
      await cubit.changeLocale('en');
      expect(cubit.state.locale, const Locale('en'));
      
      final savedLang = await LocalStorage.getLanguage();
      expect(savedLang, 'en');
      cubit.close();
    });
  });
}
