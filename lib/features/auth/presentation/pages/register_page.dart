import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spider_restaurant/core/di/injection_container.dart';
import 'package:spider_restaurant/core/theme/app_colors.dart';
import 'package:spider_restaurant/core/translations/locale_keys.g.dart';
import 'package:spider_restaurant/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spider_restaurant/features/auth/presentation/cubit/auth_state.dart';
import 'package:spider_restaurant/features/auth/presentation/pages/login_page.dart';
import 'package:spider_restaurant/features/auth/presentation/pages/verify_phone_screen.dart';
import 'package:spider_restaurant/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:spider_restaurant/features/auth/presentation/widgets/auth_card_widget.dart';
import 'package:spider_restaurant/features/auth/presentation/widgets/register_form_widget.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  void _goToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthRegisterSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => VerifyPhoneScreen(
                  phone: state.phone,
                  email: state.email,
                  registrationMessage: state.message,
                ),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
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
                              isAr ? Icons.arrow_back_ios_new : Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: AuthCardWidget(
                              children: [
                                Text(
                                  LocaleKeys.createAccount.tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                RegisterFormWidget(
                                  isLoading: isLoading,
                                  onGoToLogin: () => _goToLogin(context),
                                ),
                              ],
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
