class Student {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String major;
  final String academicYear;
  final String phoneNumber;
  final double gpa;
  final double attendanceRate;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.major,
    required this.academicYear,
    required this.phoneNumber,
    required this.gpa,
    required this.attendanceRate,
  });

  Student copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? major,
    String? academicYear,
    String? phoneNumber,
    double? gpa,
    double? attendanceRate,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      major: major ?? this.major,
      academicYear: academicYear ?? this.academicYear,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gpa: gpa ?? this.gpa,
      attendanceRate: attendanceRate ?? this.attendanceRate,
    );
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] ?? 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150',
      major: json['major'] ?? 'Computer Science',
      academicYear: json['academicYear'] ?? 'Year 3, Semester 1',
      phoneNumber: json['phoneNumber'] ?? '+855 12 345 678',
      gpa: (json['gpa'] as num?)?.toDouble() ?? 3.85,
      attendanceRate: (json['attendanceRate'] as num?)?.toDouble() ?? 0.94,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'major': major,
      'academicYear': academicYear,
      'phoneNumber': phoneNumber,
      'gpa': gpa,
      'attendanceRate': attendanceRate,
    };
  }
}
