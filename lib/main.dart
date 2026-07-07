import 'package:flutter/material.dart';
import 'dart:async';
import 'login_page.dart'; // Import halaman login
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting(
    'id_ID',
    null,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'sans-serif'),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showPresentation = false;

  @override
  void initState() {
    super.initState();

    // Setelah 3 detik logo, ganti ke teks persembahan
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showPresentation = true;
        });
      }
    });

    // Setelah 6 detik total, pindah ke halaman Login
    Timer(const Duration(seconds: 9), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. GAMBAR BACKGROUND SEKOLAH
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/background.jpg',
                ), // Pastikan file ini ada
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 2. LAPISAN HIJAU (Overlay) agar background terlihat samar
          Container(color: const Color(0xFF1B5E20).withOpacity(0.80)),
          // 3. KONTEN LOGO & TEKS
          Center(
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 800),
              firstChild: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/logo.png', width: 200),
                  const SizedBox(height: 20),
                ],
              ),
              secondChild: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Persembahan dari :",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildCreatorText("Stephanus Widjaja", "Dosen STIMIK AKI"),
                    const SizedBox(height: 16),
                    _buildCreatorText("Aditiyo Putro Wicaksono", "Dosen UNAKI"),
                    const SizedBox(height: 16),
                    _buildCreatorText(
                      "Abdul Rozacky",
                      "Mahasiswa UNAKI (222230024)",
                    ),
                    const SizedBox(height: 16),
                    _buildCreatorText(
                      "Farrell Feodora N.P",
                      "Mahasiswa UNAKI (222230014)",
                    ),
                    const SizedBox(height: 16),
                    _buildCreatorText(
                      "Chanif Musoffa",
                      "Mahasiswa UNAKI (222230025)",
                    ),
                  ],
                ),
              ),
              crossFadeState: _showPresentation
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatorText(String name, String description) {
    return Column(
      children: [
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
