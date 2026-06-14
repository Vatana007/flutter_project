import 'package:flutter/material.dart';
import 'package:project_flutter/models/student.dart';
import 'package:project_flutter/models/notification.dart';

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

  // Local Notifications state (caches and handles read/unread marking locally)
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
  };

  String translate(String key) {
    if (_localizedStrings.containsKey(key)) {
      return _localizedStrings[key]![_language] ?? key;
    }
    return key;
  }
}
