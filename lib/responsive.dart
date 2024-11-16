import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  const Responsive(
      {super.key, required this.mobile, this.tablet, required this.desktop});
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 820;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1150 &&
      MediaQuery.of(context).size.width >= 950;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1150;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    if (_size.width >= 1100) {
      return desktop;
    } else if (_size.width >= 850 && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}
