class QuizQuestion {
  final String id;
  final String kategori;
  final String soal;
  final String a;
  final String b;
  final String c;
  final String d;
  final String jawaban;

  QuizQuestion({
    required this.id,
    required this.kategori,
    required this.soal,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.jawaban,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'].toString(),
      kategori: json['kategori'],
      soal: json['soal'],
      a: json['a'].toString(),
      b: json['b'].toString(),
      c: json['c'].toString(),
      d: json['d'].toString(),
      jawaban: json['jawaban'],
    );
  }
}
