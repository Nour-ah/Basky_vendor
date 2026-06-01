import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/localized_json_parser.dart';

class SafeNetworkImage extends StatelessWidget {
  const SafeNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderIcon = Icons.image_outlined,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final IconData placeholderIcon;

  @override
  Widget build(BuildContext context) {
    final child = isValidNetworkImageUrl(imageUrl)
        ? CachedNetworkImage(
            imageUrl: imageUrl!.trim(),
            width: width,
            height: height,
            fit: fit,
            placeholder: (context, url) => _placeholder(),
            errorWidget: (context, url, error) => _placeholder(),
          )
        : _placeholder();

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.greyLight,
      alignment: Alignment.center,
      child: Icon(
        placeholderIcon,
        color: AppColors.grey,
        size: (height != null && height! < 56) ? 24 : 32,
      ),
    );
  }
}
