import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:project_flutter/models/notification.dart';
import 'package:project_flutter/models/subject.dart';
import 'package:project_flutter/models/grade.dart';
import 'package:project_flutter/models/schedule_item.dart';
import 'package:project_flutter/models/book.dart';
import 'package:project_flutter/models/assignment.dart';
import 'package:project_flutter/models/attendance_item.dart';
import 'package:project_flutter/models/campus_event.dart';
import 'package:project_flutter/models/borrowed_book.dart';
import 'package:project_flutter/models/student.dart';

class ApiService {
  static const String baseUrl = 'https://raw.githubusercontent.com/Vatana007/flutter_project/main/assets/api/db.json';

  Map<String, dynamic>? _dbCache;

  // Unified dynamic database fetch
  Future<Map<String, dynamic>> fetchDb() async {
    if (_dbCache != null) return _dbCache!;

    // 1. Attempt fetching from the online raw GitHub URL
    try {
      final response = await http.get(Uri.parse(baseUrl)).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        _dbCache = json.decode(response.body) as Map<String, dynamic>;
        return _dbCache!;
      }
    } catch (_) {
      // Fetch failed, fall through to loading local asset
    }

    // 2. Fallback: load the local asset file
    try {
      final String localData = await rootBundle.loadString('assets/api/db.json');
      _dbCache = json.decode(localData) as Map<String, dynamic>;
      return _dbCache!;
    } catch (e) {
      throw Exception('Failed to load database: $e');
    }
  }

  // Clear cache to force a reload
  void clearCache() {
    _dbCache = null;
  }

  // Fetch Student details
  Future<Student> fetchStudent() async {
    try {
      final db = await fetchDb();
      if (db.containsKey('student')) {
        return Student.fromJson(db['student']);
      }
      throw Exception('Student key missing');
    } catch (_) {
      return _getFallbackStudent();
    }
  }

  // Fetch notifications/announcements
  Future<List<AppNotification>> fetchNotifications() async {
    try {
      final db = await fetchDb();
      final List<dynamic> list = db['notifications'] ?? [];
      return list.map((json) => AppNotification.fromJson(json)).toList();
    } catch (_) {
      return _getFallbackNotifications();
    }
  }

  // Fetch class schedules
  Future<List<ScheduleItem>> fetchSchedule() async {
    try {
      final db = await fetchDb();
      final List<dynamic> list = db['schedule'] ?? [];
      return list.map((item) {
        final subJson = item['subject'] ?? {};
        final subject = Subject.fromJson(subJson);
        return ScheduleItem.fromJson(item, subject);
      }).toList();
    } catch (_) {
      return _getFallbackSchedule();
    }
  }

  // Fetch grades/results
  Future<List<Grade>> fetchGrades() async {
    try {
      final db = await fetchDb();
      final List<dynamic> list = db['grades'] ?? [];
      return list.map((json) => Grade.fromJson(json)).toList();
    } catch (_) {
      return _getFallbackGrades();
    }
  }

  // Fetch Assignments
  Future<List<Assignment>> fetchAssignments() async {
    try {
      final db = await fetchDb();
      final List<dynamic> list = db['assignments'] ?? [];
      return list.map((json) => Assignment.fromJson(json)).toList();
    } catch (_) {
      return _getFallbackAssignments();
    }
  }

  // Fetch Attendance records
  Future<List<AttendanceItem>> fetchAttendance() async {
    try {
      final db = await fetchDb();
      final List<dynamic> list = db['attendance'] ?? [];
      return list.map((json) => AttendanceItem.fromJson(json)).toList();
    } catch (_) {
      return _getFallbackAttendance();
    }
  }

  // Fetch Campus News/Events
  Future<List<CampusEvent>> fetchCampusNews() async {
    try {
      final db = await fetchDb();
      final List<dynamic> list = db['campus_news'] ?? [];
      return list.map((json) => CampusEvent.fromJson(json)).toList();
    } catch (_) {
      return _getFallbackCampusNews();
    }
  }

  // Fetch Borrowed Books
  Future<List<BorrowedBook>> fetchBorrowedBooks() async {
    try {
      final db = await fetchDb();
      final List<dynamic> list = db['borrowed_books'] ?? [];
      return list.map((json) => BorrowedBook.fromJson(json)).toList();
    } catch (_) {
      return _getFallbackBorrowedBooks();
    }
  }

  // Fetch academic computer books from Open Library API
  Future<List<Book>> fetchBooks() async {
    try {
      final response = await http
          .get(Uri.parse('https://openlibrary.org/subjects/computer.json?limit=25'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('works') && data['works'] is List) {
          final List<dynamic> works = data['works'];
          return works.map((jsonBook) => Book.fromJson(jsonBook)).toList();
        } else {
          throw Exception('Invalid data structure');
        }
      } else {
        throw Exception('Failed to load online books');
      }
    } catch (e) {
      return _getFallbackBooks();
    }
  }

  // Fallback structures for safety:
  Student _getFallbackStudent() {
    return Student(
      id: 'DUC2024-0001',
      name: 'Vuth Vatana',
      email: 'vatana@gmail.com',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
      major: 'Software Development',
      academicYear: 'Year 3, Semester 2',
      phoneNumber: '+855 89 777 666',
      gpa: 3.82,
      attendanceRate: 0.94,
    );
  }

  List<AppNotification> _getFallbackNotifications() {
    return [
      AppNotification(
        id: 1,
        title: "Welcome to Semester II Academic Year 2026",
        message: "Welcome back students! Classes for Semester II start next Monday. Please review your schedules and ensure your registration is fully finalized.",
        timestamp: "Just now",
        isRead: false,
      ),
      AppNotification(
        id: 2,
        title: "Midterm Examination Timetable Released",
        message: "The official midterm exam schedule has been posted on the main portal. Exams will commence from the 25th of this month. Good luck to everyone!",
        timestamp: "2 hours ago",
        isRead: false,
      )
    ];
  }

  List<ScheduleItem> _getFallbackSchedule() {
    return [
      ScheduleItem(
        id: '1',
        day: 'Monday',
        startTime: '08:00 AM',
        endTime: '11:00 AM',
        subject: Subject(
          code: 'CS-301',
          name: 'Mobile Application Development',
          lecturer: 'Dr. Kim Sour',
          credits: 4,
          room: 'Lab Room 101',
          time: '08:00 AM - 11:00 AM',
          day: 'Monday',
        ),
      ),
    ];
  }

  List<Grade> _getFallbackGrades() {
    return [
      Grade(
        subjectCode: 'CS-201',
        subjectName: 'Data Structures & Algorithms',
        credits: 4,
        gradeLetter: 'A',
        gpaValue: 4.0,
        score: 92.5,
        semester: 'Year 2, Semester 2',
      ),
    ];
  }

  List<Assignment> _getFallbackAssignments() {
    return [
      const Assignment(
        id: '1',
        title: 'Flutter Navigation & State App',
        subjectCode: 'CS-301',
        dueDate: 'June 18, 2026',
        description: 'Create a fully functional Multi-Tab Flutter application.',
        status: 'pending',
        priority: 'high',
        maxScore: 100.0,
      )
    ];
  }

  List<AttendanceItem> _getFallbackAttendance() {
    return [
      const AttendanceItem(
        subjectCode: 'CS-301',
        subjectName: 'Mobile Application Development',
        presentDays: 14,
        totalDays: 15,
      ),
    ];
  }

  List<CampusEvent> _getFallbackCampusNews() {
    return [
      const CampusEvent(
        id: '1',
        title: 'Annual Campus Tech Hackathon 2026',
        category: 'sports',
        content: 'Get ready for 48 hours of pure coding and design!',
        imageUrl: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=500',
        date: 'June 26 - 28, 2026',
        rsvpCount: 142,
      ),
    ];
  }

  List<BorrowedBook> _getFallbackBorrowedBooks() {
    return [
      const BorrowedBook(
        bookKey: '/works/OL1845124W',
        title: 'Introduction to Algorithms',
        authors: ['Thomas H. Cormen'],
        borrowDate: 'June 01, 2026',
        dueDate: 'June 15, 2026',
        status: 'active',
      ),
    ];
  }

  List<Book> _getFallbackBooks() {
    return [
      const Book(
        key: '1',
        title: 'Introduction to Algorithms',
        authors: ['Thomas H. Cormen', 'Charles E. Leiserson'],
        coverUrl: null,
        publishYear: 1990,
        subjects: ['Computer Algorithms', 'Programming', 'Data Structures'],
      ),
    ];
  }
}
