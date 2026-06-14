import 'package:flutter/material.dart';
import 'package:project_flutter/services/app_state.dart';
import 'package:project_flutter/widgets/dashboard_card.dart';
import 'package:project_flutter/models/notification.dart';

class HomeScreen extends StatelessWidget {
  final AppState appState;
  final ValueChanged<int> onNavigateToTab;

  const HomeScreen({
    super.key,
    required this.appState,
    required this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    final student = appState.currentStudent;
    final isDark = appState.isDarkMode;

    if (student == null) return const SizedBox();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF334155)]
                    : [const Color(0xFFEEF2FF), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: isDark ? const Color(0xFF1E293B) : Colors.indigo.withOpacity(0.08),
                width: 1.5,
              ),
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
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        student.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFE0E7FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          student.major,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage(student.avatarUrl),
                  backgroundColor: Colors.indigo.shade100,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Dashboard Metrics Cards
          DashboardCard(
            title: appState.translate('today_classes').toUpperCase(),
            value: '4 Subjects',
            subtitle: '08:00 AM - 11:00 AM • Lab 102',
            icon: Icons.calendar_month_rounded,
            gradientColors: const [Color(0xFF6366F1), Color(0xFF4F46E5)],
            onTap: () => onNavigateToTab(1), // Go to Schedule tab
          ),

          DashboardCard(
            title: appState.translate('gpa').toUpperCase(),
            value: student.gpa.toStringAsFixed(2),
            subtitle: appState.translate('gpa_card_desc'),
            icon: Icons.stars_rounded,
            gradientColors: const [Color(0xFF10B981), Color(0xFF059669)],
            onTap: () => onNavigateToTab(2), // Go to Result tab
          ),

          DashboardCard(
            title: appState.translate('notifications').toUpperCase(),
            value: '${appState.unreadNotificationsCount} Unread',
            subtitle: appState.translate('new_announcements'),
            icon: Icons.notifications_active_rounded,
            gradientColors: const [Color(0xFFF59E0B), Color(0xFFD97706)],
            onTap: () {
              // Programmatically trigger Notification Screen
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          const SizedBox(height: 8),

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
                    color: isDark ? Colors.indigo.shade300 : const Color(0xFF4F46E5),
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
                      ),
                    ),
                  ),
                );
              }
              return Column(
                children: list.map((notif) => _buildAnnouncementItem(context, notif)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementItem(BuildContext context, AppNotification notification) {
    final isDark = appState.isDarkMode;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.campaign_rounded,
              color: Color(0xFF4F46E5),
              size: 20,
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
                    fontSize: 14,
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
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notification.timestamp,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
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
}
