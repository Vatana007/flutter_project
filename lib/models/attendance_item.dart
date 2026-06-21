class AttendanceItem {
  final String subjectCode;
  final String subjectName;
  final int presentDays;
  final int totalDays;

  const AttendanceItem({
    required this.subjectCode,
    required this.subjectName,
    required this.presentDays,
    required this.totalDays,
  });

  double get attendanceRate => totalDays > 0 ? (presentDays / totalDays) : 0.0;

  factory AttendanceItem.fromJson(Map<String, dynamic> json) {
    return AttendanceItem(
      subjectCode: json['subjectCode'] ?? '',
      subjectName: json['subjectName'] ?? '',
      presentDays: json['presentDays'] as int? ?? 0,
      totalDays: json['totalDays'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subjectCode': subjectCode,
      'subjectName': subjectName,
      'presentDays': presentDays,
      'totalDays': totalDays,
    };
  }
}
