import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spider_restaurant/core/theme/app_colors.dart';
import 'package:spider_restaurant/features/auth/presentation/pages/auth_options_page.dart';

void main() async {
  // Ensure that widget binding is initialized before using native services.
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  // TODO: Initialize Dependency Injection (GetIt) and local storages here
  // await di.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('ar'), // Defaulting to arabic for the user
      child: const SpiderRestaurantApp(),
    ),
  );
}

class SpiderRestaurantApp extends StatelessWidget {
  const SpiderRestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spider Restaurant App',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },

      // Main Theme configuration for the entire application
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        fontFamily: 'CoHeadline', // Default font family
        useMaterial3: true,

        // Define common app bar behavior
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.primary),
        ),
      ),

      // Set the Auth Options Page as the starting point of the application
      home: const AuthOptionsPage(),
    );
  }
}
