import 'package:flutter/material.dart';

class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1024;
  
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < tablet;
  }
  
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktop;
  }
  
  static bool isMobileOrTablet(BuildContext context) {
    return MediaQuery.of(context).size.width < desktop;
  }
  
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  
  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
