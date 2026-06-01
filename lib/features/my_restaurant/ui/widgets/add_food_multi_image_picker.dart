import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AddFoodMultiImagePicker extends StatefulWidget {
  final String title;
  final String pickHint;
  final ValueChanged<List<String>> onImagesPicked;

  const AddFoodMultiImagePicker({
    super.key,
    required this.title,
    required this.pickHint,
    required this.onImagesPicked,
  });

  @override
  State<AddFoodMultiImagePicker> createState() => _AddFoodMultiImagePickerState();
}

class _AddFoodMultiImagePickerState extends State<AddFoodMultiImagePicker> {
  final List<String> _imagePaths = [];
  final _picker = ImagePicker();

  Future<void> _pickImages() async {
    final files = await _picker.pickMultiImage(imageQuality: 85);
    if (files.isEmpty || !mounted) return;
    setState(() {
      _imagePaths.addAll(files.map((file) => file.path));
    });
    widget.onImagesPicked(_imagePaths);
  }

  void _removeImage(int index) {
    setState(() {
      _imagePaths.removeAt(index);
    });
    widget.onImagesPicked(_imagePaths);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _pickImages,
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 1.5),
              borderRadius: BorderRadius.circular(16),
              color: AppColors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_photo_alternate_outlined,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(height: 4),
                Text(widget.title, style: AppTextStyle.fontPrimary12Regular),
                const SizedBox(height: 2),
                Text(
                  widget.pickHint,
                  style: AppTextStyle.fontGrey12Regular,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        if (_imagePaths.isNotEmpty) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imagePaths.length,
              itemBuilder: (context, index) {
                final path = _imagePaths[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(File(path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
