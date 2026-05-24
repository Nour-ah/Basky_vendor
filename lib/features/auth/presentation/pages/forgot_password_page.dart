import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../cubit/reset_password_cubit.dart';
import '../cubit/reset_password_state.dart';
import '../widgets/reset_password_step_indicator.dart';
import 'enter_email_screen.dart';
import 'login_page.dart';
import 'set_new_password_screen.dart';
import 'verify_reset_code_screen.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ResetPasswordCubit>(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatelessWidget {
  const _ForgotPasswordView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          _showSuccessAndNavigateToLogin(context);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'forgotPasswordTitle'.tr(),
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
              builder: (context, state) {
                // Determine current step for the indicator
                int currentStep = _getCurrentStep(state);

                return Column(
                  children: [
                    const SizedBox(height: 20),
                    // Step Indicator
                    ResetPasswordStepIndicator(currentStep: currentStep),
                    const SizedBox(height: 24),
                    // Step content
                    Expanded(
                      child: _buildStepContent(context, state),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  int _getCurrentStep(ResetPasswordState state) {
    if (state is ResetPasswordInitial ||
        state is ResetPasswordSendingCode ||
        state is ResetPasswordError) {
      return 1;
    } else if (state is ResetPasswordCodeSent ||
        state is ResetPasswordVerifyingCode) {
      return 2;
    } else if (state is ResetPasswordCodeVerified ||
        state is ResetPasswordSettingPassword) {
      return 3;
    }
    return 1;
  }

  Widget _buildStepContent(BuildContext context, ResetPasswordState state) {
    if (state is ResetPasswordCodeSent ||
        state is ResetPasswordVerifyingCode ||
        state is ResetPasswordCodeVerified ||
        state is ResetPasswordSettingPassword ||
        state is ResetPasswordError && state.email != null) {
      final email = state is ResetPasswordCodeSent
          ? state.email
          : state is ResetPasswordVerifyingCode
              ? state.email
              : state is ResetPasswordCodeVerified
                  ? state.email
                  : state is ResetPasswordSettingPassword
                      ? state.email
                      : (state as ResetPasswordError).email;

      if (state is ResetPasswordCodeVerified ||
          state is ResetPasswordSettingPassword ||
          (state is ResetPasswordError && state.resetToken != null)) {
        final resetToken = state is ResetPasswordCodeVerified
            ? state.resetToken
            : state is ResetPasswordSettingPassword
                ? state.resetToken
                : (state as ResetPasswordError).resetToken;

        return SetNewPasswordScreen(
          email: email ?? '',
          resetToken: resetToken ?? '',
        );
      }

      return VerifyResetCodeScreen(email: email ?? '');
    }

    // Default: Step 1 - Enter Email
    return const EnterEmailScreen();
  }

  void _showSuccessAndNavigateToLogin(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 64),
        title: Text('success'.tr()),
        content: Text(
          'passwordResetSuccessMessage'.tr(),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: Text('goToLogin'.tr()),
          ),
        ],
      ),
    );
  }
}
