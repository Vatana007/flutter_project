import 'package:flutter/material.dart';
import 'package:project_flutter/services/app_state.dart';
import 'package:project_flutter/widgets/dashboard_card.dart';
import 'package:project_flutter/models/notification.dart';
import 'package:project_flutter/models/assignment.dart';
import 'package:project_flutter/screens/assignments_screen.dart';
import 'package:project_flutter/screens/attendance_screen.dart';
import 'package:project_flutter/screens/campus_news_screen.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onNavigateToTab;

  const HomeScreen({
    super.key,
    required this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.appState;
    final student = appState.currentStudent;
    final isDark = appState.isDarkMode;
    final theme = Theme.of(context);

    if (student == null) return const SizedBox();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Premium Welcome Card with pattern
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF334155)]
                    : [const Color(0xFFEEF2FF), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : theme.primaryColor.withOpacity(0.08),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : theme.primaryColor.withOpacity(0.03),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back, 👋',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        student.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : theme.primaryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          student.major,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Premium profile photo border
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.primaryColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 38,
                    backgroundImage: NetworkImage(student.avatarUrl),
                    backgroundColor: Colors.indigo.shade50,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quick Actions Row title and widgets
          Text(
            appState.translate('dashboard').toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuickAction(
                context: context,
                icon: Icons.assignment_rounded,
                label: appState.translate('assignments'),
                color: const Color(0xFF3B82F6),
                isDark: isDark,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AssignmentsScreen()),
                ),
              ),
              _buildQuickAction(
                context: context,
                icon: Icons.how_to_reg_rounded,
                label: appState.translate('attendance'),
                color: const Color(0xFF10B981),
                isDark: isDark,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AttendanceScreen()),
                ),
              ),
              _buildQuickAction(
                context: context,
                icon: Icons.campaign_rounded,
                label: appState.translate('campus_news'),
                color: const Color(0xFFF59E0B),
                isDark: isDark,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CampusNewsScreen()),
                ),
              ),
              _buildQuickAction(
                context: context,
                icon: Icons.insights_rounded,
                label: appState.translate('gpa_planner'),
                color: const Color(0xFF8B5CF6),
                isDark: isDark,
                onTap: () => onNavigateToTab(2), // Go to Result tab
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Dashboard Metrics Cards
          DashboardCard(
            title: appState.translate('today_classes').toUpperCase(),
            value: '6 Subjects', // Sync with database count
            subtitle: '08:00 AM - 04:00 PM • Lab 101/102',
            icon: Icons.calendar_month_rounded,
            gradientColors: const [Color(0xFF0D9488), Color(0xFF0F766E)],
            onTap: () => onNavigateToTab(1), // Go to Schedule tab
          ),

          DashboardCard(
            title: appState.translate('gpa').toUpperCase(),
            value: student.gpa.toStringAsFixed(2),
            subtitle: appState.translate('gpa_card_desc'),
            icon: Icons.stars_rounded,
            gradientColors: const [Color(0xFF14B8A6), Color(0xFF0D9488)],
            onTap: () => onNavigateToTab(2), // Go to Result tab
          ),

          DashboardCard(
            title: appState.translate('attendance_rate').toUpperCase(),
            value: '${(student.attendanceRate * 100).toStringAsFixed(0)}%',
            subtitle: 'Perfect standing • Goal: >90%',
            icon: Icons.pie_chart_rounded,
            gradientColors: const [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AttendanceScreen()),
            ),
          ),

          DashboardCard(
            title: appState.translate('notifications').toUpperCase(),
            value: '${appState.unreadNotificationsCount} Unread',
            subtitle: appState.translate('new_announcements'),
            icon: Icons.notifications_active_rounded,
            gradientColors: const [Color(0xFF475569), Color(0xFF334155)],
            onTap: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          const SizedBox(height: 20),

          // Upcoming Assignments Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appState.translate('upcoming_assignments'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AssignmentsScreen()),
                  );
                },
                child: Text(
                  appState.translate('view_all'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          ListenableBuilder(
            listenable: appState,
            builder: (context, child) {
              final list = appState.assignments.where((a) => a.status == 'pending').take(2).toList();
              if (list.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                      width: 1.2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'No pending assignments 🎉',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                );
              }
              return Column(
                children: list.map((assign) => _buildAssignmentCard(context, assign, isDark, theme)).toList(),
              );
            },
          ),
          const SizedBox(height: 24),

          // Recent Announcements Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appState.translate('recent_announcements'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/notifications');
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Recent Announcements Preview
          ListenableBuilder(
            listenable: appState,
            builder: (context, child) {
              final list = appState.notifications.take(3).toList();
              if (list.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      appState.translate('no_notifications'),
                      style: TextStyle(
                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }
              return Column(
                children: list.map((notif) => _buildAnnouncementItem(context, notif, appState)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementItem(BuildContext context, AppNotification notification, AppState appState) {
    final isDark = appState.isDarkMode;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black12 : theme.primaryColor.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.campaign_rounded,
              color: theme.primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notification.timestamp,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: (MediaQuery.of(context).size.width - 40 - 24) / 4,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
            width: 1.2,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(BuildContext context, Assignment assignment, bool isDark, ThemeData theme) {
    final priorityColor = assignment.priority == 'high'
        ? Colors.redAccent
        : (assignment.priority == 'medium' ? Colors.orangeAccent : Colors.blueAccent);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AssignmentsScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.assignment_rounded, color: priorityColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assignment.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${assignment.subjectCode} • Due: ${assignment.dueDate}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: isDark ? Colors.white30 : Colors.black26),
          ],
        ),
      ),
    );
  }
}
