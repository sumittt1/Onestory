import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/classrooms/classrooms_screen.dart';
import '../screens/classroom_detail/classroom_detail_screen.dart';
import '../screens/buildings/buildings_screen.dart';
import '../screens/building_detail/building_detail_screen.dart';
import '../screens/energy/energy_screen.dart';
import '../screens/schedules/schedules_screen.dart';
import '../screens/users/users_screen.dart';
import '../screens/activity_logs/activity_logs_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String classrooms = '/classrooms';
  static const String classroomDetail = '/classroom';
  static const String buildings = '/buildings';
  static const String buildingDetail = '/building';
  static const String energy = '/energy';
  static const String schedules = '/schedules';
  static const String users = '/users';
  static const String activityLogs = '/activity_logs';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        login: (context) => const LoginScreen(),
        dashboard: (context) => const DashboardScreen(),
        classrooms: (context) => const ClassroomsScreen(),
        buildings: (context) => const BuildingsScreen(),
        energy: (context) => const EnergyScreen(),
        schedules: (context) => const SchedulesScreen(),
        users: (context) => const UsersScreen(),
        activityLogs: (context) => const ActivityLogsScreen(),
        notifications: (context) => const NotificationsScreen(),
        settings: (context) => const SettingsScreen(),
        profile: (context) => const ProfileScreen(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '');
    
    if (uri.path.startsWith(classroomDetail)) {
      final roomId = uri.pathSegments.length > 1 ? uri.pathSegments[1] : 'C101';
      return MaterialPageRoute(
        builder: (context) => ClassroomDetailScreen(roomId: roomId),
      );
    }
    
    if (uri.path.startsWith(buildingDetail)) {
      final buildingId = uri.pathSegments.length > 1 ? uri.pathSegments[1] : 'BLD-001';
      return MaterialPageRoute(
        builder: (context) => BuildingDetailScreen(buildingId: buildingId),
      );
    }
    
    return null;
  }
}
