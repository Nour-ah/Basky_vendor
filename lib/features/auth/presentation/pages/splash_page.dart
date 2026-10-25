import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/navigation_utils.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';
import '../pages/account_under_review_page.dart';
import '../pages/auth_options_page.dart';
import '../widgets/splash_body_widget.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocProvider(
        create: (_) => sl<SplashCubit>()..checkAuthSession(),
        child: BlocListener<SplashCubit, SplashState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              current.status != SplashStatus.loading,
          listener: (context, state) {
            if (state.status == SplashStatus.authenticated) {
              final user = state.user;
              if (user != null && !user.isActive) {
                safeNavigate(
                  context,
                  () => Navigator.pushReplacement(
                    context,
                    appRoute((_) => const AccountUnderReviewPage()),
                  ),
                );
                return;
              }

              safeNavigate(
                context,
                () => Navigator.pushReplacement(
                  context,
                  appRoute((_) => HomePage()),
                ),
              );
            } else if (state.status == SplashStatus.unauthenticated) {
              safeNavigate(context, () {
                if (state.message != null && state.message!.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message!),
                      backgroundColor: AppColors.promoRed,
                    ),
                  );
                }
                Navigator.pushReplacement(
                  context,
                  appRoute((_) => const AuthOptionsPage()),
                );
              });
            }
          },
          child: const SplashBodyWidget(),
        ),
      ),
    );
  }
}
