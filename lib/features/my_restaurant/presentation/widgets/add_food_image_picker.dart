import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AddFoodImagePicker extends StatefulWidget {
  final String title;
  final String pickHint;
  final ValueChanged<String> onImagePicked;

  const AddFoodImagePicker({
    super.key,
    required this.title,
    required this.pickHint,
    required this.onImagePicked,
  });

  @override
  State<AddFoodImagePicker> createState() => _AddFoodImagePickerState();
}

class _AddFoodImagePickerState extends State<AddFoodImagePicker> {
  String? _imagePath;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null || !mounted) return;
    setState(() => _imagePath = file.path);
    widget.onImagePicked(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary, width: 1.5),
          borderRadius: BorderRadius.circular(16),
          color: AppColors.white,
        ),
        clipBehavior: Clip.antiAlias,
        child: _imagePath != null
            ? Image.file(File(_imagePath!), fit: BoxFit.cover)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.primary,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(widget.title, style: AppTextStyle.fontPrimary12Regular),
                  const SizedBox(height: 4),
                  Text(
                    widget.pickHint,
                    style: AppTextStyle.fontGrey12Regular,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}
