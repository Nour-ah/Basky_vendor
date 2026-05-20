import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spider_restaurant/core/translations/locale_keys.g.dart';
import 'auth_phone_field.dart';
import 'auth_text_field.dart';

class RestaurantRegisterFields extends StatelessWidget {
  final TextEditingController nameEnController;
  final TextEditingController nameArController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final GlobalKey<AuthPhoneFieldState> phoneKey;
  final String? Function(String?) validatePhone;

  const RestaurantRegisterFields({
    super.key,
    required this.nameEnController,
    required this.nameArController,
    required this.phoneController,
    required this.addressController,
    required this.phoneKey,
    required this.validatePhone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthTextField(
          hintText: LocaleKeys.restaurantNameEn.tr(),
          prefixIcon: Icons.store_outlined,
          controller: nameEnController,
          validator: (v) =>
              (v == null || v.isEmpty) ? LocaleKeys.restaurantNameEnRequired.tr() : null,
        ),
        const SizedBox(height: 12),
        AuthTextField(
          hintText: LocaleKeys.restaurantNameAr.tr(),
          prefixIcon: Icons.store_outlined,
          controller: nameArController,
          validator: (v) =>
              (v == null || v.isEmpty) ? LocaleKeys.restaurantNameArRequired.tr() : null,
        ),
        const SizedBox(height: 12),
        AuthPhoneField(
          key: phoneKey,
          hintText: LocaleKeys.restaurantPhone.tr(),
          controller: phoneController,
          validator: validatePhone,
        ),
        const SizedBox(height: 12),
        AuthTextField(
          hintText: LocaleKeys.address.tr(),
          prefixIcon: Icons.location_on_outlined,
          controller: addressController,
          validator: (v) =>
              (v == null || v.isEmpty) ? LocaleKeys.addressRequired.tr() : null,
        ),
      ],
    );
  }
}
