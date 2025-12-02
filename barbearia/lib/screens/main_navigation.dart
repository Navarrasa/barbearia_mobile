import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'product_screen.dart';
import 'appointment_screen.dart';
import 'register_screen.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;
  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    // Se o usuário não estiver logado, sempre exibe LoginScreen.
    if (!auth.isLoggedIn) {
      return const LoginRegisterScreen();
    }

    final screens = [
      const HomeScreen(),
      const ProductsScreen(),
      const AppointmentScreen(),
      const LoginRegisterScreen(),
    ];

    return Scaffold(
      body: screens[_index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        selectedItemColor: const Color(0xFF1d2647),
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          if (i == 3) {
            // Logout
            auth.signOut();
            setState(() => _index = 0);
            return;
          }
          setState(() => _index = i);
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: "Produtos",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Agendar",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: "Sair",
          ),
        ],
      ),
    );
  }
}
