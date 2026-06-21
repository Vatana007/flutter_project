import 'package:flutter/material.dart';
import 'package:project_flutter/services/app_state.dart';
import 'package:project_flutter/services/api_service.dart';
import 'package:project_flutter/models/schedule_item.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final ApiService _apiService = ApiService();
  
  List<ScheduleItem> _allSchedules = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  // Weekday selection state
  String _selectedDay = 'Monday';
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  void initState() {
    super.initState();
    _fetchScheduleData();
  }

  Future<void> _fetchScheduleData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _apiService.fetchSchedule();
      setState(() {
        _allSchedules = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = context.appState.translate('error_loading');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.appState;
    final isDark = appState.isDarkMode;
    final theme = Theme.of(context);
    
    // Filter schedules based on active selected day
    final filteredSchedule = _allSchedules.where((item) => item.day == _selectedDay).toList();

    return Column(
      children: [
        // Horizontal Day Selector
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 8),
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _days.length,
            itemBuilder: (context, index) {
              final day = _days[index];
              final isSelected = day == _selectedDay;
              
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ChoiceChip(
                  label: Text(
                    appState.translate(day.toLowerCase()).isEmpty
                        ? day
                        : day.substring(0, 3), // e.g. Mon, Tue
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: theme.primaryColor,
                  backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: isSelected ? 4 : 0,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedDay = day;
                      });
                    }
                  },
                ),
              );
            },
          ),
        ),
        
        // Schedule Content Body
        Expanded(
          child: RefreshIndicator(
            onRefresh: _fetchScheduleData,
            color: theme.primaryColor,
            child: _buildBody(filteredSchedule, isDark),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(List<ScheduleItem> schedules, bool isDark) {
    final theme = Theme.of(context);
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: theme.primaryColor),
            const SizedBox(height: 16),
            const Text(
              'Fetching academic timetable...',
              style: TextStyle(fontWeight: FontWeight.w500),
            )
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 60, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _fetchScheduleData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: Text(context.appState.translate('retry')),
              ),
            ],
          ),
        ),
      );
    }

    if (schedules.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : theme.primaryColor.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.weekend_rounded,
                  size: 50,
                  color: isDark ? const Color(0xFF94A3B8) : theme.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'No classes scheduled today',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Enjoy your day off or review notes!',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        final item = schedules[index];
        return _buildScheduleCard(item, isDark);
      },
    );
  }

  Widget _buildScheduleCard(ScheduleItem item, bool isDark) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : theme.primaryColor.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left Colored time-indicator block
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: _getCardIndicatorColor(item.id),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            
            // Text Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time and Room row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time_filled_rounded, size: 16, color: theme.primaryColor),
                            const SizedBox(width: 6),
                            Text(
                              '${item.startTime} - ${item.endTime}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            item.subject.room,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Subject Title
                    Text(
                      item.subject.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // Subject Code
                    Text(
                      item.subject.code,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Divider(height: 1),
                    ),
                    
                    // Lecturer and Credits Info row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person_rounded, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              item.subject.lecturer,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${item.subject.credits} Credits',
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCardIndicatorColor(String id) {
    final index = int.tryParse(id) ?? 0;
    const colors = [
      Color(0xFF0D9488), // Teal
      Color(0xFF10B981), // Emerald
      Color(0xFFEC4899), // Pink
      Color(0xFFF59E0B), // Amber
    ];
    return colors[index % colors.length];
  }
}
