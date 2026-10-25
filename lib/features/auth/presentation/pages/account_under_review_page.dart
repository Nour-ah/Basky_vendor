import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basky_vendor/core/di/injection_container.dart';
import 'package:basky_vendor/core/theme/app_colors.dart';
import 'package:basky_vendor/core/translations/locale_keys.g.dart';
import 'package:basky_vendor/core/utils/navigation_utils.dart';
import 'package:basky_vendor/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:basky_vendor/features/auth/presentation/cubit/auth_state.dart';
import 'package:basky_vendor/features/auth/presentation/pages/auth_options_page.dart';
import 'package:basky_vendor/features/auth/presentation/pages/login_page.dart';
import 'package:basky_vendor/features/auth/presentation/pages/verify_email_screen.dart';
import 'package:basky_vendor/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:basky_vendor/features/auth/presentation/widgets/auth_button.dart';
import 'package:basky_vendor/features/auth/presentation/widgets/auth_card_widget.dart';
import 'package:basky_vendor/features/home/presentation/pages/home_page.dart';

class AccountUnderReviewPage extends StatelessWidget {
  final String? message;
  final bool requiresLogin;

  const AccountUnderReviewPage({
    super.key,
    this.message,
    this.requiresLogin = false,
  });

  void _goHome(BuildContext context) {
    safeNavigate(
      context,
      () => Navigator.pushAndRemoveUntil(
        context,
        appRoute((_) => HomePage()),
        (route) => false,
      ),
    );
  }

  void _goLogin(BuildContext context) {
    safeNavigate(
      context,
      () => Navigator.pushAndRemoveUntil(
        context,
        appRoute((_) => const LoginPage()),
        (route) => false,
      ),
    );
  }

  void _goAuthOptions(BuildContext context) {
    safeNavigate(
      context,
      () => Navigator.pushAndRemoveUntil(
        context,
        appRoute((_) => const AuthOptionsPage()),
        (route) => false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) =>
            current is AuthUserLoaded ||
            current is AuthLogoutSuccess ||
            current is AuthError,
        listener: (context, state) {
          if (state is AuthUserLoaded) {
            if (state.user.isActive) {
              if (state.user.isVerified ||
                  (state.user.emailVerifiedAt != null &&
                      state.user.emailVerifiedAt!.isNotEmpty)) {
                _goHome(context);
              } else {
                safeNavigate(
                  context,
                  () => Navigator.pushReplacement(
                    context,
                    appRoute(
                      (_) => VerifyEmailScreen(email: state.user.email),
                    ),
                  ),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(LocaleKeys.accountStillUnderReview.tr()),
                  backgroundColor: AppColors.primary,
                ),
              );
            }
          } else if (state is AuthLogoutSuccess) {
            _goAuthOptions(context);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.promoRed,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Scaffold(
            backgroundColor: AppColors.primary,
            body: Stack(
              children: [
                const Positioned.fill(child: AuthBackgroundWidget()),
                Positioned.fill(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                      child: Center(
                        child: AuthCardWidget(
                          children: [
                            const Icon(
                              Icons.hourglass_top_rounded,
                              color: Colors.white,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              LocaleKeys.accountUnderReview.tr(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              message?.isNotEmpty == true
                                  ? message!
                                  : LocaleKeys.accountUnderReviewMessage.tr(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 28),
                            if (requiresLogin)
                              AuthButton(
                                text: LocaleKeys.signIn.tr(),
                                backgroundColor: AppColors.white,
                                textColor: AppColors.primary,
                                onPressed: () => _goLogin(context),
                              )
                            else ...[
                              AuthButton(
                                text: LocaleKeys.checkAccountStatus.tr(),
                                backgroundColor: AppColors.white,
                                textColor: AppColors.primary,
                                isLoading: isLoading,
                                onPressed: isLoading
                                    ? null
                                    : () => context
                                        .read<AuthCubit>()
                                        .getCurrentUser(),
                              ),
                              const SizedBox(height: 12),
                              AuthButton(
                                text: LocaleKeys.logout.tr(),
                                backgroundColor: AppColors.promoRed,
                                onPressed: isLoading
                                    ? null
                                    : () => context.read<AuthCubit>().logout(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
