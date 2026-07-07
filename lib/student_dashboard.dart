import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';

import 'student_bacaanharian.dart';
import 'tahlil_page.dart';
import 'istighosah_page.dart';
import 'maulid_page.dart';
import 'latihan_list_page.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  late Timer _sliderTimer;
  late Timer _clockTimer;

  DateTime now = DateTime.now();

  // =========================================
  // GOOGLE SPREADSHEET DATABASE
  // =========================================

  List<Map<String, dynamic>> jadwalList = [];
  List<Map<String, dynamic>> kegiatanList = [];

  // GANTI DENGAN URL WEB APP GOOGLE SCRIPT
  final String apiUrl =
      'https://script.google.com/macros/s/AKfycbxuVxnaknVYFNc881Pf--Wyhsvdibt4FEmuJXj68PM0UaRGmFX7VOXRA9yVhTZV0mH0tA/exec';

  // =========================================
  // INIT
  // =========================================

  @override
  void initState() {
    super.initState();

    getJadwal();

    // AUTO SLIDER
    _sliderTimer = Timer.periodic(
      const Duration(seconds: 4),
      (timer) {
        if (_pageController.hasClients) {
          if (_currentPage < 1) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }

          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }
      },
    );

    // REALTIME CLOCK
    _clockTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          now = DateTime.now();
        });
      },
    );
  }

  @override
  void dispose() {
    _sliderTimer.cancel();
    _clockTimer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // =========================================
  // FETCH GOOGLE SPREADSHEET
  // =========================================

  Future<void> getJadwal() async {

  try {

    final response = await http.get(
      Uri.parse(apiUrl),
    );

    if (response.statusCode == 200) {

      final data = List<Map<String, dynamic>>
          .from(jsonDecode(response.body));

      setState(() {

        jadwalList = data
            .where((e) => e['tipe'] == 'jadwal')
            .toList();

        kegiatanList = data
            .where((e) => e['tipe'] == 'kegiatan')
            .toList();

      });
    }
  } catch (e) {

    debugPrint("ERROR: $e");

  }
}

  // =========================================
  // ICON OTOMATIS
  // =========================================

  IconData getIcon(String judul) {
    switch (judul.toLowerCase()) {
      case "dhuha":
        return Icons.wb_sunny_outlined;

      case "dzuhur":
        return Icons.wb_sunny;

      case "ashar":
        return Icons.sunny_snowing;

      case "maghrib":
        return Icons.nightlight_round;

      case "isya":
        return Icons.dark_mode;

      default:
        return Icons.access_time;
    }
  }

  // =========================================
  // TANGGAL ISLAM
  // =========================================

  String getTanggalIslam() {
    HijriCalendar hijri = HijriCalendar.now();

    List<String> hariJawa = [
      "Legi",
      "Pahing",
      "Pon",
      "Wage",
      "Kliwon",
    ];

    String hari = DateFormat(
      'EEEE',
      'id_ID',
    ).format(now);

    String pasaran = hariJawa[now.day % 5];

    return "$hari, $pasaran\n"
        "${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} H";
  }

  // =========================================
  // JAM SEKARANG
  // =========================================

  String getJamNow() {
    return DateFormat('HH:mm:ss').format(now);
  }

  // =========================================
  // COUNTDOWN
  // =========================================

  String getCountdown(String targetJam) {
    try {
      final split = targetJam.split(":");

      DateTime target = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(split[0]),
        int.parse(split[1]),
      );

      Duration diff = target.difference(now);

      if (diff.isNegative) {
        return "Sedang berlangsung";
      }

      String two(int n) => n.toString().padLeft(2, '0');

      return "${two(diff.inHours)}:"
          "${two(diff.inMinutes.remainder(60))}:"
          "${two(diff.inSeconds.remainder(60))}";
    } catch (e) {
      return "-";
    }
  }

  // =========================================
  // GRADIENT DINAMIS
  // =========================================

  List<Color> getGradientByTime() {
    int hour = now.hour;

    // PAGI
    if (hour >= 5 && hour < 11) {
      return [
        const Color(0xFFFF9800),
        const Color(0xFFFFB74D),
        const Color(0xFFFFE082),
      ];
    }

    // SIANG
    if (hour >= 11 && hour < 17) {
      return [
        const Color(0xFF00332B),
        const Color(0xFF00695C),
        const Color(0xFF4DB6AC),
      ];
    }

    // MALAM
    return [
      const Color(0xFF0D1B2A),
      const Color(0xFF1B263B),
      const Color(0xFF415A77),
    ];
  }

  // =========================================
  // DETEKSI WARNA TERANG / GELAP
  // =========================================

  bool isDarkModeCard() {
    int hour = now.hour;

    // pagi = terang
    if (hour >= 5 && hour < 11) {
      return false;
    }

    // siang & malam = gelap
    return true;
  }

  Color getPrimaryTextColor() {
    return isDarkModeCard()
        ? Colors.white
        : const Color(0xFF3E2723);
  }

  Color getSecondaryTextColor() {
    return isDarkModeCard()
        ? Colors.white70
        : Colors.black87;
  }

  Color getTimeTextColor() {
    // khusus jam realtime

    if (isDarkModeCard()) {
      return Colors.amber;
    }

    // pagi -> lebih gelap supaya jelas
    return const Color(0xFFBF360C);
  }

  Color getHighlightColor(bool isBlueEffect) {

    // kalau background terang
    if (!isDarkModeCard()) {
      return isBlueEffect
          ? const Color(0xFF0D47A1)
          : const Color(0xFFE65100);
    }

    // kalau background gelap
    return isBlueEffect
        ? const Color(0xFF90CAF9)
        : const Color(0xFFFFCC80);
  }

  // =========================================
  // NAVIGATION
  // =========================================

  void goToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  // =========================================
  // UI
  // =========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "MA TAQWIYATUL WATHON",

          style: TextStyle(
            color: Color(0xFF004D40),
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: 1.2,

            shadows: [
              Shadow(
                color: Colors.black38,
                blurRadius: 2,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        child: Column(
          children: [
            // =====================================
            // SLIDER
            // =====================================

            SizedBox(
              height: 250,

              child: PageView(
                controller: _pageController,

                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },

                children: [
                  _buildSliderCard(),

                  _buildActivityCard(),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // =====================================
            // DOT
            // =====================================

            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: List.generate(2, (index) {
                return Container(
                  width: 8,
                  height: 8,

                  margin: const EdgeInsets.symmetric(horizontal: 4),

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: _currentPage == index
                        ? const Color(0xFF00695C)
                        : Colors.grey.shade300,
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            // =====================================
            // MENU
            // =====================================

            _menuItem(
              "BACAAN HARIAN",
              "bacaan.png",
              () {
                goToPage(const StudentBacaanHarian());
              },
            ),

            _menuItem(
              "TAHLIL & DOA",
              "tahlil.png",
              () {
                goToPage(const TahlilPage());
              },
            ),

            _menuItem(
              "ISTIGHOSAH",
              "istighosah.png",
              () {
                goToPage(const IstighosahPage());
              },
            ),

            _menuItem(
              "MAULID DIBA'I",
              "maulid.png",
              () {
                goToPage(const MaulidPage());
              },
            ),

            _menuItem(
              "MANAQIB",
              "manaqib.png",
              () {},
            ),

            _menuItem(
              "DOA UMUM",
              "doa_umum.png",
              () {},
            ),

            _menuItem(
              "ZIARAH WALI",
              "ziarah.png",
              () {},
            ),

            _menuItem(
              "LATIHAN",
              "latihan.png",
              () {
                goToPage(const LatihanListPage());
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // =========================================
  // SLIDER CARD
  // =========================================

  Widget _buildSliderCard() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: getGradientByTime(),
        ),

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            getTanggalIslam(),

            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            getJamNow(),

            style: TextStyle(
              color: getTimeTextColor(),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          if (jadwalList.length >= 2)
            Row(
              children: [
                Expanded(
                  child: _buildInfoSubBox(
                    jadwalList[0],
                    false,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _buildInfoSubBox(
                    jadwalList[1],
                    true,
                  ),
                ),
              ],
            )
          else
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  // =========================================
  // KEGIATAN
  // =========================================

  Widget _buildActivityCard() {

  return Container(
    margin: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ),

    padding: const EdgeInsets.all(20),

    decoration: BoxDecoration(

    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,

      colors: getGradientByTime(),
    ),

  borderRadius: BorderRadius.circular(24),

  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 10,
      offset: const Offset(0, 5),
    ),
  ],
),

    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        // TANGGAL
        Text(
          "Kegiatan Hari Ini",

          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 15),

        // LIST KEGIATAN
        if (kegiatanList.length >= 2)

          Row(
            children: [

              Expanded(
                child: _buildInfoSubBox(
                  kegiatanList[0],
                  false,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _buildInfoSubBox(
                  kegiatanList[1],
                  true,
                ),
              ),
            ],
          )

        else

          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
      ],
    ),
  );
}

  // =========================================
  // SUB BOX
  // =========================================

  Widget _buildInfoSubBox(
  Map<String, dynamic> data,
  bool isBlueEffect,
) {

    Color highlightColor =
        getHighlightColor(isBlueEffect);

    Color primaryText =
        getPrimaryTextColor();

    Color secondaryText =
        getSecondaryTextColor();

  return Container(
    padding: const EdgeInsets.all(12),

    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.12),

      borderRadius: BorderRadius.circular(18),

      border: Border.all(
        color: Colors.white.withOpacity(0.2),
      ),
    ),

    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      mainAxisSize: MainAxisSize.min,

      children: [

        // JUDUL
        Row(
          children: [

            Icon(
              getIcon(data['judul']),
              color: highlightColor,
              size: 16,
            ),

            const SizedBox(width: 5),

            Expanded(
              child: Text(
                data['judul'],

                overflow: TextOverflow.ellipsis,

                style: TextStyle(
                  color: highlightColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // JAM
        Text(
          "${data['jam']} WIB",

          style: TextStyle(
            color: highlightColor,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 4),

        // IMAM
        Text(
          data['imam'],

          overflow: TextOverflow.ellipsis,

          style: TextStyle(
            color: secondaryText,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),

        // KELAS
        Text(
          data['kelas'],

          overflow: TextOverflow.ellipsis,

          style: TextStyle(
            color: secondaryText,
            fontSize: 11,
          ),
        ),
      ],
    ),
  );
}

  // =========================================
  // MENU ITEM
  // =========================================

  Widget _menuItem(
    String title,
    String imageName,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 6,
      ),

      height: 80,

      decoration: BoxDecoration(
        color: const Color(0xFFF1F8E9),

        borderRadius: BorderRadius.circular(25),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          onTap: onTap,

          borderRadius: BorderRadius.circular(25),

          splashColor: Colors.green.withOpacity(0.1),

          child: Center(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),

              title: Text(
                title,
                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1B5E20),
                  letterSpacing: 1.2,
                  height: 1.2,

                  shadows: [
                    Shadow(
                      color: Colors.black38,
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),

              trailing: SizedBox(
                width: 50,
                height: 50,

                child: Image.asset(
                  'assets/siswa/$imageName',

                  fit: BoxFit.contain,

                  errorBuilder:
                      (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported,
                      color: Colors.grey.shade400,
                      size: 30,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================
  // BOTTOM NAV
  // =========================================

  Widget _buildBottomNav() {
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
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,

        children: [
          Icon(
            Icons.home_filled,
            color: Colors.white,
            size: 35,
          ),

          Icon(
            Icons.book_outlined,
            color: Colors.white70,
            size: 28,
          ),

          Icon(
            Icons.list_alt_rounded,
            color: Colors.white70,
            size: 28,
          ),

          Icon(
            Icons.person_outline_rounded,
            color: Colors.white70,
            size: 28,
          ),
        ],
      ),
    );
  }
}