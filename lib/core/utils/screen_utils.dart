import 'package:flutter/material.dart';

class ScreenUtils {
  ScreenUtils._();

  static late double screenWidth;
  static late double screenHeight;
  static late double statusBarHeight;
  static late double bottomBarHeight;

  /// Initialize screen dimensions
  /// Call this in your main widget's build method or in MaterialApp's builder
  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
    statusBarHeight = mediaQuery.padding.top;
    bottomBarHeight = mediaQuery.padding.bottom;
  }

  /// Get screen width
  static double get width => screenWidth;

  /// Get screen height
  static double get height => screenHeight;

  /// Get responsive width based on design width (default: 375)
  /// Example: getWidth(100) returns proportional width for 100px in design
  static double getWidth(double width, {double designWidth = 375}) {
    return (width / designWidth) * screenWidth;
  }

  /// Get responsive height based on design height (default: 812)
  /// Example: getHeight(100) returns proportional height for 100px in design
  static double getHeight(double height, {double designHeight = 812}) {
    return (height / designHeight) * screenHeight;
  }

  /// Get responsive font size
  static double getFontSize(double fontSize, {double designWidth = 375}) {
    return (fontSize / designWidth) * screenWidth;
  }

  /// Get percentage of screen width
  /// Example: widthPercent(50) returns 50% of screen width
  static double widthPercent(double percent) {
    return (percent / 100) * screenWidth;
  }

  /// Get percentage of screen height
  /// Example: heightPercent(50) returns 50% of screen height
  static double heightPercent(double percent) {
    return (percent / 100) * screenHeight;
  }
}

/// Extension on BuildContext for easier access
extension ScreenUtilsExtension on BuildContext {
  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get responsive width
  double w(double width) => ScreenUtils.getWidth(width);

  /// Get responsive height
  double h(double height) => ScreenUtils.getHeight(height);

  /// Get percentage of width
  double wp(double percent) => ScreenUtils.widthPercent(percent);

  /// Get percentage of height
  double hp(double percent) => ScreenUtils.heightPercent(percent);
}
