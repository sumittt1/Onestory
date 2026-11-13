import 'package:flutter/material.dart';
import 'breakpoints.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context) desktop;
  
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });
  
  @override
  Widget build(BuildContext context) {
    if (Breakpoints.isDesktop(context)) {
      return desktop(context);
    } else if (Breakpoints.isTablet(context) && tablet != null) {
      return tablet!(context);
    } else {
      return mobile(context);
    }
  }
}

class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T desktop;
  
  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    required this.desktop,
  });
  
  T getValue(BuildContext context) {
    if (Breakpoints.isDesktop(context)) {
      return desktop;
    } else if (Breakpoints.isTablet(context) && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}
