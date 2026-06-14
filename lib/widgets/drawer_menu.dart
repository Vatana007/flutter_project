import 'package:flutter/material.dart';
import 'package:project_flutter/services/app_state.dart';
import 'package:project_flutter/screens/settings_screen.dart';
import 'package:project_flutter/screens/login_screen.dart';

class DrawerMenu extends StatelessWidget {
  final AppState appState;

  const DrawerMenu({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final student = appState.currentStudent;
    final isDark = appState.isDarkMode;

    if (student == null) return const SizedBox();

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      child: Column(
        children: [
          // Drawer Header with Student Profile
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E1B4B), const Color(0xFF311042)]
                    : [const Color(0xFF6366F1), const Color(0xFF4F46E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(student.avatarUrl),
                onBackgroundImageError: (_, __) {},
                child: student.avatarUrl.isEmpty
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
            ),
            accountName: Text(
              student.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            accountEmail: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID: ${student.id}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  student.email,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
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
                  icon: Icons.settings_outlined,
                  title: appState.translate('settings'),
                  onTap: () {
                    Navigator.pop(context); // Close Drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(appState: appState),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.info_outline_rounded,
                  title: appState.translate('about_app'),
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDialog(context);
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.help_outline_rounded,
                  title: appState.translate('help_support'),
                  onTap: () {
                    Navigator.pop(context);
                    _showSupportDialog(context);
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
                  onTap: () {
                    Navigator.pop(context); // Close Drawer
                    _confirmLogout(context);
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
                fontWeight: FontWeight.w500,
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
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    final isDark = appState.isDarkMode;
    final defaultIconColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    final defaultTextColor = isDark ? Colors.white : const Color(0xFF1E293B);

    return ListTile(
      leading: Icon(icon, color: iconColor ?? defaultIconColor),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? defaultTextColor,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: appState.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          appState.translate('about_app'),
          style: TextStyle(color: appState.isDarkMode ? Colors.white : const Color(0xFF0F172A)),
        ),
        content: Text(
          'EduTrack Mobile is designed to empower students with rapid access to class schedules, GPA performance tracking, and direct administrative announcements. Built with Flutter, RESTful APIs, and a sleek Material 3 Design.',
          style: TextStyle(
            color: appState.isDarkMode ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: appState.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          appState.translate('help_support'),
          style: TextStyle(color: appState.isDarkMode ? Colors.white : const Color(0xFF0F172A)),
        ),
        content: Text(
          'For technical support or assistance, please contact university IT support:\n\nEmail: support@edutrack.edu.kh\nPhone: +855 23 888 999',
          style: TextStyle(
            color: appState.isDarkMode ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: appState.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(appState.translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              appState.logoutStudent();
              // Reset navigation stack to Login
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
