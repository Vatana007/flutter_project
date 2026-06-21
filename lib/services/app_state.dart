import 'package:flutter/material.dart';
import 'package:project_flutter/models/student.dart';
import 'package:project_flutter/models/notification.dart';
import 'package:project_flutter/models/assignment.dart';
import 'package:project_flutter/models/attendance_item.dart';
import 'package:project_flutter/models/campus_event.dart';
import 'package:project_flutter/models/borrowed_book.dart';

enum AppLanguage { english, khmer }

class AppState extends ChangeNotifier {
  // Theme State
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Language/Localization State
  AppLanguage _language = AppLanguage.english;
  AppLanguage get language => _language;

  void setLanguage(AppLanguage lang) {
    _language = lang;
    notifyListeners();
  }

  // Active Student State
  Student? _currentStudent;
  Student? get currentStudent => _currentStudent;

  void loginStudent(Student student) {
    _currentStudent = student;
    notifyListeners();
  }

  void logoutStudent() {
    _currentStudent = null;
    notifyListeners();
  }

  void updateStudentProfile({required String name, required String phoneNumber, required String avatarUrl}) {
    if (_currentStudent != null) {
      _currentStudent = _currentStudent!.copyWith(
        name: name,
        phoneNumber: phoneNumber,
        avatarUrl: avatarUrl,
      );
      notifyListeners();
    }
  }

  // Local Notifications state
  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications;

  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;

  void setNotifications(List<AppNotification> list) {
    _notifications = list;
    notifyListeners();
  }

  void markNotificationAsRead(int id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  // Assignments State
  List<Assignment> _assignments = [];
  List<Assignment> get assignments => _assignments;

  void setAssignments(List<Assignment> list) {
    _assignments = list;
    notifyListeners();
  }

  void submitAssignmentLocal(String assignmentId) {
    final index = _assignments.indexWhere((a) => a.id == assignmentId);
    if (index != -1) {
      _assignments[index] = _assignments[index].copyWith(status: 'submitted');
      notifyListeners();
    }
  }

  // Attendance State
  List<AttendanceItem> _attendance = [];
  List<AttendanceItem> get attendance => _attendance;

  void setAttendance(List<AttendanceItem> list) {
    _attendance = list;
    notifyListeners();
  }

  // Campus News State
  List<CampusEvent> _campusNews = [];
  List<CampusEvent> get campusNews => _campusNews;

  void setCampusNews(List<CampusEvent> list) {
    _campusNews = list;
    notifyListeners();
  }

  void toggleEventRsvpLocal(String eventId) {
    final index = _campusNews.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      final current = _campusNews[index];
      final newRsvp = current.isRegistered ? current.rsvpCount - 1 : current.rsvpCount + 1;
      _campusNews[index] = current.copyWith(
        isRegistered: !current.isRegistered,
        rsvpCount: newRsvp,
      );
      notifyListeners();
    }
  }

  // Borrowed Books State
  List<BorrowedBook> _borrowedBooks = [];
  List<BorrowedBook> get borrowedBooks => _borrowedBooks;

  void setBorrowedBooks(List<BorrowedBook> list) {
    _borrowedBooks = list;
    notifyListeners();
  }

  void borrowBookLocal(BorrowedBook book) {
    if (!_borrowedBooks.any((b) => b.bookKey == book.bookKey)) {
      _borrowedBooks.add(book);
      notifyListeners();
    }
  }

  // Khmer-English Translation Mappings
  final Map<String, Map<AppLanguage, String>> _localizedStrings = {
    'app_title': {AppLanguage.english: 'EduTrack Mobile', AppLanguage.khmer: 'អេឌូត្រេក ម៉ូបាល'},
    'login': {AppLanguage.english: 'Login', AppLanguage.khmer: 'ចូលគណនី'},
    'register': {AppLanguage.english: 'Register', AppLanguage.khmer: 'ចុះឈ្មោះ'},
    'email_hint': {AppLanguage.english: 'Email or Student ID', AppLanguage.khmer: 'អ៊ីមែល ឬ អត្តសញ្ញាណសិស្ស'},
    'password_hint': {AppLanguage.english: 'Password', AppLanguage.khmer: 'ពាក្យសម្ងាត់'},
    'confirm_password_hint': {AppLanguage.english: 'Confirm Password', AppLanguage.khmer: 'បញ្ជាក់ពាក្យសម្ងាត់'},
    'full_name_hint': {AppLanguage.english: 'Full Name', AppLanguage.khmer: 'ឈ្មោះពេញ'},
    'forgot_password': {AppLanguage.english: 'Forgot Password?', AppLanguage.khmer: 'ភ្លេចពាក្យសម្ងាត់?'},
    'dont_have_account': {AppLanguage.english: "Don't have an account? Register", AppLanguage.khmer: 'មិនទាន់មានគណនី? ចុះឈ្មោះ'},
    'already_have_account': {AppLanguage.english: 'Already have an account? Login', AppLanguage.khmer: 'មានគណនីរួចហើយ? ចូលគណនី'},
    'home': {AppLanguage.english: 'Home', AppLanguage.khmer: 'ទំព័រដើម'},
    'schedule': {AppLanguage.english: 'Schedule', AppLanguage.khmer: 'កាលវិភាគ'},
    'result': {AppLanguage.english: 'Result', AppLanguage.khmer: 'លទ្ធផលសិក្សា'},
    'profile': {AppLanguage.english: 'Profile', AppLanguage.khmer: 'ព័ត៌មានផ្ទាល់ខ្លួន'},
    'settings': {AppLanguage.english: 'Settings', AppLanguage.khmer: 'ការកំណត់'},
    'about_app': {AppLanguage.english: 'About App', AppLanguage.khmer: 'អំពីកម្មវិធី'},
    'help_support': {AppLanguage.english: 'Help & Support', AppLanguage.khmer: 'ជំនួយ និងគាំទ្រ'},
    'logout': {AppLanguage.english: 'Log Out', AppLanguage.khmer: 'ចាកចេញ'},
    'dark_mode': {AppLanguage.english: 'Dark Mode', AppLanguage.khmer: 'មុខងារងងឹត'},
    'language': {AppLanguage.english: 'Language', AppLanguage.khmer: 'ភាសា'},
    'change_password': {AppLanguage.english: 'Change Password', AppLanguage.khmer: 'ផ្លាស់ប្តូរពាក្យសម្ងាត់'},
    'recent_announcements': {AppLanguage.english: 'Recent Announcements', AppLanguage.khmer: 'សេចក្តីជូនដំណឹងថ្មីៗ'},
    'gpa': {AppLanguage.english: 'Cumulative GPA', AppLanguage.khmer: 'មធ្យមភាគពិន្ទុ'},
    'credits': {AppLanguage.english: 'Total Credits', AppLanguage.khmer: 'ក្រេឌីតសរុប'},
    'notifications': {AppLanguage.english: 'Notifications', AppLanguage.khmer: 'ការជូនដំណឹង'},
    'edit_profile': {AppLanguage.english: 'Edit Profile', AppLanguage.khmer: 'កែសម្រួលព័ត៌មាន'},
    'save': {AppLanguage.english: 'Save', AppLanguage.khmer: 'រក្សាទុក'},
    'cancel': {AppLanguage.english: 'Cancel', AppLanguage.khmer: 'បោះបង់'},
    'no_notifications': {AppLanguage.english: 'No announcements at the moment.', AppLanguage.khmer: 'គ្មានការជូនដំណឹងនៅឡើយទេ។'},
    'major': {AppLanguage.english: 'Major', AppLanguage.khmer: 'ជំនាញ'},
    'academic_year': {AppLanguage.english: 'Academic Year', AppLanguage.khmer: 'ឆ្នាំសិក្សា'},
    'phone_number': {AppLanguage.english: 'Phone Number', AppLanguage.khmer: 'លេខទូរស័ព្ទ'},
    'student_id': {AppLanguage.english: 'Student ID', AppLanguage.khmer: 'អត្តសញ្ញាណសិស្ស'},
    'dashboard': {AppLanguage.english: 'Dashboard', AppLanguage.khmer: 'ផ្ទាំងព័ត៌មាន'},
    'today_classes': {AppLanguage.english: "Today's Classes", AppLanguage.khmer: 'ថ្នាក់រៀនថ្ងៃនេះ'},
    'gpa_card_desc': {AppLanguage.english: 'Excellent standing', AppLanguage.khmer: 'លទ្ធផលសិក្សាល្អប្រសើរ'},
    'new_announcements': {AppLanguage.english: 'New announcements pending', AppLanguage.khmer: 'ការជូនដំណឹងថ្មីកំពុងរង់ចាំ'},
    'retry': {AppLanguage.english: 'Retry', AppLanguage.khmer: 'ព្យាយាមម្តងទៀត'},
    'error_loading': {AppLanguage.english: 'Error loading data. Check connection.', AppLanguage.khmer: 'មានបញ្ហាក្នុងការទាញទិន្នន័យ។'},
    'password_changed': {AppLanguage.english: 'Password changed successfully', AppLanguage.khmer: 'ផ្លាស់ប្តូរពាក្យសម្ងាត់ជោគជ័យ'},
    'profile_updated': {AppLanguage.english: 'Profile updated successfully', AppLanguage.khmer: 'ធ្វើបច្ចុប្បន្នភាពគណនីជោគជ័យ'},
    'empty_fields_error': {AppLanguage.english: 'Please fill in all fields', AppLanguage.khmer: 'សូមបំពេញព័ត៌មានឱ្យបានគ្រប់គ្រាន់'},
    'passwords_dont_match': {AppLanguage.english: 'Passwords do not match', AppLanguage.khmer: 'ពាក្យសម្ងាត់ទាំងពីរមិនដូចគ្នាទេ'},
    'invalid_email': {AppLanguage.english: 'Please enter a valid email address', AppLanguage.khmer: 'សូមបញ្ចូលអ៊ីមែលដែលត្រឹមត្រូវ'},
    'library': {AppLanguage.english: 'Library', AppLanguage.khmer: 'បណ្ណាល័យ'},
    'search_books': {AppLanguage.english: 'Search books...', AppLanguage.khmer: 'ស្វែងរកសៀវភៅ...'},
    'no_books_found': {AppLanguage.english: 'No books found.', AppLanguage.khmer: 'រកមិនឃើញសៀវភៅទេ'},
    'book_details': {AppLanguage.english: 'Book Details', AppLanguage.khmer: 'ព័ត៌មានលម្អិតសៀវភៅ'},
    'authors': {AppLanguage.english: 'Author(s)', AppLanguage.khmer: 'អ្នកនិពន្ធ'},
    'publish_year': {AppLanguage.english: 'First Published', AppLanguage.khmer: 'បោះពុម្ពដំបូង'},
    'subjects': {AppLanguage.english: 'Subjects', AppLanguage.khmer: 'ប្រធានបទ'},
    
    // New Translations
    'assignments': {AppLanguage.english: 'Assignments', AppLanguage.khmer: 'កិច្ចការសាលា'},
    'attendance': {AppLanguage.english: 'Attendance', AppLanguage.khmer: 'វត្តមាន'},
    'campus_news': {AppLanguage.english: 'Campus Events', AppLanguage.khmer: 'ព្រឹត្តិការណ៍សាលា'},
    'gpa_planner': {AppLanguage.english: 'GPA Target Planner', AppLanguage.khmer: 'ផែនការមធ្យមភាគពិន្ទុ'},
    'upcoming_assignments': {AppLanguage.english: 'Upcoming Coursework', AppLanguage.khmer: 'កិច្ចការសាលាបន្ទាប់'},
    'view_all': {AppLanguage.english: 'View All', AppLanguage.khmer: 'មើលទាំងអស់'},
    'attendance_rate': {AppLanguage.english: 'Attendance Rate', AppLanguage.khmer: 'អត្រាវត្តមាន'},
    'borrowed_books': {AppLanguage.english: 'Borrowed Books', AppLanguage.khmer: 'សៀវភៅបានខ្ចី'},
    'no_books_borrowed': {AppLanguage.english: 'No books currently borrowed.', AppLanguage.khmer: 'គ្មានសៀវភៅកំពុងខ្ចីនោះទេ។'},
    'due_date': {AppLanguage.english: 'Due Date', AppLanguage.khmer: 'កាលបរិច្ឆេទកំណត់'},
    'status': {AppLanguage.english: 'Status', AppLanguage.khmer: 'ស្ថានភាព'},
    'upcoming': {AppLanguage.english: 'Upcoming', AppLanguage.khmer: 'កិច្ចការថ្មី'},
    'submitted': {AppLanguage.english: 'Submitted', AppLanguage.khmer: 'បានប្រគល់'},
    'overdue': {AppLanguage.english: 'Overdue', AppLanguage.khmer: 'ហួសកំណត់'},
    'graded': {AppLanguage.english: 'Graded', AppLanguage.khmer: 'បានកែរួច'},
    'digital_catalog': {AppLanguage.english: 'Digital Catalog', AppLanguage.khmer: 'កាតាឡុកឌីជីថល'},
    'gpa_target': {AppLanguage.english: 'Target Cumulative GPA', AppLanguage.khmer: 'គោលដៅ GPA សរុប'},
    'projected_gpa': {AppLanguage.english: 'Projected Term GPA', AppLanguage.khmer: 'ការប៉ាន់ស្មាន GPA ឆមាស'},
    'calculate': {AppLanguage.english: 'Calculate', AppLanguage.khmer: 'គណនា'},
    'monday': {AppLanguage.english: 'Monday', AppLanguage.khmer: 'ថ្ងៃចន្ទ'},
    'tuesday': {AppLanguage.english: 'Tuesday', AppLanguage.khmer: 'ថ្ងៃអង្គារ'},
    'wednesday': {AppLanguage.english: 'Wednesday', AppLanguage.khmer: 'ថ្ងៃពុធ'},
    'thursday': {AppLanguage.english: 'Thursday', AppLanguage.khmer: 'ថ្ងៃព្រហស្បតិ៍'},
    'friday': {AppLanguage.english: 'Friday', AppLanguage.khmer: 'ថ្ងៃសុក្រ'},
  };

  String translate(String key) {
    if (_localizedStrings.containsKey(key)) {
      return _localizedStrings[key]![_language] ?? key;
    }
    return key;
  }
}

// Simple InheritedWidget to pass down AppState throughout the widget tree
class AppStateProvider extends InheritedWidget {
  final AppState appState;

  const AppStateProvider({
    super.key,
    required this.appState,
    required super.child,
  });

  static AppState of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    assert(provider != null, 'No AppStateProvider found in context');
    return provider!.appState;
  }

  @override
  bool updateShouldNotify(AppStateProvider oldWidget) => appState != oldWidget.appState;
}

// BuildContext extension for cleaner and easier state access
extension AppStateContext on BuildContext {
  AppState get appState => AppStateProvider.of(this);
}
