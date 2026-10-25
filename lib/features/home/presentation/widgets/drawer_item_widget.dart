import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/drawer_item_model.dart';

class DrawerItemWidget extends StatelessWidget {
  const DrawerItemWidget({
    super.key,
    required this.item,
    required this.textStyle,
    this.trailingColor = AppColors.black,
  });

  final DrawerItemModel item;
  final TextStyle textStyle;
  final Color trailingColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 0,
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(item.icon, color: AppColors.primary, size: 20),
        ),
        title: Text(item.title, style: textStyle),
        subtitle: item.subtitle == null
            ? null
            : Text(item.subtitle!, style: AppTextStyle.fontGrey12Regular),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.badgeCount != null && item.badgeCount! > 0)
              Container(
                margin: const EdgeInsetsDirectional.only(end: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.promoRed,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${item.badgeCount}',
                  style: AppTextStyle.fontWhite14Regular.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            Icon(Icons.arrow_forward_ios, size: 14, color: trailingColor),
          ],
        ),
        onTap: item.onTap,
      ),
    );
  }
}
