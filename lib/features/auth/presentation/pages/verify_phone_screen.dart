import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spider_restaurant/core/di/injection_container.dart';
import 'package:spider_restaurant/core/theme/app_colors.dart';
import 'package:spider_restaurant/core/translations/locale_keys.g.dart';
import 'package:spider_restaurant/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spider_restaurant/features/auth/presentation/cubit/auth_state.dart';
import 'package:spider_restaurant/features/auth/presentation/pages/login_page.dart';
import 'package:spider_restaurant/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:spider_restaurant/features/auth/presentation/widgets/auth_button.dart';
import 'package:spider_restaurant/features/auth/presentation/widgets/auth_card_widget.dart';
import 'package:spider_restaurant/features/auth/presentation/widgets/auth_otp_field.dart';

class VerifyPhoneScreen extends StatefulWidget {
  final String phone;
  final String email;
  final String? registrationMessage;

  const VerifyPhoneScreen({
    super.key,
    required this.phone,
    required this.email,
    this.registrationMessage,
  });

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _goToLogin(BuildContext context, {String? message}) {
    if (message != null && message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  String? _validateOtp(String? value) {
    if (value == null || value.isEmpty) return LocaleKeys.otpRequired.tr();
    if (value.length < 6) return LocaleKeys.otpLengthError.tr();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthVerifyPhoneSuccess) {
            _goToLogin(context, message: state.message);
          } else if (state is AuthResendCodeSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.success),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.promoRed),
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
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                            child: Form(
                              key: _formKey,
                              child: AuthCardWidget(
                                children: [
                                  Text(
                                    LocaleKeys.verifyPhone.tr(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  if (widget.registrationMessage != null &&
                                      widget.registrationMessage!.isNotEmpty)
                                    Text(
                                      widget.registrationMessage!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                        height: 1.4,
                                      ),
                                    ),
                                  const SizedBox(height: 8),
                                  Text(
                                    LocaleKeys.enterVerificationCode.tr(
                                      namedArgs: {'phone': widget.phone},
                                    ),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  AuthOtpField(
                                    controller: _otpController,
                                    validator: _validateOtp,
                                  ),
                                  const SizedBox(height: 24),
                                  AuthButton(
                                    text: LocaleKeys.verify.tr(),
                                    backgroundColor: AppColors.promoRed,
                                    isLoading: isLoading,
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            if (_formKey.currentState!.validate()) {
                                              context.read<AuthCubit>().verifyPhone(
                                                    phone: widget.phone,
                                                    code: _otpController.text.trim(),
                                                  );
                                            }
                                          },
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            context
                                                .read<AuthCubit>()
                                                .resendVerificationCode(email: widget.email);
                                          },
                                    child: Text(
                                      LocaleKeys.resendCode.tr(),
                                      style: const TextStyle(color: Colors.white, fontSize: 13),
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
