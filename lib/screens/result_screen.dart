import 'package:flutter/material.dart';
import 'package:project_flutter/services/app_state.dart';
import 'package:project_flutter/services/api_service.dart';
import 'package:project_flutter/models/grade.dart';

class ResultScreen extends StatefulWidget {
  final AppState appState;

  const ResultScreen({super.key, required this.appState});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  
  List<Grade> _grades = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  late AnimationController _gpaController;
  late Animation<double> _gpaAnimation;

  @override
  void initState() {
    super.initState();
    _gpaController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _gpaAnimation = Tween<double>(begin: 0, end: 0).animate(_gpaController);
    
    _fetchGradesData();
  }

  Future<void> _fetchGradesData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _apiService.fetchGrades();
      
      // Calculate active GPA from fetched items
      double totalPoints = 0;
      int totalCredits = 0;
      for (var grade in data) {
        totalPoints += (grade.gpaValue * grade.credits);
        totalCredits += grade.credits;
      }
      
      final gpa = totalCredits > 0 ? (totalPoints / totalCredits) : 0.0;

      setState(() {
        _grades = data;
        _isLoading = false;
        
        // Re-setup GPA animation for visual effect
        _gpaAnimation = Tween<double>(
          begin: 0,
          end: gpa,
        ).animate(CurvedAnimation(parent: _gpaController, curve: Curves.easeOutCubic));
      });
      
      _gpaController.reset();
      _gpaController.forward();
    } catch (e) {
      setState(() {
        _errorMessage = widget.appState.translate('error_loading');
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _gpaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.appState.isDarkMode;

    return RefreshIndicator(
      onRefresh: _fetchGradesData,
      color: const Color(0xFF4F46E5),
      child: _buildBody(isDark),
    );
  }

  Widget _buildBody(bool isDark) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF4F46E5)),
            SizedBox(height: 16),
            Text(
              'Compiling semester records...',
              style: TextStyle(fontWeight: FontWeight.w500),
            )
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, size: 60, color: Colors.redAccent),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _fetchGradesData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(widget.appState.translate('retry')),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final totalCredits = _grades.fold<int>(0, (sum, grade) => sum + grade.credits);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        // Premium GPA Card with animated circular progress
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                  : [Colors.white, const Color(0xFFEEF2FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : Colors.indigo.withOpacity(0.08),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black26 : Colors.indigo.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Row(
            children: [
              // GPA Progress Ring
              AnimatedBuilder(
                animation: _gpaAnimation,
                builder: (context, child) {
                  final progress = _gpaAnimation.value / 4.0;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 10,
                          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.indigo.withOpacity(0.08),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _gpaAnimation.value.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            '/ 4.00',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(width: 24),
              // Stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.appState.translate('gpa'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Semester: Year 3, Semester 1',
                      style: TextStyle(
                        fontSize: 12,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Divider(height: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatBox('Subjects', '${_grades.length}', isDark),
                        _buildStatBox('Credits', '$totalCredits', isDark),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Result list header
        Text(
          'Detailed Grade Sheet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 16),

        // List of Grades
        ..._grades.map((grade) => _buildGradeListItem(grade, isDark)),
      ],
    );
  }

  Widget _buildStatBox(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildGradeListItem(Grade grade, bool isDark) {
    final gradeColor = _getGradeColor(grade.gradeLetter);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Letter Grade badge
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: gradeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              grade.gradeLetter,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: gradeColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Subject Text details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  grade.subjectName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      grade.subjectCode,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${grade.credits} Credits',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          
          // Score metrics
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${grade.score}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'GP: ${grade.gpaValue.toStringAsFixed(1)}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String letter) {
    if (letter == 'A') return const Color(0xFF10B981); // Emerald
    if (letter.startsWith('B')) return const Color(0xFF4F46E5); // Indigo
    if (letter.startsWith('C')) return const Color(0xFFF59E0B); // Amber
    if (letter.startsWith('D')) return const Color(0xFFEC4899); // Pink
    return Colors.redAccent; // F
  }
}
