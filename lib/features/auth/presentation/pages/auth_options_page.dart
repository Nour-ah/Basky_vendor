import 'package:basky_vendor/core/theme/app_colors.dart';
import 'package:basky_vendor/core/utils/navigation_utils.dart';
import 'package:basky_vendor/features/auth/presentation/pages/login_page.dart';
import 'package:basky_vendor/features/auth/presentation/pages/register_page.dart';
import 'package:basky_vendor/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:basky_vendor/features/auth/presentation/widgets/auth_button.dart';
import 'package:basky_vendor/features/auth/presentation/widgets/auth_card_widget.dart';
import 'package:flutter/material.dart';

class AuthOptionsPage extends StatelessWidget {
  const AuthOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackgroundWidget()),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        const Spacer(),
                        AuthCardWidget(
                          children: [
                            const Text(
                              'Welcome',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Sign in or create an account to manage\nyour vendor and orders.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 32),
                            AuthButton(
                              text: 'Sign In',
                              backgroundColor: AppColors.white,
                              textColor: AppColors.primary,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  appRoute((_) => const LoginPage()),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            AuthButton(
                              text: 'Sign Up',
                              backgroundColor: AppColors.white,
                              textColor: AppColors.primary,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  appRoute((_) => const RegisterPage()),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
