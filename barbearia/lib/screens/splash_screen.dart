import 'dart:async';
import 'package:barbearia/routes/routes.dart';
import 'package:barbearia/screens/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    // Delay de 2 segundos antes de redirecionar
    Timer(const Duration(seconds: 4), _checkLoginStatus);
  }

  void _checkLoginStatus() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Usuário logado → vai para Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    } else {
      // Usuário NÃO logado → vai para Login
      Navigator.pushReplacementNamed(context, AppRoutes.loginRegister);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1E3A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGO
            Image.asset(
              "assets/logo.jpg",
              width: 120,
            ),
            const SizedBox(height: 20),

            const Text(
              "Studio Pro Barber",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const CircularProgressIndicator(color: Colors.amber),
          ],
        ),
      ),
    );
  }
}
