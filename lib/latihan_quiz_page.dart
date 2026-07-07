import 'package:flutter/material.dart';

import 'quiz_question.dart';
import 'quiz_service.dart';

class LatihanQuizPage extends StatefulWidget {
  final String kategori;
  final String title;

  const LatihanQuizPage({
    super.key,
    required this.kategori,
    required this.title,
  });

  @override
  State<LatihanQuizPage> createState() => _LatihanQuizPageState();
}

class _LatihanQuizPageState extends State<LatihanQuizPage> {
  int indexSoal = 0;
  int benar = 0;

  bool darkMode = false;

  double textSize = 17;

  late Future<List<QuizQuestion>> future;

  Map<int, String> jawabanUser = {};

  @override
  void initState() {
    super.initState();

    future = QuizService.fetchByKategori(widget.kategori);
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = darkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF3F5F7);

    Color cardColor = darkMode ? const Color(0xFF1E1E1E) : Colors.white;

    Color textColor = darkMode ? Colors.white : const Color(0xFF2C2C2C);

    return Scaffold(
      backgroundColor: bgColor,

      body: Column(
        children: [
          buildHeader(),

          Expanded(
            child: FutureBuilder<List<QuizQuestion>>(
              future: future,

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "Soal belum tersedia",
                      style: TextStyle(color: textColor, fontSize: 18),
                    ),
                  );
                }

                final list = snapshot.data!;
                final soal = list[indexSoal];

                final String? currentSelected = jawabanUser[indexSoal];

                double progress = (indexSoal + 1) / list.length;

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),

                  child: Column(
                    children: [
                      buildProgressCard(progress, list.length),

                      const SizedBox(height: 14),

                      buildQuestionCard(
                        soal.soal,
                        soal.a,
                        soal.b,
                        soal.c,
                        soal.d,
                        currentSelected,
                        cardColor,
                        textColor,
                      ),

                      const SizedBox(height: 16),

                      buildButtons(list, currentSelected),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================

  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 52, bottom: 18),

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

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

          Expanded(
            child: Text(
              widget.title.toUpperCase(),

              textAlign: TextAlign.center,

              style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
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

  // ================= CARD ATAS =================

  Widget buildProgressCard(double progress, int total) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: darkMode
              ? [const Color(0xFF1B5E20), const Color(0xFF103815)]
              : [const Color(0xFF66BB6A), const Color(0xFF1B5E20)],
        ),

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.22),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,

                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),

                  borderRadius: BorderRadius.circular(18),
                ),

                child: const Icon(
                  Icons.quiz_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Soal ${indexSoal + 1} dari $total",

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "${(progress * 100).round()}% selesai dikerjakan",

                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),

            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),

          const SizedBox(height: 14),

          // ===== FITUR =====
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),

              borderRadius: BorderRadius.circular(18),
            ),

            child: Row(
              children: [
                // DARK MODE
                InkWell(
                  borderRadius: BorderRadius.circular(14),

                  onTap: () {
                    setState(() {
                      darkMode = !darkMode;
                    });
                  },

                  child: Container(
                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: Icon(
                      darkMode
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,

                      color: darkMode ? Colors.black : Colors.orange,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // TEXT SIZE
                const Icon(Icons.text_fields, color: Colors.white),

                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbColor: Colors.white,
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.white24,
                      overlayColor: Colors.white12,
                    ),

                    child: Slider(
                      value: textSize,
                      min: 14,
                      max: 24,
                      divisions: 5,

                      onChanged: (v) {
                        setState(() {
                          textSize = v;
                        });
                      },
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Text(
                    textSize.toInt().toString(),

                    style: const TextStyle(
                      color: Color(0xFF1B5E20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= PERTANYAAN =================

  Widget buildQuestionCard(
    String pertanyaan,
    String a,
    String b,
    String c,
    String d,
    String? currentSelected,
    Color cardColor,
    Color textColor,
  ) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),

                  borderRadius: BorderRadius.circular(14),
                ),

                child: Icon(
                  Icons.help_outline_rounded,
                  color: Colors.green.shade800,
                ),
              ),

              const SizedBox(width: 10),

              Text(
                "PERTANYAAN",

                style: TextStyle(
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            pertanyaan,

            style: TextStyle(
              fontSize: textSize,
              height: 1.5,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 18),

          opsi("a", a, currentSelected, textColor),

          opsi("b", b, currentSelected, textColor),

          opsi("c", c, currentSelected, textColor),

          opsi("d", d, currentSelected, textColor),
        ],
      ),
    );
  }

  // ================= BUTTON =================

  Widget buildButtons(List<QuizQuestion> list, String? currentSelected) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: darkMode
                  ? Colors.grey[850]
                  : Colors.grey.shade300,

              foregroundColor: darkMode ? Colors.white : Colors.black,

              padding: const EdgeInsets.symmetric(vertical: 14),

              elevation: 0,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),

            onPressed: indexSoal == 0
                ? null
                : () {
                    setState(() {
                      indexSoal--;
                    });
                  },

            child: const Text(
              "Previous",

              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B5E20),

              foregroundColor: Colors.white,

              padding: const EdgeInsets.symmetric(vertical: 14),

              elevation: 0,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),

            onPressed: currentSelected == null
                ? null
                : () {
                    if (indexSoal == list.length - 1) {
                      benar = 0;

                      for (int i = 0; i < list.length; i++) {
                        if (jawabanUser[i] == list[i].jawaban) {
                          benar++;
                        }
                      }

                      final nilai = ((benar / list.length) * 100).round();

                      Navigator.pop(context, nilai);
                    } else {
                      setState(() {
                        indexSoal++;
                      });
                    }
                  },

            child: Text(
              indexSoal == list.length - 1 ? "Finish" : "Next",

              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // ================= OPSI =================

  Widget opsi(
    String key,
    String text,
    String? currentSelected,
    Color textColor,
  ) {
    final bool isSelected = currentSelected == key;

    return GestureDetector(
      onTap: () {
        setState(() {
          jawabanUser[indexSoal] = key;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        margin: const EdgeInsets.only(bottom: 12),

        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE8F5E9)
              : darkMode
              ? const Color(0xFF242424)
              : Colors.white,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: isSelected ? Colors.green : const Color(0xFFA5D6A7),

            width: 2,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),

              width: 42,
              height: 42,

              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.green.shade700
                    : const Color(0xFF81C784),

                shape: BoxShape.circle,
              ),

              child: Center(
                child: Text(
                  key.toUpperCase(),

                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                text,

                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  height: 1.4,
                ),
              ),
            ),

            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.green, size: 24),
          ],
        ),
      ),
    );
  }
}
