import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
// import 'screens/splash_screen.dart';
import 'routes/routes.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );
  await Hive.initFlutter();
  await Hive.openBox('servicesBox');
  await Hive.openBox('appointmentsBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Studio Pro Barber',
        theme: ThemeData(
          primaryColor: const Color(0xFF1d2647),
          scaffoldBackgroundColor: const Color(0xFF121212),
          fontFamily: 'Inter',
        ),
        initialRoute: '/',
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
