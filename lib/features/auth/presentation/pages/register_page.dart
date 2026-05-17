import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spider_restaurant/core/di/injection_container.dart';
import 'package:spider_restaurant/core/theme/app_colors.dart';
import 'package:spider_restaurant/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spider_restaurant/features/auth/presentation/cubit/auth_state.dart';
import 'package:spider_restaurant/features/auth/presentation/pages/login_page.dart';
import 'package:spider_restaurant/features/auth/presentation/pages/verify_phone_screen.dart';
import 'package:spider_restaurant/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:spider_restaurant/features/auth/presentation/widgets/auth_button.dart';
import 'package:spider_restaurant/features/auth/presentation/widgets/auth_card_widget.dart';
import 'package:spider_restaurant/features/auth/presentation/widgets/auth_phone_field.dart';
import 'package:spider_restaurant/features/auth/presentation/widgets/auth_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _ownerPhoneKey = GlobalKey<AuthPhoneFieldState>();
  final _restaurantPhoneKey = GlobalKey<AuthPhoneFieldState>();
  final _ownerNameController = TextEditingController();
  final _ownerEmailController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _restaurantNameEnController = TextEditingController();
  final _restaurantNameArController = TextEditingController();
  final _restaurantPhoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _ownerNameController.dispose();
    _ownerEmailController.dispose();
    _ownerPhoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _restaurantNameEnController.dispose();
    _restaurantNameArController.dispose();
    _restaurantPhoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String? _validateLocalPhone(String? value) {
    if (value == null || value.isEmpty) return 'Enter phone number';
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 8) return 'Enter a valid phone number';
    return null;
  }

  void _goToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: Form(
                              key: _formKey,
                              child: AuthCardWidget(
                                children: [
                                  const Text(
                                    'Create Account',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  AuthTextField(
                                    hintText: 'Owner name',
                                    prefixIcon: Icons.person_outline,
                                    controller: _ownerNameController,
                                    validator: (v) =>
                                        (v == null || v.isEmpty) ? 'Enter owner name' : null,
                                  ),
                                  const SizedBox(height: 12),
                                  AuthTextField(
                                    hintText: 'Email',
                                    prefixIcon: Icons.email_outlined,
                                    controller: _ownerEmailController,
                                    validator: (v) =>
                                        (v == null || v.isEmpty) ? 'Enter your email' : null,
                                  ),
                                  const SizedBox(height: 12),
                                  AuthPhoneField(
                                    key: _ownerPhoneKey,
                                    hintText: 'Phone number',
                                    controller: _ownerPhoneController,
                                    validator: _validateLocalPhone,
                                  ),
                                  const SizedBox(height: 12),
                                  AuthTextField(
                                    hintText: 'Password',
                                    prefixIcon: Icons.lock_outline,
                                    obscureText: true,
                                    controller: _passwordController,
                                    validator: (v) =>
                                        (v == null || v.length < 6) ? 'Min 6 characters' : null,
                                  ),
                                  const SizedBox(height: 12),
                                  AuthTextField(
                                    hintText: 'Confirm password',
                                    prefixIcon: Icons.lock_outline,
                                    obscureText: true,
                                    controller: _confirmPasswordController,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'Confirm your password';
                                      if (v != _passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  AuthTextField(
                                    hintText: 'Restaurant name (English)',
                                    prefixIcon: Icons.store_outlined,
                                    controller: _restaurantNameEnController,
                                    validator: (v) => (v == null || v.isEmpty)
                                        ? 'Enter restaurant name'
                                        : null,
                                  ),
                                  const SizedBox(height: 12),
                                  AuthTextField(
                                    hintText: 'Restaurant name (Arabic)',
                                    prefixIcon: Icons.store_outlined,
                                    controller: _restaurantNameArController,
                                    validator: (v) => (v == null || v.isEmpty)
                                        ? 'Enter Arabic name'
                                        : null,
                                  ),
                                  const SizedBox(height: 12),
                                  AuthPhoneField(
                                    key: _restaurantPhoneKey,
                                    hintText: 'Restaurant phone',
                                    controller: _restaurantPhoneController,
                                    validator: _validateLocalPhone,
                                  ),
                                  const SizedBox(height: 12),
                                  AuthTextField(
                                    hintText: 'Address',
                                    prefixIcon: Icons.location_on_outlined,
                                    controller: _addressController,
                                    validator: (v) =>
                                        (v == null || v.isEmpty) ? 'Enter address' : null,
                                  ),
                                  const SizedBox(height: 24),
                                  AuthButton(
                                    text: 'Sign Up',
                                    backgroundColor: AppColors.promoRed,
                                    isLoading: isLoading,
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            if (_formKey.currentState!.validate()) {
                                              context.read<AuthCubit>().register(
                                                    ownerName: _ownerNameController.text.trim(),
                                                    ownerEmail: _ownerEmailController.text.trim(),
                                                    ownerPhone:
                                                        _ownerPhoneKey.currentState!.fullPhone,
                                                    ownerPassword: _passwordController.text,
                                                    ownerPasswordConfirmation:
                                                        _confirmPasswordController.text,
                                                    restaurantNameEn:
                                                        _restaurantNameEnController.text.trim(),
                                                    restaurantNameAr:
                                                        _restaurantNameArController.text.trim(),
                                                    restaurantPhone:
                                                        _restaurantPhoneKey.currentState!.fullPhone,
                                                    address: _addressController.text.trim(),
                                                  );
                                            }
                                          },
                                  ),
                                  const SizedBox(height: 12),
                                  TextButton(
                                    onPressed: () => _goToLogin(context),
                                    child: const Text(
                                      'Already have an account? Sign In',
                                      style: TextStyle(color: Colors.white, fontSize: 13),
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
