class Grade {
  final String subjectCode;
  final String subjectName;
  final int credits;
  final String gradeLetter;
  final double gpaValue;
  final double score;
  final String semester;

  Grade({
    required this.subjectCode,
    required this.subjectName,
    required this.credits,
    required this.gradeLetter,
    required this.gpaValue,
    required this.score,
    required this.semester,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      subjectCode: json['subjectCode'] ?? 'SUB-101',
      subjectName: json['subjectName'] ?? '',
      credits: (json['credits'] as num?)?.toInt() ?? 3,
      gradeLetter: json['gradeLetter'] ?? 'A',
      gpaValue: (json['gpaValue'] as num?)?.toDouble() ?? 4.0,
      score: (json['score'] as num?)?.toDouble() ?? 90.0,
      semester: json['semester'] ?? 'Year 3, Semester 1',
    );
  }
}
