import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spider_restaurant/core/theme/app_colors.dart';
import 'package:spider_restaurant/core/translations/locale_keys.g.dart';
import 'package:spider_restaurant/features/auth/presentation/cubit/auth_cubit.dart';
import 'auth_button.dart';
import 'auth_phone_field.dart';
import 'owner_register_fields.dart';
import 'restaurant_register_fields.dart';

class RegisterFormWidget extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onGoToLogin;

  const RegisterFormWidget({
    super.key,
    required this.isLoading,
    required this.onGoToLogin,
  });

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
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
    if (value == null || value.isEmpty) return LocaleKeys.phoneRequired.tr();
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 8) return LocaleKeys.phoneLengthError.tr();
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().register(
            ownerName: _ownerNameController.text.trim(),
            ownerEmail: _ownerEmailController.text.trim(),
            ownerPhone: _ownerPhoneKey.currentState!.fullPhone,
            ownerPassword: _passwordController.text,
            ownerPasswordConfirmation: _confirmPasswordController.text,
            restaurantNameEn: _restaurantNameEnController.text.trim(),
            restaurantNameAr: _restaurantNameArController.text.trim(),
            restaurantPhone: _restaurantPhoneKey.currentState!.fullPhone,
            address: _addressController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OwnerRegisterFields(
            ownerNameController: _ownerNameController,
            ownerEmailController: _ownerEmailController,
            ownerPhoneController: _ownerPhoneController,
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
            ownerPhoneKey: _ownerPhoneKey,
            validatePhone: _validateLocalPhone,
          ),
          const SizedBox(height: 12),
          RestaurantRegisterFields(
            nameEnController: _restaurantNameEnController,
            nameArController: _restaurantNameArController,
            phoneController: _restaurantPhoneController,
            addressController: _addressController,
            phoneKey: _restaurantPhoneKey,
            validatePhone: _validateLocalPhone,
          ),
          const SizedBox(height: 24),
          AuthButton(
            text: LocaleKeys.createAccount.tr(),
            backgroundColor: AppColors.promoRed,
            isLoading: widget.isLoading,
            onPressed: widget.isLoading ? null : _submit,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: widget.onGoToLogin,
            child: Text(
              LocaleKeys.alreadyHaveAccount.tr(),
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
