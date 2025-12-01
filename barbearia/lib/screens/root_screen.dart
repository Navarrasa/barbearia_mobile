import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'services_screen.dart';
import 'appointment_screen.dart';
import 'profile_screen.dart';
import 'register_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    final screens = [
      const HomeScreen(),
      const ServicesScreen(),
      const AppointmentScreen(),
      auth.isLoggedIn ? const ProfileScreen() : const RegisterScreen()
    ];

    return Scaffold(
      body: screens[_index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        selectedItemColor: const Color(0xFF1d2647),
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _index = i),

        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.cut),
            label: "Cortes",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Agendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(auth.isLoggedIn ? Icons.person : Icons.login),
            label: auth.isLoggedIn ? "Perfil" : "Login",
          ),
        ],
      ),
    );
  }
}
