import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static const String baseUrl = "https://your-project.vercel.app/auth"; // Ensure this is your correct Vercel URL

  // Register user
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
          "email": email,
          "phone": phone,
          "password": password,
        }),
      );

      // Check response status
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"msg": "Registration failed: ${response.statusCode}"};
      }
    } catch (e) {
      return {"msg": "Error: $e"};
    }
  }

  // Login user
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']);
        }
        return data;
      } else {
        return {"msg": "Login failed: ${response.statusCode}"};
      }
    } catch (e) {
      return {"msg": "Error: $e"};
    }
  }

  // Get list of users
  static Future<List<dynamic>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: {'Authorization': 'Bearer $token'},
      );

      // Check if response is successful
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Google Sign-In
  static Future<Map<String, dynamic>> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(clientId: '1022192111753-qf0qs6ffaajvs6g0hr1sk4bs6hdk4dlj.apps.googleusercontent.com',);

    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        return {"msg": "Google sign-in cancelled"};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": account.displayName,
          "email": account.email,
          "googleId": account.id,
        }),
      );

      final data = jsonDecode(response.body);
      if (data["token"] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data["token"]);
      }

      return data;
    } catch (e) {
      print("Google Sign-In failed: $e"); // Logs error for debugging
      return {"msg": "Google Sign-In failed: $e"};
    }
  }

  // Logout user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
