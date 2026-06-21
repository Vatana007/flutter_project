import 'package:flutter/material.dart';
import 'package:project_flutter/services/app_state.dart';
import 'package:project_flutter/models/campus_event.dart';

class CampusNewsScreen extends StatelessWidget {
  const CampusNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.appState;
    final isDark = appState.isDarkMode;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          appState.translate('campus_news'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.primaryColor,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, child) {
          final news = appState.campusNews;

          if (news.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.campaign_rounded,
                    size: 64,
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No news or events posted',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: news.length,
            itemBuilder: (context, index) {
              final event = news[index];
              return _buildEventCard(context, event, appState, isDark, theme);
            },
          );
        },
      ),
    );
  }

  Widget _buildEventCard(
    BuildContext context,
    CampusEvent event,
    AppState appState,
    bool isDark,
    ThemeData theme,
  ) {
    Color categoryColor = Colors.blueAccent;
    if (event.category == 'sports') {
      categoryColor = const Color(0xFFEC4899);
    } else if (event.category == 'workshop') {
      categoryColor = const Color(0xFF10B981);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image with category badge
          Stack(
            children: [
              Image.network(
                event.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                  child: const Center(
                    child: Icon(Icons.image_not_supported_rounded, size: 48, color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    event.category.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Event texts
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, size: 14, color: theme.primaryColor),
                        const SizedBox(width: 6),
                        Text(
                          event.date,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.people_rounded, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          '${event.rsvpCount} RSVP',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(height: 1),
                ),
                
                // Registration button row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      event.isRegistered ? 'Registered' : 'Wanna go?',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: event.isRegistered ? const Color(0xFF10B981) : Colors.grey,
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: event.isRegistered
                            ? const Color(0xFF10B981).withOpacity(0.12)
                            : theme.primaryColor,
                        foregroundColor: event.isRegistered
                            ? const Color(0xFF10B981)
                            : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      ),
                      onPressed: () {
                        appState.toggleEventRsvpLocal(event.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    event.isRegistered
                                        ? 'Cancelled registration for ${event.title}.'
                                        : 'Successfully registered for ${event.title}!',
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: event.isRegistered ? Colors.grey : const Color(0xFF0D9488),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                      icon: Icon(
                        event.isRegistered ? Icons.check_circle_outline_rounded : Icons.add_circle_outline_rounded,
                        size: 16,
                      ),
                      label: Text(
                        event.isRegistered ? 'RSVP\'d' : 'Register',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
