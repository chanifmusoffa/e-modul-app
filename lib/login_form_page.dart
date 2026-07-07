import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'student_dashboard.dart';

class LoginFormPage extends StatefulWidget {
  const LoginFormPage({super.key});

  @override
  State<LoginFormPage> createState() => _LoginFormPageState();
}

class _LoginFormPageState extends State<LoginFormPage> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final String baseUrl =
      "https://script.google.com/macros/s/AKfycbxr6Zurl9sR7bIPtxxhJ1jnQfSoWUu_NkS430xtP90sK_CZKFoqrBmGfBtloExcpwT3/exec";

  bool isLoading = false;

  // SHOW / HIDE PASSWORD
  bool isPasswordVisible = false;

  // DIALOG NOTIFIKASI
  void showMessage(String message, IconData icon, Color color) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),

        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(icon, size: 65, color: color),

            const SizedBox(height: 18),

            Text(
              message,
              textAlign: TextAlign.center,

              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // FUNCTION LOGIN
  Future<void> login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      showMessage(
        "Username & Password wajib diisi",
        Icons.warning_rounded,
        Colors.orange,
      );
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse(baseUrl).replace(
      queryParameters: {
        "username": usernameController.text,
        "password": passwordController.text,
      },
    );

    try {
      final response = await http.get(url);

      final data = json.decode(response.body);

      if (!mounted) return;

      if (data['status'] == 'success') {
        showMessage("Login Berhasil", Icons.check_circle_rounded, Colors.green);

        await Future.delayed(const Duration(seconds: 1));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StudentDashboard()),
        );
      } else if (data['status'] == 'wrong_password') {
        showMessage("Password Salah", Icons.lock_rounded, Colors.orange);
      } else if (data['status'] == 'user_not_found') {
        showMessage(
          "Username Tidak Ditemukan",
          Icons.person_off_rounded,
          Colors.red,
        );
      } else {
        showMessage("Login Gagal", Icons.error_rounded, Colors.red);
      }
    } catch (e) {
      showMessage("Koneksi Bermasalah", Icons.wifi_off_rounded, Colors.red);
    }

    setState(() => isLoading = false);
  }

  // TEXTFIELD
  Widget buildTextField(
    String label,
    String hint,
    bool isPassword,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          label,

          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: 10),

        TextField(
          controller: controller,

          obscureText: isPassword ? !isPasswordVisible : false,

          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
            letterSpacing: 0.3,
          ),

          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF1F1F1),

            hintText: hint,

            hintStyle: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),

            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 10),

              child: Icon(
                isPassword ? Icons.lock_rounded : Icons.person_rounded,

                size: 28,
                color: const Color(0xFF1B5E20),
              ),
            ),

            prefixIconConstraints: const BoxConstraints(minWidth: 60),

            // 🔥 ICON PASSWORD LEBIH KE KIRI
            suffixIcon: isPassword
                ? Padding(
                    padding: const EdgeInsets.only(right: 8),

                    child: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,

                        color: Colors.grey[700],
                        size: 28,
                      ),

                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  )
                : null,

            suffixIconConstraints: const BoxConstraints(
              minWidth: 50,
              minHeight: 50,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),

              borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 2),
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 22,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // OVERLAY
          Container(color: const Color(0xFF1B5E20).withValues(alpha: 0.78)),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),

                child: Column(
                  children: [
                    // 🔥 LOGO POLOS
                    Image.asset('assets/images/logo.png', width: 145),

                    const SizedBox(height: 30),

                    // CARD LOGIN
                    Container(
                      padding: const EdgeInsets.all(28),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(34),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.22),

                            blurRadius: 18,

                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),

                      child: Column(
                        children: [
                          const Text(
                            "SELAMAT DATANG!",
                            textAlign: TextAlign.center,

                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B5E20),
                              letterSpacing: 1,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            "Silahkan login terlebih dahulu",

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),

                          const SizedBox(height: 35),

                          // USERNAME
                          buildTextField(
                            "Username",
                            "Masukkan username",
                            false,
                            usernameController,
                          ),

                          const SizedBox(height: 24),

                          // PASSWORD
                          buildTextField(
                            "Password",
                            "Masukkan password",
                            true,
                            passwordController,
                          ),

                          const SizedBox(height: 38),

                          // BUTTON LOGIN
                          SizedBox(
                            width: double.infinity,
                            height: 60,

                            child: ElevatedButton(
                              onPressed: isLoading ? null : login,

                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD7C0A7),

                                elevation: 6,

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),

                              child: isLoading
                                  ? const SizedBox(
                                      width: 28,
                                      height: 28,

                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Text(
                                      "LOGIN",

                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
