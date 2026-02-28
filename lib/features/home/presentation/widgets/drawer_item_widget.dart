import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
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
            color: AppColors.primary.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(item.icon, color: AppColors.primary, size: 20),
        ),
        title: Text(item.title, style: textStyle),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: trailingColor),
        onTap: item.onTap,
      ),
    );
  }
}
