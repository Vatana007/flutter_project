import 'package:flutter/material.dart';
import 'package:project_flutter/services/app_state.dart';
import 'package:project_flutter/widgets/drawer_menu.dart';
import 'package:project_flutter/screens/home_screen.dart';
import 'package:project_flutter/screens/schedule_screen.dart';
import 'package:project_flutter/screens/result_screen.dart';
import 'package:project_flutter/screens/profile_screen.dart';
import 'package:project_flutter/screens/notifications_screen.dart';
import 'package:project_flutter/services/api_service.dart';

class MainScreen extends StatefulWidget {
  final AppState appState;

  const MainScreen({super.key, required this.appState});

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
        appState: widget.appState,
        onNavigateToTab: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      ScheduleScreen(appState: widget.appState),
      ResultScreen(appState: widget.appState),
      ProfileScreen(appState: widget.appState),
    ];
    
    _loadNotifications();
  }

  void _loadNotifications() async {
    try {
      final notifs = await _apiService.fetchNotifications();
      widget.appState.setNotifications(notifs);
    } catch (_) {
      // Ignored, state fallback handles it
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
        return state.translate('profile');
      default:
        return state.translate('app_title');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.appState;
    final isDark = state.isDarkMode;
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
                color: isDark ? Colors.indigo.shade300 : const Color(0xFF4F46E5),
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
                      color: isDark ? Colors.indigo.shade300 : const Color(0xFF4F46E5),
                      size: 26,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsScreen(appState: state),
                        ),
                      );
                    },
                  ),
                  if (state.unreadNotificationsCount > 0)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
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
          drawer: DrawerMenu(appState: state),
          body: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black.withOpacity(0.3) : Colors.indigo.withOpacity(0.06),
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
              selectedItemColor: const Color(0xFF4F46E5),
              unselectedItemColor: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, height: 1.5),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, height: 1.5),
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
