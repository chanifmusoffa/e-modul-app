import 'package:flutter/material.dart';

class StudentBacaanHarian extends StatelessWidget {
  const StudentBacaanHarian({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          // HEADER
          buildHeader(context),

          // LIST BACAAN
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _listEntry(
                  "1",
                  "AL-ASMA' AL-HUSNA",
                  "Doa Saaltu dan Asmaul Husna",
                ),

                _listEntry(
                  "2",
                  "DOA & SHOLAWAT HARIAN",
                  "Bacaan Setelah Sholat Dhuha",
                ),

                _listEntry(
                  "3",
                  "SURAT-SURAT PILIHAN",
                  "Yasin, Al-Waqiah, Al-Mulk",
                ),

                _listEntry("4", "AL-FIYYAH IBNU MALIK", "Nadhom Al-Fiyyah"),

                _listEntry(
                  "5",
                  "WIRID & DOA MAKTUBAH",
                  "Bacaan Setelah Sholat Fardhu",
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: _simpleBottomNav(),
    );
  }

  // ================= HEADER =================

  Widget buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 52, bottom: 18),

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF66BB6A), // hijau muda
            Color(0xFF1B5E20), // hijau tua
          ],
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
              "BACAAN HARIAN",

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

  // ================= LIST MENU =================

  Widget _listEntry(String num, String title, String sub) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 4,
          ),

          leading: Container(
            width: 50,
            height: 50,

            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF66BB6A), Color(0xFF1B5E20)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              borderRadius: BorderRadius.circular(14),

              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),

            child: Center(
              child: Text(
                num,

                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),

          title: Text(
            title,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF333333),
            ),
          ),

          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),

            child: Text(
              sub,

              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),

          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
            color: Colors.grey,
          ),

          onTap: () {},
        ),

        const Padding(
          padding: EdgeInsets.only(left: 82, right: 20),

          child: Divider(thickness: 1, color: Color(0xFFEEEEEE)),
        ),
      ],
    );
  }

  // ================= BOTTOM NAV =================

  Widget _simpleBottomNav() {
    return Container(
      height: 80,

      decoration: const BoxDecoration(
        color: Color(0xFF1B5E20),

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),

      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [
          Icon(Icons.home_filled, color: Colors.white, size: 35),

          Icon(Icons.book_outlined, color: Colors.white70, size: 28),

          Icon(Icons.list_alt_rounded, color: Colors.white70, size: 28),

          Icon(Icons.person_outline_rounded, color: Colors.white70, size: 28),
        ],
      ),
    );
  }
}
