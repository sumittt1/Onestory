import 'package:flutter/material.dart';
import 'routes.dart';

class AppNavigation {
  static const int mobileBottomNavCount = 4;

  static int indexForRoute(String? routeName) {
    final path = Uri.tryParse(routeName ?? '')?.path ?? routeName ?? '';
    switch (path) {
      case AppRoutes.dashboard:
        return 0;
      case AppRoutes.classrooms:
        return 1;
      case AppRoutes.buildings:
        return 2;
      case AppRoutes.energy:
        return 3;
      case AppRoutes.schedules:
        return 4;
      case AppRoutes.users:
        return 5;
      case AppRoutes.activityLogs:
        return 6;
      case AppRoutes.notifications:
        return 7;
      case AppRoutes.settings:
        return 8;
      default:
        return 0;
    }
  }

  static void goToIndex(BuildContext context, int index) {
    final route = switch (index) {
      0 => AppRoutes.dashboard,
      1 => AppRoutes.classrooms,
      2 => AppRoutes.buildings,
      3 => AppRoutes.energy,
      4 => AppRoutes.schedules,
      5 => AppRoutes.users,
      6 => AppRoutes.activityLogs,
      7 => AppRoutes.notifications,
      8 => AppRoutes.settings,
      _ => AppRoutes.dashboard,
    };
    Navigator.pushReplacementNamed(context, route);
  }
}
