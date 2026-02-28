import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

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
          Text(
            isClosed
                ? 'The Restaurant is Temporarily Closed'
                : 'The Restaurant is Open',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          Switch(
            value: !isClosed,
            activeColor: AppColors.white,
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
