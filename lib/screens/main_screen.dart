import 'package:flutter/material.dart';
import 'package:project_flutter/services/app_state.dart';
import 'package:project_flutter/widgets/drawer_menu.dart';
import 'package:project_flutter/screens/home_screen.dart';
import 'package:project_flutter/screens/schedule_screen.dart';
import 'package:project_flutter/screens/result_screen.dart';
import 'package:project_flutter/screens/profile_screen.dart';
import 'package:project_flutter/screens/notifications_screen.dart';
import 'package:project_flutter/screens/library_screen.dart';
import 'package:project_flutter/services/api_service.dart';
import 'package:project_flutter/models/student.dart';
import 'package:project_flutter/models/notification.dart';
import 'package:project_flutter/models/assignment.dart';
import 'package:project_flutter/models/attendance_item.dart';
import 'package:project_flutter/models/campus_event.dart';
import 'package:project_flutter/models/borrowed_book.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final ApiService _apiService = ApiService();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(
        onNavigateToTab: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      const ScheduleScreen(),
      const ResultScreen(),
      const LibraryScreen(),
      const ProfileScreen(),
    ];
    
    // Fetch unified database data safely after context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllData();
    });
  }

  void _loadAllData() async {
    if (!mounted) return;
    final state = context.appState;
    try {
      // Pre-fetch DB cache
      await _apiService.fetchDb();
      
      // Load all dynamic sets in parallel
      final results = await Future.wait([
        _apiService.fetchStudent(),
        _apiService.fetchNotifications(),
        _apiService.fetchAssignments(),
        _apiService.fetchAttendance(),
        _apiService.fetchCampusNews(),
        _apiService.fetchBorrowedBooks(),
      ]);

      if (mounted) {
        state.loginStudent(results[0] as Student);
        state.setNotifications(results[1] as List<AppNotification>);
        state.setAssignments(results[2] as List<Assignment>);
        state.setAttendance(results[3] as List<AttendanceItem>);
        state.setCampusNews(results[4] as List<CampusEvent>);
        state.setBorrowedBooks(results[5] as List<BorrowedBook>);
      }
    } catch (_) {
      // Fallback handlers in state/api keep everything safe
    }
  }

  String _getPageTitle(int index, AppState state) {
    switch (index) {
      case 0:
        return state.translate('dashboard');
      case 1:
        return state.translate('schedule');
      case 2:
        return state.translate('result');
      case 3:
        return state.translate('library');
      case 4:
        return state.translate('profile');
      default:
        return state.translate('app_title');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.appState;
    final isDark = state.isDarkMode;
    final theme = Theme.of(context);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return ListenableBuilder(
      listenable: state,
      builder: (context, child) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
            centerTitle: true,
            title: Text(
              _getPageTitle(_currentIndex, state),
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF1E293B),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.menu_rounded,
                color: theme.primaryColor,
                size: 26,
              ),
              onPressed: () {
                scaffoldKey.currentState?.openDrawer();
              },
            ),
            actions: [
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      color: theme.primaryColor,
                      size: 26,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  if (state.unreadNotificationsCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${state.unreadNotificationsCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
          drawer: const DrawerMenu(),
          body: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black.withOpacity(0.3) : theme.primaryColor.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              selectedItemColor: theme.primaryColor,
              unselectedItemColor: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              selectedFontSize: 12,
              unselectedFontSize: 12,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, height: 1.5),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, height: 1.5),
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.dashboard_outlined),
                  activeIcon: const Icon(Icons.dashboard_rounded),
                  label: state.translate('home'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.calendar_month_outlined),
                  activeIcon: const Icon(Icons.calendar_month_rounded),
                  label: state.translate('schedule'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.assignment_outlined),
                  activeIcon: const Icon(Icons.assignment_rounded),
                  label: state.translate('result'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.local_library_outlined),
                  activeIcon: const Icon(Icons.local_library_rounded),
                  label: state.translate('library'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outline_rounded),
                  activeIcon: const Icon(Icons.person_rounded),
                  label: state.translate('profile'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
