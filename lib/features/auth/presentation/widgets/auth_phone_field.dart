import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthPhoneField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(CountryCode country)? onCountryChanged;
  final String initialCountryCode;

  const AuthPhoneField({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
    this.onCountryChanged,
    this.initialCountryCode = 'EG',
  });

  static String formatFullPhone(CountryCode country, String localNumber) {
    final digits = localNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return '';
    final dialCode = country.dialCode ?? '';
    return '$dialCode$digits';
  }

  @override
  State<AuthPhoneField> createState() => AuthPhoneFieldState();
}

class AuthPhoneFieldState extends State<AuthPhoneField> {
  late CountryCode _selectedCountry;

  CountryCode get selectedCountry => _selectedCountry;

  String get fullPhone =>
      AuthPhoneField.formatFullPhone(_selectedCountry, widget.controller.text);

  @override
  void initState() {
    super.initState();
    _selectedCountry = CountryCode.fromCountryCode(widget.initialCountryCode);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CountryCodePicker(
            onChanged: (country) {
              setState(() => _selectedCountry = country);
              widget.onCountryChanged?.call(country);
            },
            initialSelection: widget.initialCountryCode,
            favorite: const ['EG', 'SA', 'AE', 'KW', 'QA', 'BH', 'OM', 'JO', 'LB'],
            showCountryOnly: false,
            showOnlyCountryWhenClosed: false,
            alignLeft: false,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            textStyle: const TextStyle(color: Colors.white, fontSize: 14),
            dialogTextStyle: const TextStyle(color: Colors.black87),
            searchDecoration: const InputDecoration(
              hintText: 'Search country',
              border: OutlineInputBorder(),
            ),
            flagDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Container(
            width: 1,
            height: 28,
            color: Colors.white.withValues(alpha: 0.4),
          ),
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              validator: widget.validator,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                errorStyle: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
