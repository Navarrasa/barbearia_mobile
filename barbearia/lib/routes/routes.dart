import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../screens/appointment_screen.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/register_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String loginRegister = '/register';
  static const String home = '/home';
  static const String appointment = '/appointment';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case loginRegister:
        return MaterialPageRoute(builder: (_) => const LoginRegisterScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case appointment:
        final service = settings.arguments as ServiceModel;
        return MaterialPageRoute(
          builder: (_) => AppointmentScreen(service: service),
        );
    }

    return null;
  }
}
