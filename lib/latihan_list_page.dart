import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'latihan_quiz_page.dart';

class LatihanListPage extends StatefulWidget {
  const LatihanListPage({super.key});

  @override
  State<LatihanListPage> createState() => _LatihanListPageState();
}

class _LatihanListPageState extends State<LatihanListPage> {
  Map<String, int> nilaiMap = {};

  @override
  void initState() {
    super.initState();
    loadNilai();
  }

  Future<void> loadNilai() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      nilaiMap = {
        "asmaul": prefs.getInt("nilai_asmaul") ?? 0,
        "doa": prefs.getInt("nilai_doa") ?? 0,
        "surat": prefs.getInt("nilai_surat") ?? 0,
        "fiyyah": prefs.getInt("nilai_fiyyah") ?? 0,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: Column(
        children: [
          buildHeader(),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),

              children: [
                itemLatihan(
                  title: "AL-ASMA’ AL-HUSNA",
                  kategori: "asmaul",
                  nilai: nilaiMap["asmaul"] ?? 0,
                  icon: Icons.menu_book_rounded,
                ),

                itemLatihan(
                  title: "DOA & SHOLAWAT HARIAN",
                  kategori: "doa",
                  nilai: nilaiMap["doa"] ?? 0,
                  icon: Icons.auto_stories_rounded,
                ),

                itemLatihan(
                  title: "SURAT-SURAT PILIHAN",
                  kategori: "surat",
                  nilai: nilaiMap["surat"] ?? 0,
                  icon: Icons.library_books_rounded,
                ),

                itemLatihan(
                  title: "AL-FIYYAH IBNU MALIK",
                  kategori: "fiyyah",
                  nilai: nilaiMap["fiyyah"] ?? 0,
                  icon: Icons.school_rounded,
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ================= HEADER =================

  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 52, bottom: 18),

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF66BB6A), Color(0xFF1B5E20)],
        ),
      ),

      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),

            onPressed: () {
              Navigator.pop(context);
            },
          ),

          const Expanded(
            child: Text(
              "LATIHAN",

              textAlign: TextAlign.center,

              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),

          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // ================= ITEM LATIHAN =================

  Widget itemLatihan({
    required String title,
    required String kategori,
    required int nilai,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,

          MaterialPageRoute(
            builder: (_) => LatihanQuizPage(kategori: kategori, title: title),
          ),
        );

        if (result != null) {
          final prefs = await SharedPreferences.getInstance();

          await prefs.setInt("nilai_$kategori", result);

          loadNilai();
        }
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 18),

        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(28),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,

              decoration: BoxDecoration(
                color: const Color(0xFF1B5E20).withValues(alpha: 0.12),

                borderRadius: BorderRadius.circular(18),
              ),

              child: Icon(icon, color: const Color(0xFF1B5E20), size: 30),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Text(
                title,

                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                  height: 1.3,
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF43A047), Color(0xFF1B5E20)],
                ),

                borderRadius: BorderRadius.circular(16),
              ),

              child: Text(
                "$nilai/100",

                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= BOTTOM NAV =================

  Widget _buildBottomNav() {
    return Container(
      height: 80,

      decoration: const BoxDecoration(
        color: Color(0xFF1B5E20),

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },

            child: const Icon(Icons.home_filled, color: Colors.white, size: 35),
          ),

          const Icon(Icons.book_outlined, color: Colors.white70, size: 28),

          const Icon(Icons.list_alt_rounded, color: Colors.white70, size: 28),

          const Icon(
            Icons.person_outline_rounded,
            color: Colors.white70,
            size: 28,
          ),
        ],
      ),
    );
  }
}
