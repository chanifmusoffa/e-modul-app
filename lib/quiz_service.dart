import 'dart:convert';
import 'package:http/http.dart' as http;

import 'quiz_question.dart';

class QuizService {
  static const String url =
      "https://script.google.com/macros/s/AKfycbwfqfP66eB05XSjLUwyqdRz18DuiGh3k7SHKaF2GReFUCNRRseByHsp_cnEVxSilEDO/exec";

  static Future<List<QuizQuestion>> fetchByKategori(String kategori) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((e) => QuizQuestion.fromJson(e))
          .where((e) => e.kategori.toLowerCase() == kategori.toLowerCase())
          .toList();
    } else {
      throw Exception("Gagal load soal");
    }
  }
}
