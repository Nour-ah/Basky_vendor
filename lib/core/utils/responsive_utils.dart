import 'package:flutter/material.dart';

class ResponsiveUtils {
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;
  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;
  
  // Also useful to check width directly in some cases
  static double width(BuildContext context) => MediaQuery.of(context).size.width;
}
