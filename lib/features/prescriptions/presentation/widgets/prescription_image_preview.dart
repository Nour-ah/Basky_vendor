import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_image_view.dart';

class PrescriptionImagePreview extends StatelessWidget {
  const PrescriptionImagePreview({
    super.key,
    required this.imageUrl,
    this.height = 180,
  });

  final String? imageUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return GestureDetector(
      onTap: hasImage ? () => _openFullScreen(context, imageUrl!) : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: height,
          width: double.infinity,
          color: AppColors.lightGrey,
          child: hasImage
              ? Hero(
                  tag: imageUrl!,
                  child: CustomImageView(
                    imagePath: imageUrl,
                    height: height,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.grey,
                    size: 40,
                  ),
                ),
        ),
      ),
    );
  }

  static void _openFullScreen(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: AppColors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: AppColors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4,
              child: Hero(
                tag: url,
                child: CustomImageView(
                  imagePath: url,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PrescriptionThumbnail extends StatelessWidget {
  const PrescriptionThumbnail({
    super.key,
    required this.imageUrl,
    this.size = 64,
  });

  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: size,
        height: size,
        child: CustomImageView(
          imagePath: imageUrl ?? '',
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class PrescriptionSectionTitle extends StatelessWidget {
  const PrescriptionSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyle.fontBlack16Bold);
  }
}
