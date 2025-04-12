import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool isLoading = false;

  void handleRegister() async {
    setState(() => isLoading = true);

    final response = await AuthService.registerUser(
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      password: passCtrl.text.trim(),
    );

    setState(() => isLoading = false);

    Fluttertoast.showToast(msg: response["msg"] ?? "Something went wrong");

    if (response["msg"] == "User registered successfully") {
      // Navigate or show success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "Phone")),
            TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : handleRegister,
              child: isLoading ? const CircularProgressIndicator() : const Text("Register"),
            )
          ],
        ),
      ),
    );
  }
}
