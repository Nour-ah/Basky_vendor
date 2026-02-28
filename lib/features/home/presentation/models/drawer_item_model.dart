import 'package:flutter/material.dart';

class DrawerItemModel {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  DrawerItemModel({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
