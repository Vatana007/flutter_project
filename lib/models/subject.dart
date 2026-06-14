class Subject {
  final String code;
  final String name;
  final String lecturer;
  final int credits;
  final String room;
  final String time;
  final String day;

  Subject({
    required this.code,
    required this.name,
    required this.lecturer,
    required this.credits,
    required this.room,
    required this.time,
    required this.day,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      code: json['code'] ?? 'SUB-101',
      name: json['name'] ?? '',
      lecturer: json['lecturer'] ?? 'Unknown Faculty',
      credits: (json['credits'] as num?)?.toInt() ?? 3,
      room: json['room'] ?? 'TBD',
      time: json['time'] ?? '08:00 AM - 11:00 AM',
      day: json['day'] ?? 'Monday',
    );
  }
}
