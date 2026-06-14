import 'package:project_flutter/models/subject.dart';

class ScheduleItem {
  final String id;
  final String day;
  final String startTime;
  final String endTime;
  final Subject subject;

  ScheduleItem({
    required this.id,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.subject,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json, Subject subject) {
    return ScheduleItem(
      id: json['id']?.toString() ?? '',
      day: json['day'] ?? 'Monday',
      startTime: json['startTime'] ?? '08:00 AM',
      endTime: json['endTime'] ?? '11:00 AM',
      subject: subject,
    );
  }
}
