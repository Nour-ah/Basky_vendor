import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthOtpField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const AuthOtpField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 6,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 12,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          hintText: '• • • • • •',
          hintStyle: TextStyle(
            color: Colors.white54,
            fontSize: 20,
            letterSpacing: 8,
          ),
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
          errorStyle: TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ),
    );
  }
}
