import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:basky_vendor/core/translations/locale_keys.g.dart';
import 'package:basky_vendor/features/auth/domain/entities/vendor_type.dart';

class RegisterVendorTypeField extends StatelessWidget {
  final List<VendorType> types;
  final int? selectedId;
  final bool isLoading;
  final ValueChanged<int?> onChanged;

  const RegisterVendorTypeField({
    super.key,
    required this.types,
    required this.selectedId,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: isLoading
          ? const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            )
          : DropdownButtonFormField<int>(
              key: ValueKey(selectedId),
              initialValue: selectedId,
              isExpanded: true,
              dropdownColor: const Color(0xFF2E5A4C),
              iconEnabledColor: Colors.white,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: LocaleKeys.vendorType.tr(),
                hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
                prefixIcon: const Icon(
                  Icons.category_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                errorStyle: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              items: types
                  .map(
                    (type) => DropdownMenuItem<int>(
                      value: type.id,
                      child: Text(type.name),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
              validator: (value) =>
                  value == null ? LocaleKeys.vendorTypeRequired.tr() : null,
            ),
    );
  }
}
