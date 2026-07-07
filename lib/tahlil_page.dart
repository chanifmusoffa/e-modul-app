import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'dart:convert';

class TahlilPage extends StatefulWidget {
  const TahlilPage({super.key});

  @override
  State<TahlilPage> createState() => _TahlilPageState();
}

class _TahlilPageState extends State<TahlilPage> {
  final String sheetUrl =
      "https://docs.google.com/spreadsheets/d/e/2PACX-1vRFhAHm7QLC5RSxyQDTWbrjNu23J3D-JFN_qLSz1my_WBhSbAOFCzvJHxO6kCdWWKOx41gpIuyH-n-Z/pub?gid=0&single=true&output=csv";

  bool isLoading = true;
  bool darkMode = false;

  bool showLatin = true;
  bool showArti = true;

  double fontSize = 30;

  String arab = "";
  String latin = "";
  String arti = "";

  List<String> arabLines = [];
  List<String> latinLines = [];
  List<String> artiLines = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(sheetUrl));

      if (response.statusCode == 200) {
        String decoded = utf8.decode(response.bodyBytes);

        List<List<dynamic>> csvTable = const CsvToListConverter().convert(
          decoded,
        );

        arab = csvTable[1][0].toString().replaceAll("\\n", "\n");

        latin = csvTable[1][1].toString().replaceAll("\\n", "\n");

        arti = csvTable[1][2].toString().replaceAll("\\n", "\n");

        setState(() {
          arabLines = arab
              .split('\n')
              .where((e) => e.trim().isNotEmpty)
              .toList();

          latinLines = latin
              .split('\n')
              .where((e) => e.trim().isNotEmpty)
              .toList();

          artiLines = arti
              .split('\n')
              .where((e) => e.trim().isNotEmpty)
              .toList();

          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = darkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: darkMode ? Colors.black : Colors.white,

      body: Column(
        children: [
          buildHeader(),

          // MENU
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: darkMode ? Colors.grey[900] : Colors.white,
              boxShadow: const [
                BoxShadow(blurRadius: 8, color: Colors.black12),
              ],
            ),
            child: Column(
              children: [
                // FONT SIZE
                Row(
                  children: [
                    Icon(Icons.text_fields, color: textColor),

                    Expanded(
                      child: Slider(
                        value: fontSize,
                        min: 22,
                        max: 42,
                        divisions: 10,
                        activeColor: Colors.green,
                        onChanged: (v) {
                          setState(() {
                            fontSize = v;
                          });
                        },
                      ),
                    ),

                    Text(
                      fontSize.toInt().toString(),
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // MENU FITUR
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // TEMA
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          darkMode = !darkMode;
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: darkMode
                                  ? Colors.grey[800]
                                  : Colors.green[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              darkMode ? Icons.dark_mode : Icons.light_mode,
                              color: darkMode ? Colors.yellow : Colors.orange,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Tema",
                            style: TextStyle(color: textColor, fontSize: 13),
                          ),
                        ],
                      ),
                    ),

                    // LATIN
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          showLatin = !showLatin;
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: showLatin ? Colors.green : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.translate,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Latin",
                            style: TextStyle(color: textColor, fontSize: 13),
                          ),
                        ],
                      ),
                    ),

                    // ARTI
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          showArti = !showArti;
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: showArti ? Colors.green : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.menu_book,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Arti",
                            style: TextStyle(color: textColor, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ISI
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(arabLines.length, (index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // ARAB
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  arabLines[index].trim(),

                                  textAlign: TextAlign.right,

                                  textHeightBehavior: const TextHeightBehavior(
                                    applyHeightToFirstAscent: false,
                                    applyHeightToLastDescent: false,
                                  ),

                                  style: TextStyle(
                                    fontFamily: "Amiri",

                                    fontSize: fontSize,

                                    // 🔥 PALING PAS
                                    height: 1.7,

                                    color: darkMode
                                        ? Colors.white
                                        : Colors.green[900],
                                  ),
                                ),
                              ),

                              // LATIN
                              if (showLatin && index < latinLines.length) ...[
                                const SizedBox(height: 10),

                                Text(
                                  latinLines[index].trim(),
                                  style: TextStyle(
                                    fontSize: 18,

                                    height: 1.4,

                                    fontStyle: FontStyle.italic,

                                    color: darkMode
                                        ? Colors.white70
                                        : Colors.black87,
                                  ),
                                ),
                              ],

                              // ARTI
                              if (showArti && index < artiLines.length) ...[
                                const SizedBox(height: 10),

                                Text(
                                  artiLines[index].trim(),
                                  style: TextStyle(
                                    fontSize: 17,

                                    height: 1.5,

                                    color: darkMode
                                        ? Colors.green[100]
                                        : Colors.green[800],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // HEADER
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
              "TAHLIL & DOA",
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
}
