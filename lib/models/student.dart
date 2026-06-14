class Student {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String major;
  final String academicYear;
  final String phoneNumber;
  final double gpa;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.major,
    required this.academicYear,
    required this.phoneNumber,
    required this.gpa,
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
    );
  }
}
