import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  String? _uid;
  String? _email;
  String? _role;

  String? get uid => _uid;
  String? get email => _email;
  String? get role => _role;

  bool get isLoggedIn => _uid != null;
  bool get isAdmin => _role == "admin";

  AuthProvider() {
    // Quando o app inicia, tenta logar automaticamente
    _auth.authStateChanges().listen((user) async {
      if (user == null) {
        _uid = null;
        _email = null;
        _role = null;
        notifyListeners();
        return;
      }

      _uid = user.uid;
      _email = user.email;

      await _loadUserRole(user.uid);

      notifyListeners();
    });
  }

  // Carrega a role do Firestore
  Future<void> _loadUserRole(String uid) async {
    final snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    _role = snap.data()?["role"] ?? "user";
  }

  // Login
  Future<String?> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _uid = cred.user!.uid;
      _email = cred.user!.email;

      await _loadUserRole(_uid!);

      notifyListeners();
      return null; // sucesso
    } catch (e) {
      return e.toString();
    }
  }

  // Criar conta
  Future<String?> register(String email, String password, String name) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // cria documento no Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(cred.user!.uid)
          .set({
        "name": name,
        "email": email,
        "role": "user", // admin cadastra manualmente
      });

      _uid = cred.user!.uid;
      _email = email;
      _role = "user";

      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
    _uid = null;
    _email = null;
    _role = null;
    notifyListeners();
  }
}
