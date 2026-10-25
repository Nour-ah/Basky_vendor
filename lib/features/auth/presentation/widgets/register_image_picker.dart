import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:basky_vendor/core/translations/locale_keys.g.dart';

class RegisterImagePicker extends StatelessWidget {
  final String? imagePath;
  final ValueChanged<String> onImagePicked;
  final String? Function(String?)? validator;

  const RegisterImagePicker({
    super.key,
    required this.imagePath,
    required this.onImagePicked,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      key: ValueKey(imagePath),
      initialValue: imagePath,
      validator: validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () async {
                final file = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 85,
                );
                if (file == null) return;
                onImagePicked(file.path);
                field.didChange(file.path);
              },
              child: Container(
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: field.hasError
                      ? Border.all(color: Colors.white70)
                      : null,
                ),
                clipBehavior: Clip.antiAlias,
                child: imagePath != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(File(imagePath!), fit: BoxFit.cover),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.55),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_a_photo_outlined,
                            color: Colors.white,
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            LocaleKeys.vendorImage.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
