import 'package:flutter/material.dart';

class AppNavigator {
  AppNavigator._();

  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static BuildContext? get context => key.currentContext;

  static NavigatorState? get state => key.currentState;
}
