import 'package:flutter/material.dart';
import 'package:project_flutter/services/app_state.dart';
import 'package:project_flutter/models/notification.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.appState;
    final isDark = appState.isDarkMode;
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: appState,
      builder: (context, child) {
        final notificationsList = appState.notifications;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              appState.translate('notifications'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: theme.primaryColor,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (appState.unreadNotificationsCount > 0)
                IconButton(
                  tooltip: 'Mark all as read',
                  icon: Icon(
                    Icons.done_all_rounded,
                    color: theme.primaryColor,
                    size: 22,
                  ),
                  onPressed: () {
                    appState.markAllNotificationsAsRead();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                            SizedBox(width: 12),
                            Expanded(child: Text('All notifications marked as read.')),
                          ],
                        ),
                        backgroundColor: const Color(0xFF0D9488),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        duration: const Duration(milliseconds: 1500),
                      ),
                    );
                  },
                ),
              const SizedBox(width: 8),
            ],
          ),
          body: notificationsList.isEmpty
              ? _buildEmptyState(theme, isDark, appState)
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: notificationsList.length,
                  itemBuilder: (context, index) {
                    final notif = notificationsList[index];
                    return _buildNotificationCard(context, notif, theme, isDark, appState);
                  },
                ),
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark, AppState appState) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : theme.primaryColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 56,
              color: isDark ? const Color(0xFF94A3B8) : theme.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            appState.translate('no_notifications'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, AppNotification notif, ThemeData theme, bool isDark, AppState appState) {
    final isUnread = !notif.isRead;
    
    final unreadColor = isDark 
        ? theme.primaryColor.withOpacity(0.12) 
        : theme.primaryColor.withOpacity(0.06);
    final readColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);

    return InkWell(
      onTap: () {
        if (isUnread) {
          appState.markNotificationAsRead(notif.id);
        }
        _showNotificationDetailDialog(context, notif, appState);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isUnread ? unreadColor : readColor,
          border: Border(
            bottom: BorderSide(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Icon Indicator
            Container(
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isUnread 
                    ? theme.primaryColor.withOpacity(0.18)
                    : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUnread ? Icons.mark_email_unread_rounded : Icons.drafts_rounded,
                color: isUnread ? theme.primaryColor : Colors.grey,
                size: 18,
              ),
            ),
            const SizedBox(width: 16),
            
            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notif.title,
                    style: TextStyle(
                      fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                      fontSize: 14,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notif.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                      color: subtitleColor,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notif.timestamp,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            
            // Unread Dot Badge
            if (isUnread)
              Container(
                margin: const EdgeInsets.only(left: 8, top: 6),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showNotificationDetailDialog(BuildContext context, AppNotification notif, AppState appState) {
    final isDark = appState.isDarkMode;
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.campaign_rounded, color: theme.primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    notif.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              notif.timestamp,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          notif.message,
          style: TextStyle(
            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
