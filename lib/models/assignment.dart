class Assignment {
  final String id;
  final String title;
  final String subjectCode;
  final String dueDate;
  final String description;
  final String status; // 'pending', 'submitted', 'graded', 'overdue'
  final String priority; // 'high', 'medium', 'low'
  final double? score;
  final double maxScore;

  const Assignment({
    required this.id,
    required this.title,
    required this.subjectCode,
    required this.dueDate,
    required this.description,
    required this.status,
    required this.priority,
    this.score,
    required this.maxScore,
  });

  Assignment copyWith({
    String? id,
    String? title,
    String? subjectCode,
    String? dueDate,
    String? description,
    String? status,
    String? priority,
    double? score,
    double? maxScore,
  }) {
    return Assignment(
      id: id ?? this.id,
      title: title ?? this.title,
      subjectCode: subjectCode ?? this.subjectCode,
      dueDate: dueDate ?? this.dueDate,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      score: score ?? this.score,
      maxScore: maxScore ?? this.maxScore,
    );
  }

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      subjectCode: json['subjectCode'] ?? '',
      dueDate: json['dueDate'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'pending',
      priority: json['priority'] ?? 'medium',
      score: (json['score'] as num?)?.toDouble(),
      maxScore: (json['maxScore'] as num?)?.toDouble() ?? 100.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subjectCode': subjectCode,
      'dueDate': dueDate,
      'description': description,
      'status': status,
      'priority': priority,
      'score': score,
      'maxScore': maxScore,
    };
  }
}
