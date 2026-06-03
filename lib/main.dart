import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spider_restaurant/core/di/injection_container.dart';
import 'package:spider_restaurant/core/theme/app_colors.dart';
import 'package:spider_restaurant/core/localization/cubit/locale_cubit.dart';
import 'package:spider_restaurant/core/widgets/restart_widget.dart';
import 'package:spider_restaurant/features/auth/presentation/pages/splash_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  // Ensure that widget binding is initialized before using native services.
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await initDependencies();

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

class SpiderRestaurantApp extends StatelessWidget {
  const SpiderRestaurantApp({super.key});

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

            theme: ThemeData(
              scaffoldBackgroundColor: AppColors.background,
              primaryColor: AppColors.primary,
              textTheme: context.locale.languageCode == 'ar'
                  ? GoogleFonts.cairoTextTheme(Theme.of(context).textTheme)
                  : GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
              useMaterial3: true,

              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.background,
                centerTitle: true,
                iconTheme: const IconThemeData(color: AppColors.primary),
                titleTextStyle: context.locale.languageCode == 'ar'
                    ? GoogleFonts.cairo(
                        color: AppColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )
                    : GoogleFonts.poppins(
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
