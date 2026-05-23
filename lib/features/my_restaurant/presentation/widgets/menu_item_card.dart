import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/safe_network_image.dart';
import '../models/menu_item_model.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItemModel item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MenuItemCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SafeNetworkImage(
                imageUrl: item.imageUrl,
                width: 76,
                height: 76,
                borderRadius: BorderRadius.circular(12),
                placeholderIcon: Icons.fastfood_outlined,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: AppTextStyle.fontBlack14Bold),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '\$ ${item.price.toStringAsFixed(2)}',
                          style: AppTextStyle.fontGreen14Bold.copyWith(
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            ' • ${item.categoryName}',
                            style: AppTextStyle.fontGrey12Regular,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.primary,
                  size: 20,
                ),
                onPressed: onEdit,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: AppColors.promoRed,
                  size: 20,
                ),
                onPressed: onDelete,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border, height: 1),
        ],
      ),
    );
  }
}
