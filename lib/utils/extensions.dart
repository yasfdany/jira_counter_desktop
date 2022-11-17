import 'package:flutter/material.dart';
import 'package:jira_counter/main.dart';

extension ContextHelper on BuildContext {
  bool get isWideScreen {
    double width = MediaQuery.of(this).size.width;
    double height = MediaQuery.of(this).size.height;

    return width > height;
  }
}

extension DoubleHelper on double {
  double get wp => widthScreen * (this / 100);
  double get hp => heightScreen * (this / 100);
}

extension IntHelper on int {
  double get wp => widthScreen * (this / 100);
  double get hp => heightScreen * (this / 100);
}
