import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../cubit/reset_password_cubit.dart';
import '../cubit/reset_password_state.dart';
import '../widgets/auth_background_widget.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_card_widget.dart';
import '../widgets/auth_otp_field.dart';

class VerifyResetCodeScreen extends StatefulWidget {
  final String email;

  const VerifyResetCodeScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyResetCodeScreen> createState() => _VerifyResetCodeScreenState();
}

class _VerifyResetCodeScreenState extends State<VerifyResetCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      builder: (context, state) {
        final isLoading = state is ResetPasswordVerifyingCode;
        final errorMessage = state is ResetPasswordError ? state.message : null;

        return Stack(
          children: [
            const Positioned.fill(child: AuthBackgroundWidget()),
            Positioned.fill(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Form(
                    key: _formKey,
                    child: AuthCardWidget(
                      children: [
                        const Icon(
                          Icons.verified_user,
                          color: Colors.white,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          LocaleKeys.verifyCode.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${LocaleKeys.verifyCodeSubtitle.tr()}\n${widget.email}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    errorMessage,
                                    style: const TextStyle(color: Colors.white, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        AuthOtpField(
                          controller: _otpController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LocaleKeys.pleaseEnterCode.tr();
                            }
                            if (value.length < 6) {
                              return LocaleKeys.codeLengthError.tr();
                            }
                            return null;
                          },
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
                                    context.read<ResetPasswordCubit>().verifyCode(
                                          code: _otpController.text.trim(),
                                        );
                                  }
                                },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LocaleKeys.didntReceiveCode.tr(),
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () {
                                      context.read<ResetPasswordCubit>().sendResetCode(
                                            email: widget.email,
                                          );
                                    },
                              child: Text(
                                LocaleKeys.resendCode.tr(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
