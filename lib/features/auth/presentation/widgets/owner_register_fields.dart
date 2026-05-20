import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spider_restaurant/core/translations/locale_keys.g.dart';
import 'auth_phone_field.dart';
import 'auth_text_field.dart';

class OwnerRegisterFields extends StatelessWidget {
  final TextEditingController ownerNameController;
  final TextEditingController ownerEmailController;
  final TextEditingController ownerPhoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<AuthPhoneFieldState> ownerPhoneKey;
  final String? Function(String?) validatePhone;

  const OwnerRegisterFields({
    super.key,
    required this.ownerNameController,
    required this.ownerEmailController,
    required this.ownerPhoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.ownerPhoneKey,
    required this.validatePhone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthTextField(
          hintText: LocaleKeys.ownerName.tr(),
          prefixIcon: Icons.person_outline,
          controller: ownerNameController,
          validator: (v) =>
              (v == null || v.isEmpty) ? LocaleKeys.ownerNameRequired.tr() : null,
        ),
        const SizedBox(height: 12),
        AuthTextField(
          hintText: LocaleKeys.email.tr(),
          prefixIcon: Icons.email_outlined,
          controller: ownerEmailController,
          validator: (v) =>
              (v == null || v.isEmpty) ? LocaleKeys.emailRequired.tr() : null,
        ),
        const SizedBox(height: 12),
        AuthPhoneField(
          key: ownerPhoneKey,
          hintText: LocaleKeys.phoneNumber.tr(),
          controller: ownerPhoneController,
          validator: validatePhone,
        ),
        const SizedBox(height: 12),
        AuthTextField(
          hintText: LocaleKeys.password.tr(),
          prefixIcon: Icons.lock_outline,
          obscureText: true,
          controller: passwordController,
          validator: (v) =>
              (v == null || v.length < 6) ? LocaleKeys.passwordLengthError.tr() : null,
        ),
        const SizedBox(height: 12),
        AuthTextField(
          hintText: LocaleKeys.confirmPassword.tr(),
          prefixIcon: Icons.lock_outline,
          obscureText: true,
          controller: confirmPasswordController,
          validator: (v) {
            if (v == null || v.isEmpty) return LocaleKeys.confirmPasswordRequired.tr();
            if (v != passwordController.text) return LocaleKeys.passwordsDoNotMatch.tr();
            return null;
          },
        ),
      ],
    );
  }
}
