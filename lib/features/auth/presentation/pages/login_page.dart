import 'package:basky_vendor/core/di/injection_container.dart';
import 'package:basky_vendor/core/theme/app_colors.dart';
import 'package:basky_vendor/core/utils/navigation_utils.dart';
import 'package:basky_vendor/core/translations/locale_keys.g.dart';
import 'package:basky_vendor/features/auth/domain/entities/user.dart';
import 'package:basky_vendor/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:basky_vendor/features/auth/presentation/cubit/auth_state.dart';
import 'package:basky_vendor/features/auth/presentation/pages/account_under_review_page.dart';
import 'package:basky_vendor/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:basky_vendor/features/auth/presentation/pages/register_page.dart';
import 'package:basky_vendor/features/auth/presentation/pages/verify_email_screen.dart';
import 'package:basky_vendor/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:basky_vendor/features/auth/presentation/widgets/auth_button.dart';
import 'package:basky_vendor/features/auth/presentation/widgets/auth_card_widget.dart';
import 'package:basky_vendor/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:basky_vendor/features/home/presentation/pages/home_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToHome(BuildContext context) {
    safeNavigate(
      context,
      () => Navigator.pushAndRemoveUntil(
        context,
        appRoute((_) => HomePage()),
        (route) => false,
      ),
    );
  }

  void _goToRegister(BuildContext context) {
    Navigator.push(
      context,
      appRoute((_) => const RegisterPage()),
    );
  }

  void _navigateAfterLogin(BuildContext context, User user) {
    if (!user.isActive) {
      safeNavigate(
        context,
        () => Navigator.pushAndRemoveUntil(
          context,
          appRoute((_) => const AccountUnderReviewPage()),
          (route) => false,
        ),
      );
      return;
    }

    if (user.isVerified) {
      _goToHome(context);
    } else if (user.emailVerifiedAt == null || user.emailVerifiedAt!.isEmpty) {
      safeNavigate(
        context,
        () => Navigator.pushReplacement(
          context,
          appRoute((_) => VerifyEmailScreen(email: user.email)),
        ),
      );
    } else {
      _goToHome(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) =>
            current is AuthLoginSuccess || current is AuthError,
        listener: (context, state) {
          if (state is AuthLoginSuccess) {
            _navigateAfterLogin(context, state.user);
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
                    child: Column(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: IconButton(
                            icon: Icon(
                              isAr
                                  ? Icons.arrow_back_ios_new
                                  : Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(24, 350, 24, 24),
                            child: Form(
                              key: _formKey,
                              child: AuthCardWidget(
                                children: [
                                  Text(
                                    LocaleKeys.login.tr(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  AuthTextField(
                                    hintText: LocaleKeys.email.tr(),
                                    prefixIcon: Icons.email_outlined,
                                    controller: _emailController,
                                    validator: (value) =>
                                        (value == null || value.isEmpty)
                                        ? LocaleKeys.emailRequired.tr()
                                        : null,
                                  ),
                                  const SizedBox(height: 16),
                                  AuthTextField(
                                    hintText: LocaleKeys.password.tr(),
                                    prefixIcon: Icons.lock_outline,
                                    obscureText: true,
                                    controller: _passwordController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return LocaleKeys.passwordRequired.tr();
                                      }
                                      if (value.length < 6) {
                                        return LocaleKeys.passwordLengthError
                                            .tr();
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  AuthButton(
                                    text: LocaleKeys.signIn.tr(),
                                    backgroundColor: AppColors.white,
                                    textColor: AppColors.primary,
                                    isLoading: isLoading,
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              context.read<AuthCubit>().login(
                                                login: _emailController.text
                                                    .trim(),
                                                password:
                                                    _passwordController.text,
                                              );
                                            }
                                          },
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      appRoute(
                                        (_) => const ForgotPasswordPage(),
                                      ),
                                    ),
                                    child: Text(
                                      LocaleKeys.forgotPassword.tr(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  TextButton(
                                    onPressed: () => _goToRegister(context),
                                    child: Text(
                                      LocaleKeys.dontHaveAccount.tr(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
