import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_flutter/models/notification.dart';
import 'package:project_flutter/models/subject.dart';
import 'package:project_flutter/models/grade.dart';
import 'package:project_flutter/models/schedule_item.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Fetch notifications/announcements (Mapped from /posts)
  Future<List<AppNotification>> fetchNotifications() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts')).timeout(const Duration(seconds: 8));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Take first 15 posts and map them
        return data.take(15).map((post) {
          final int id = post['id'] ?? 0;
          String time = 'Just now';
          if (id > 1) {
            time = id % 2 == 0 ? '$id hours ago' : '$id days ago';
          }
          
          // Customizing title and body for school announcements
          final String title = _mapTitleToSchoolAnnouncement(id, post['title'] ?? '');
          final String body = _mapBodyToSchoolAnnouncement(id, post['body'] ?? '');
          
          return AppNotification(
            id: id,
            title: title,
            message: body,
            timestamp: time,
            isRead: id > 3, // Simulate some already read notifications
          );
        }).toList();
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      // Offline fallback data
      return _getFallbackNotifications();
    }
  }

  // Fetch class schedules (Mapped from /todos)
  Future<List<ScheduleItem>> fetchSchedule() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/todos')).timeout(const Duration(seconds: 8));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<ScheduleItem> schedule = [];
        
        // Take the first 12 tasks to populate the weekly schedule
        final items = data.take(12).toList();
        for (var i = 0; i < items.length; i++) {
          final item = items[i];
          final int id = item['id'] ?? 0;
          
          final String day = _getWeekdayFromId(id);
          final String timeSlot = _getTimeSlotFromId(id);
          
          final subject = Subject(
            code: 'CS-${300 + id}',
            name: _getSubjectNameFromId(id),
            lecturer: _getLecturerFromId(id),
            credits: (id % 2 == 0) ? 3 : 4,
            room: 'Lab Room ${100 + id}',
            time: timeSlot,
            day: day,
          );
          
          schedule.add(
            ScheduleItem(
              id: id.toString(),
              day: day,
              startTime: timeSlot.split(' - ').first,
              endTime: timeSlot.split(' - ').last,
              subject: subject,
            ),
          );
        }
        return schedule;
      } else {
        throw Exception('Failed to load schedule');
      }
    } catch (e) {
      return _getFallbackSchedule();
    }
  }

  // Fetch grades/results (Mapped from /users)
  Future<List<Grade>> fetchGrades() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users')).timeout(const Duration(seconds: 8));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        return data.map((user) {
          final int id = user['id'] ?? 0;
          
          final score = 78.0 + (id * 2.3) % 22.0; // Dynamic scores between 78 and 100
          final gradeLetter = _getGradeLetter(score);
          final gpaVal = _getGpaValue(gradeLetter);
          
          return Grade(
            subjectCode: 'CS-40$id',
            subjectName: _getAdvancedSubjectName(id, user['name'] ?? ''),
            credits: (id % 3 == 0) ? 4 : 3,
            gradeLetter: gradeLetter,
            gpaValue: gpaVal,
            score: double.parse(score.toStringAsFixed(1)),
            semester: 'Year 3, Semester 1',
          );
        }).toList();
      } else {
        throw Exception('Failed to load grades');
      }
    } catch (e) {
      return _getFallbackGrades();
    }
  }

  // Helper mappings for high-fidelity data mapping
  String _getWeekdayFromId(int id) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    return days[id % days.length];
  }

  String _getTimeSlotFromId(int id) {
    const times = [
      '08:00 AM - 11:00 AM',
      '01:00 PM - 04:00 PM',
      '05:30 PM - 08:30 PM'
    ];
    return times[id % times.length];
  }

  String _getSubjectNameFromId(int id) {
    const subjects = [
      'Mobile Application Development',
      'Advanced Database Management Systems',
      'UX/UI Interface Design',
      'Software Engineering Methodology',
      'Cloud Architecture & Web Services',
      'Information Security & Cryptography',
      'Artificial Intelligence Principles',
      'Data Structures & Algorithms',
      'Discrete Mathematics II',
      'Computer Network Protocols',
      'Operating Systems & Kernel Dev',
      'Human-Computer Interaction'
    ];
    return subjects[id % subjects.length];
  }

  String _getAdvancedSubjectName(int id, String fallback) {
    const advSubjects = [
      'Machine Learning Systems',
      'Parallel and Distributed Computing',
      'Blockchain Technology Applications',
      'Natural Language Processing',
      'Cyber Forensics & Incident Response',
      'Big Data Analytics Platform',
      'Virtual & Augmented Reality UI',
      'Internet of Things (IoT) Design',
      'Compiler Construction & Design',
      'DevOps Practices & Pipelines'
    ];
    return advSubjects[id % advSubjects.length];
  }

  String _getLecturerFromId(int id) {
    const lecturers = [
      'Dr. Kim Sour',
      'Prof. Alex Vance',
      'Dr. Linda Chen',
      'Dr. David Miller',
      'Prof. Sophia Martinez'
    ];
    return lecturers[id % lecturers.length];
  }

  String _getGradeLetter(double score) {
    if (score >= 90) return 'A';
    if (score >= 85) return 'B+';
    if (score >= 80) return 'B';
    if (score >= 75) return 'C+';
    if (score >= 70) return 'C';
    if (score >= 65) return 'D+';
    if (score >= 60) return 'D';
    return 'F';
  }

  double _getGpaValue(String letter) {
    switch (letter) {
      case 'A': return 4.0;
      case 'B+': return 3.5;
      case 'B': return 3.0;
      case 'C+': return 2.5;
      case 'C': return 2.0;
      case 'D+': return 1.5;
      case 'D': return 1.0;
      default: return 0.0;
    }
  }

  String _mapTitleToSchoolAnnouncement(int id, String originalTitle) {
    const customTitles = [
      'Welcome to Semester I Academic Year 2026',
      'Midterm Examination Timetable Released',
      'Scholarship Program Applications Open',
      'Library Opening Hours Extended for Finals',
      'Guest Lecture: AI Trends by Google Engineer',
      'Campus Wi-Fi Upgrade & Outage Notice',
      'EduTrack Mobile Application Beta Feedback',
      'Sports and Athletic Club Annual Meetup',
      'Tuition Fee Payment Deadline Warning',
      'Internship Fair 2026: Companies Registering'
    ];
    return customTitles[id % customTitles.length];
  }

  String _mapBodyToSchoolAnnouncement(int id, String originalBody) {
    const customBodies = [
      'Welcome back students! Classes for Semester I start next Monday. Please review your schedules and ensure your registration is fully finalized.',
      'The official midterm exam schedule has been posted on the main portal. Exams will commence from the 25th of this month. Good luck to everyone!',
      'Undergraduate students with a GPA higher than 3.5 are invited to apply for the prestigious ASEAN Excellence Scholarship. Application deadline is June 30th.',
      'To support students during exam preparation, the central library will be open 24/7 starting from next week until the end of the final exam cycle.',
      'Join us at Room 403 on Friday at 2:00 PM for an exciting presentation by a Google Senior Software Engineer discussing future trends in Large Language Models.',
      'Campus IT services will be upgrading routers this Sunday between 2:00 AM and 6:00 AM. Expect temporary disruptions in internet connectivity.',
      'We would love to hear your thoughts on our new EduTrack mobile app. Please complete the quick 2-minute survey in the Settings screen.',
      'The annual university athletic championship is starting soon! Students who wish to participate in track, football, or basketball should sign up by Wednesday.',
      'Important reminder: The final date to submit tuition fees for Semester I without incurring a late fee is Friday, June 18th. Payments can be done via portal.',
      'Prepare your resumes! Over 35 top tech companies will be hosting booths at the main auditorium on July 5th looking for summer interns.'
    ];
    return customBodies[id % customBodies.length];
  }

  // Fallbacks
  List<AppNotification> _getFallbackNotifications() {
    return List.generate(5, (index) {
      final id = index + 1;
      return AppNotification(
        id: id,
        title: _mapTitleToSchoolAnnouncement(id, ''),
        message: _mapBodyToSchoolAnnouncement(id, ''),
        timestamp: '$id days ago',
        isRead: id > 2,
      );
    });
  }

  List<ScheduleItem> _getFallbackSchedule() {
    final List<ScheduleItem> schedule = [];
    for (int i = 1; i <= 8; i++) {
      final String day = _getWeekdayFromId(i);
      final String timeSlot = _getTimeSlotFromId(i);
      final subject = Subject(
        code: 'CS-${300 + i}',
        name: _getSubjectNameFromId(i),
        lecturer: _getLecturerFromId(i),
        credits: (i % 2 == 0) ? 3 : 4,
        room: 'Lab Room ${100 + i}',
        time: timeSlot,
        day: day,
      );
      schedule.add(
        ScheduleItem(
          id: i.toString(),
          day: day,
          startTime: timeSlot.split(' - ').first,
          endTime: timeSlot.split(' - ').last,
          subject: subject,
        ),
      );
    }
    return schedule;
  }

  List<Grade> _getFallbackGrades() {
    return List.generate(6, (index) {
      final id = index + 1;
      final score = 80.0 + (id * 3.5) % 20.0;
      final letter = _getGradeLetter(score);
      return Grade(
        subjectCode: 'CS-40$id',
        subjectName: _getAdvancedSubjectName(id, ''),
        credits: 3,
        gradeLetter: letter,
        gpaValue: _getGpaValue(letter),
        score: score,
        semester: 'Year 3, Semester 1',
      );
    });
  }
}
