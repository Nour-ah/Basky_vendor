import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/reset_password_cubit.dart';
import '../cubit/reset_password_state.dart';
import '../widgets/auth_background_widget.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_card_widget.dart';


class SetNewPasswordScreen extends StatefulWidget {
  final String email;
  final String resetToken;

  const SetNewPasswordScreen({
    super.key,
    required this.email,
    required this.resetToken,
  });

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      builder: (context, state) {
        final isLoading = state is ResetPasswordSettingPassword;
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
                          Icons.lock_open,
                          color: Colors.white,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Set New Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Create a new password for your account.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
                        // Password field
                        _buildPasswordField(
                          controller: _passwordController,
                          hintText: 'New password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Confirm password field
                        _buildPasswordField(
                          controller: _confirmPasswordController,
                          hintText: 'Confirm new password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        AuthButton(
                          text: 'Reset Password',
                          backgroundColor: AppColors.promoRed,
                          isLoading: isLoading,
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<ResetPasswordCubit>().setNewPassword(
                                          password: _passwordController.text,
                                          passwordConfirmation: _confirmPasswordController.text,
                                        );
                                  }
                                },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.arrow_back, color: Colors.white70, size: 16),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                context.read<ResetPasswordCubit>().reset();
                              },
                              child: const Text(
                                'Start over',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    final isObsured = hintText.contains('Confirm') ? _obscureConfirmPassword : _obscurePassword;
    final onTapObscure = hintText.contains('Confirm')
        ? () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword)
        : () => setState(() => _obscurePassword = !_obscurePassword);

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: isObsured,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.white, size: 20),
          suffixIcon: IconButton(
            icon: Icon(
              isObsured ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
              size: 20,
            ),
            onPressed: onTapObscure,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          errorStyle: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ),
    );
  }
}