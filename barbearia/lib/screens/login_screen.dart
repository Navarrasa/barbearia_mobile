import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
// import '../providers/auth_provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  final AuthService _auth = AuthService();

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      await _auth.signInWithEmail(_emailCtrl.text.trim(), _passCtrl.text.trim());
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = Image.asset('assets/logo.jpg', height: 200);
    return Scaffold(
      backgroundColor: const Color(0xFF1d2647),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(36),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  logo,
                  const SizedBox(height: 12),
                  TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'E-mail')),
                  const SizedBox(height: 8),
                  TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFfbbf24)),
                    child: _loading ? const CircularProgressIndicator() : const Text('Entrar'),
                  ),
                  TextButton(onPressed: () { /* navegue para registro */ }, child: const Text('Criar conta')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
