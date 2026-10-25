import 'package:flutter/material.dart';

class DrawerItemModel {
  final IconData icon;
  final String title;
  final String? subtitle;
  final int? badgeCount;
  final VoidCallback onTap;

  DrawerItemModel({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.badgeCount,
  });
}
