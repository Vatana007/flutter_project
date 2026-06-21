import 'package:flutter/material.dart';
import 'package:project_flutter/services/app_state.dart';
import 'package:project_flutter/screens/settings_screen.dart';
import 'package:project_flutter/screens/login_screen.dart';
import 'package:project_flutter/screens/assignments_screen.dart';
import 'package:project_flutter/screens/attendance_screen.dart';
import 'package:project_flutter/screens/campus_news_screen.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.appState;
    final student = appState.currentStudent;
    final isDark = appState.isDarkMode;
    final theme = Theme.of(context);

    if (student == null) return const SizedBox();

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      child: Column(
        children: [
          // Drawer Header with Student Profile
          // Custom centered Drawer Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [theme.primaryColor, theme.primaryColor.withOpacity(0.85)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Centered profile picture
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(student.avatarUrl),
                    onBackgroundImageError: (exception, stackTrace) {},
                    child: student.avatarUrl.isEmpty
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Centered Name
                Text(
                  student.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                
                // Centered ID Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'ID: ${student.id}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Centered Email
                Text(
                  student.email,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Drawer Links
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context: context,
                  icon: Icons.assignment_rounded,
                  title: appState.translate('assignments'),
                  appState: appState,
                  onTap: () {
                    Navigator.pop(context); // Close Drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AssignmentsScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.how_to_reg_rounded,
                  title: appState.translate('attendance'),
                  appState: appState,
                  onTap: () {
                    Navigator.pop(context); // Close Drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AttendanceScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.campaign_rounded,
                  title: appState.translate('campus_news'),
                  appState: appState,
                  onTap: () {
                    Navigator.pop(context); // Close Drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CampusNewsScreen()),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(),
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.settings_outlined,
                  title: appState.translate('settings'),
                  appState: appState,
                  onTap: () {
                    Navigator.pop(context); // Close Drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.info_outline_rounded,
                  title: appState.translate('about_app'),
                  appState: appState,
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDialog(context, appState);
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.help_outline_rounded,
                  title: appState.translate('help_support'),
                  appState: appState,
                  onTap: () {
                    Navigator.pop(context);
                    _showSupportDialog(context, appState);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(),
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.logout_rounded,
                  title: appState.translate('logout'),
                  iconColor: Colors.redAccent,
                  textColor: Colors.redAccent,
                  appState: appState,
                  onTap: () {
                    Navigator.pop(context); // Close Drawer
                    _confirmLogout(context, appState);
                  },
                ),
              ],
            ),
          ),
          
          // App Version Footer
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              'EduTrack Mobile v1.0.0',
              style: TextStyle(
                color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required AppState appState,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    final isDark = appState.isDarkMode;
    final defaultIconColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569);
    final defaultTextColor = isDark ? Colors.white : const Color(0xFF1E293B);

    return ListTile(
      leading: Icon(icon, color: iconColor ?? defaultIconColor),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? defaultTextColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showAboutDialog(BuildContext context, AppState appState) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: appState.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          appState.translate('about_app'),
          style: TextStyle(
            color: appState.isDarkMode ? Colors.white : const Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'EduTrack Mobile is designed to empower students with rapid access to class schedules, GPA performance tracking, and direct administrative announcements. Built with Flutter, RESTful APIs, and a sleek Material 3 Design.',
          style: TextStyle(
            color: appState.isDarkMode ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor)),
          ),
        ],
      ),
    );
  }

  void _showSupportDialog(BuildContext context, AppState appState) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: appState.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          appState.translate('help_support'),
          style: TextStyle(
            color: appState.isDarkMode ? Colors.white : const Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'For technical support or assistance, please contact university IT support:\n\nEmail: support@edutrack.edu.kh\nPhone: +855 23 888 999',
          style: TextStyle(
            color: appState.isDarkMode ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor)),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: appState.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'Are you sure you want to log out of your account?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              appState.translate('cancel'),
              style: TextStyle(
                color: appState.isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              appState.logoutStudent();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
