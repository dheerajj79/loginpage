import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'home_screen.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool isLoading = false;

  void handleLogin() async {
    setState(() => isLoading = true);
    final response = await AuthService.loginUser(
      email: emailCtrl.text.trim(),
      password: passCtrl.text.trim(),
    );
    setState(() => isLoading = false);

    Fluttertoast.showToast(msg: response["msg"] ?? "Login failed");

    if (response["token"] != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    children: [
      TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
      TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: isLoading ? null : handleLogin,
        child: isLoading ? const CircularProgressIndicator() : const Text("Login"),
      ),

      // ⬇️ Add the Google Sign-In button **right here**:
      const SizedBox(height: 20),
      ElevatedButton.icon(
        onPressed: () async {
          final result = await AuthService.signInWithGoogle();
          Fluttertoast.showToast(msg: result["msg"] ?? "Unknown error");

          if (result["token"] != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        },
        icon: const Icon(Icons.login),
        label: const Text("Sign in with Google"),
      )
    ],
  ),
),

    );
  }
}

