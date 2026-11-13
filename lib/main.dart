import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/theme.dart';
import 'app/routes.dart';
import 'services/services.dart';
import 'state/auth_provider.dart';
import 'state/dashboard_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OneStoryApp());
}

class OneStoryApp extends StatelessWidget {
  const OneStoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceService = MockDeviceService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(deviceService),
        ),
      ],
      child: MaterialApp(
        title: 'OneStory',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
