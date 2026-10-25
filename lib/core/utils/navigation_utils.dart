import 'package:flutter/material.dart';

/// Material route with configurable edge-swipe back.
/// Swipe is disabled by default to avoid Navigator gesture assertion
/// conflicts with Android predictive back.
class AppPageRoute<T> extends MaterialPageRoute<T> {
  AppPageRoute({
    required super.builder,
    super.settings,
    this.enableSwipeBack = false,
  });

  final bool enableSwipeBack;

  @override
  bool get popGestureEnabled => enableSwipeBack;
}

Route<T> appRoute<T>(
  WidgetBuilder builder, {
  RouteSettings? settings,
  bool enableSwipeBack = false,
}) {
  return AppPageRoute<T>(
    builder: builder,
    settings: settings,
    enableSwipeBack: enableSwipeBack,
  );
}

/// Defers navigation until route/gesture animations have settled.
void runAfterInteraction(VoidCallback action) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    WidgetsBinding.instance.addPostFrameCallback((_) => action());
  });
}

/// Navigates only if [context] is still mounted after interactions settle.
void safeNavigate(BuildContext context, VoidCallback navigation) {
  runAfterInteraction(() {
    if (!context.mounted) return;
    navigation();
  });
}
