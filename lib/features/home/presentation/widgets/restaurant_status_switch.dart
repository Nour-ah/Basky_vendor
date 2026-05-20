import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/translations/locale_keys.g.dart';

class RestaurantStatusSwitch extends StatefulWidget {
  const RestaurantStatusSwitch({super.key});

  @override
  State<RestaurantStatusSwitch> createState() => _RestaurantStatusSwitchState();
}

class _RestaurantStatusSwitchState extends State<RestaurantStatusSwitch> {
  bool isClosed = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              isClosed
                  ? LocaleKeys.restaurantClosed.tr()
                  : LocaleKeys.restaurantOpen.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: !isClosed,
            activeThumbColor: AppColors.white,
            activeTrackColor: AppColors.success,
            inactiveThumbColor: AppColors.white,
            inactiveTrackColor: AppColors.greyLight,
            onChanged: (value) {
              setState(() {
                isClosed = !value;
              });
            },
          ),
        ],
      ),
    );
  }
}
