import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basky_vendor/core/config/env_config.dart';
import 'package:basky_vendor/core/di/injection_container.dart';
import 'package:basky_vendor/core/navigation/app_navigator.dart';
import 'package:basky_vendor/core/notifications/firebase_messaging_background.dart';
import 'package:basky_vendor/core/notifications/notifications_services.dart';
import 'package:basky_vendor/core/theme/app_colors.dart';
import 'package:basky_vendor/core/localization/cubit/locale_cubit.dart';
import 'package:basky_vendor/core/widgets/restart_widget.dart';
import 'package:basky_vendor/features/auth/presentation/pages/splash_page.dart';
import 'package:basky_vendor/firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await EasyLocalization.ensureInitialized();
  await EnvConfig.load();
  await initDependencies();

  final notifications = sl<NotificationsServices>();
  await notifications.initLocalNotification();
  await notifications.initFcm(handleInitialMessage: true);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('ar'),
      child: const RestartWidget(child: _AppRoot()),
    ),
  );
}

class _AppRoot extends StatelessWidget {
  const _AppRoot();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocaleCubit>(
      create: (context) => sl<LocaleCubit>()..getSavedLocale(),
      child: const SpiderRestaurantApp(),
    );
  }
}

class SpiderRestaurantApp extends StatefulWidget {
  const SpiderRestaurantApp({super.key});

  @override
  State<SpiderRestaurantApp> createState() => _SpiderRestaurantAppState();
}

class _SpiderRestaurantAppState extends State<SpiderRestaurantApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(sl<NotificationsServices>().processPendingNavigation());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocaleCubit, LocaleState>(
      listener: (context, state) async {
        if (context.locale != state.locale) {
          await context.setLocale(state.locale);
          if (context.mounted) {
            RestartWidget.restartApp(context);
          }
        }
      },
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: AppNavigator.key,
            debugShowCheckedModeBanner: false,
            title: 'Basky Vendor',
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
            theme: ThemeData(
              scaffoldBackgroundColor: AppColors.background,
              primaryColor: AppColors.primary,
              fontFamily: GoogleFonts.cairo().fontFamily,
              textTheme: GoogleFonts.cairoTextTheme(Theme.of(context).textTheme),
              useMaterial3: true,
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.background,
                centerTitle: true,
                iconTheme: const IconThemeData(color: AppColors.primary),
                titleTextStyle: GoogleFonts.cairo(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
