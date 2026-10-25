import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:basky_vendor/core/translations/locale_keys.g.dart';
import 'package:basky_vendor/features/auth/domain/entities/vendor_type.dart';
import 'auth_phone_field.dart';
import 'auth_text_field.dart';
import 'register_image_picker.dart';
import 'register_vendor_type_field.dart';

class RestaurantRegisterFields extends StatelessWidget {
  final TextEditingController nameEnController;
  final TextEditingController nameArController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final GlobalKey<AuthPhoneFieldState> phoneKey;
  final String? Function(String?) validatePhone;
  final List<VendorType> vendorTypes;
  final int? selectedVendorTypeId;
  final bool isLoadingVendorTypes;
  final ValueChanged<int?> onVendorTypeChanged;
  final String? imagePath;
  final ValueChanged<String> onImagePicked;

  const RestaurantRegisterFields({
    super.key,
    required this.nameEnController,
    required this.nameArController,
    required this.phoneController,
    required this.addressController,
    required this.phoneKey,
    required this.validatePhone,
    required this.vendorTypes,
    required this.selectedVendorTypeId,
    required this.isLoadingVendorTypes,
    required this.onVendorTypeChanged,
    required this.imagePath,
    required this.onImagePicked,
  });

  String get _typeLabel {
    for (final type in vendorTypes) {
      if (type.id == selectedVendorTypeId) return type.name;
    }
    return LocaleKeys.vendorType.tr();
  }

  Map<String, String> get _typeArgs => {'type': _typeLabel};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RegisterVendorTypeField(
          types: vendorTypes,
          selectedId: selectedVendorTypeId,
          isLoading: isLoadingVendorTypes,
          onChanged: onVendorTypeChanged,
        ),
        const SizedBox(height: 12),
        AuthTextField(
          hintText: LocaleKeys.restaurantNameEn.tr(namedArgs: _typeArgs),
          prefixIcon: Icons.store_outlined,
          controller: nameEnController,
          validator: (v) => (v == null || v.isEmpty)
              ? LocaleKeys.restaurantNameEnRequired.tr(namedArgs: _typeArgs)
              : null,
        ),
        const SizedBox(height: 12),
        AuthTextField(
          hintText: LocaleKeys.restaurantNameAr.tr(namedArgs: _typeArgs),
          prefixIcon: Icons.store_outlined,
          controller: nameArController,
          validator: (v) => (v == null || v.isEmpty)
              ? LocaleKeys.restaurantNameArRequired.tr(namedArgs: _typeArgs)
              : null,
        ),
        const SizedBox(height: 12),
        AuthPhoneField(
          key: phoneKey,
          hintText: LocaleKeys.restaurantPhone.tr(namedArgs: _typeArgs),
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
        const SizedBox(height: 12),
        RegisterImagePicker(
          imagePath: imagePath,
          onImagePicked: onImagePicked,
          validator: (v) => (imagePath == null || imagePath!.isEmpty)
              ? LocaleKeys.vendorImageRequired.tr()
              : null,
        ),
      ],
    );
  }
}
