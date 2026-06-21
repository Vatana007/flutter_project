import 'package:flutter/material.dart';
import 'package:project_flutter/services/app_state.dart';
import 'package:project_flutter/services/api_service.dart';
import 'package:project_flutter/models/grade.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

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

  // GPA Target Calculator State
  final Map<String, String> _projectedGrades = {};
  
  final List<Map<String, dynamic>> _currentCourses = [
    {'code': 'CS-301', 'name': 'Mobile Application Development', 'credits': 4},
    {'code': 'CS-302', 'name': 'Advanced Database Systems', 'credits': 3},
    {'code': 'CS-303', 'name': 'UX/UI Interface Design', 'credits': 3},
    {'code': 'CS-304', 'name': 'Software Engineering Methodology', 'credits': 4},
    {'code': 'CS-305', 'name': 'Cloud Architecture & Web Services', 'credits': 3},
    {'code': 'CS-306', 'name': 'Information Security & Cryptography', 'credits': 4},
  ];

  final List<String> _gradeOptions = ['A', 'B+', 'B', 'C+', 'C', 'D', 'F'];

  @override
  void initState() {
    super.initState();
    _gpaController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _gpaAnimation = Tween<double>(begin: 0, end: 0).animate(_gpaController);
    
    // Initialize calculator projections
    for (var course in _currentCourses) {
      _projectedGrades[course['code'] as String] = 'A';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchGradesData();
    });
  }

  Future<void> _fetchGradesData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _apiService.fetchGrades();
      
      double totalPoints = 0;
      int totalCredits = 0;
      for (var grade in data) {
        totalPoints += (grade.gpaValue * grade.credits);
        totalCredits += grade.credits;
      }
      
      final gpa = totalCredits > 0 ? (totalPoints / totalCredits) : 0.0;

      if (mounted) {
        setState(() {
          _grades = data;
          _isLoading = false;
          
          _gpaAnimation = Tween<double>(
            begin: 0,
            end: gpa,
          ).animate(CurvedAnimation(parent: _gpaController, curve: Curves.easeOutCubic));
        });
        
        _gpaController.reset();
        _gpaController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = context.appState.translate('error_loading');
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _gpaController.dispose();
    super.dispose();
  }

  double _getGpaValueFromLetter(String letter) {
    switch (letter) {
      case 'A': return 4.0;
      case 'B+': return 3.5;
      case 'B': return 3.0;
      case 'C+': return 2.5;
      case 'C': return 2.0;
      case 'D+': return 1.5;
      case 'D': return 1.0;
      default: return 0.0;
    }
  }

  double _calculateProjectedTermGpa() {
    double totalPoints = 0;
    int totalCredits = 0;
    for (var course in _currentCourses) {
      final code = course['code'] as String;
      final credits = course['credits'] as int;
      final letter = _projectedGrades[code] ?? 'A';
      totalPoints += (_getGpaValueFromLetter(letter) * credits);
      totalCredits += credits;
    }
    return totalCredits > 0 ? (totalPoints / totalCredits) : 0.0;
  }

  double _calculateProjectedCumulativeGpa(double currentGpa) {
    // Let's assume student has completed 45 credits historically with their current overall GPA
    final int historicalCredits = 45;
    final double historicalPoints = historicalCredits * currentGpa;
    
    double termPoints = 0;
    int termCredits = 0;
    for (var course in _currentCourses) {
      final code = course['code'] as String;
      final credits = course['credits'] as int;
      final letter = _projectedGrades[code] ?? 'A';
      termPoints += (_getGpaValueFromLetter(letter) * credits);
      termCredits += credits;
    }

    final totalCredits = historicalCredits + termCredits;
    final totalPoints = historicalPoints + termPoints;
    return totalCredits > 0 ? (totalPoints / totalCredits) : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.appState;
    final isDark = appState.isDarkMode;
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            child: TabBar(
              indicatorColor: theme.primaryColor,
              indicatorWeight: 3,
              labelColor: theme.primaryColor,
              unselectedLabelColor: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              tabs: [
                Tab(text: appState.translate('result').toUpperCase()),
                Tab(text: appState.translate('gpa_planner').toUpperCase()),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            RefreshIndicator(
              onRefresh: _fetchGradesData,
              color: theme.primaryColor,
              child: _buildBody(isDark, appState),
            ),
            _buildGpaPlannerBody(isDark, appState),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(bool isDark, AppState appState) {
    final theme = Theme.of(context);
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: theme.primaryColor),
            const SizedBox(height: 16),
            const Text(
              'Compiling semester records...',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _fetchGradesData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(appState.translate('retry')),
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
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                  : [Colors.white, const Color(0xFFEEF2FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : theme.primaryColor.withOpacity(0.08),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black38 : theme.primaryColor.withOpacity(0.04),
                blurRadius: 20,
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
                      // Glow effect container
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryColor.withOpacity(0.15),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 96,
                        height: 96,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 9,
                          backgroundColor: isDark ? const Color(0xFF1E293B) : theme.primaryColor.withOpacity(0.08),
                          valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
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
                      appState.translate('gpa'),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Semester: Year 2, Semester 2',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
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
        const SizedBox(height: 28),

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
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          // Letter Grade badge
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: gradeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              grade.gradeLetter,
              style: TextStyle(
                fontSize: 20,
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
                    fontSize: 15,
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
                      width: 3.5,
                      height: 3.5,
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
                        fontWeight: FontWeight.bold,
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
    if (letter.startsWith('B')) return const Color(0xFF0D9488); // Teal
    if (letter.startsWith('C')) return const Color(0xFFF59E0B); // Amber
    if (letter.startsWith('D')) return const Color(0xFFEC4899); // Pink
    return Colors.redAccent; // F
  }

  // NEW GPA TARGET PLANNER IMPLEMENTATION
  Widget _buildGpaPlannerBody(bool isDark, AppState appState) {
    final theme = Theme.of(context);
    final studentGpa = appState.currentStudent?.gpa ?? 3.82;
    
    final projectedTermGpa = _calculateProjectedTermGpa();
    final projectedCumulativeGpa = _calculateProjectedCumulativeGpa(studentGpa);

    // Hardcoded past GPA terms data for Painter
    final List<double> gpaHistory = [3.50, 3.62, 3.68, 3.75, studentGpa];
    final List<String> gpaLabels = ['Y1S1', 'Y1S2', 'Y2S1', 'Y2S2', 'Current'];

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        // Analytics Section
        Text(
          'GPA TREND ANALYSIS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),
        
        // Custom Line Chart Container
        Container(
          height: 200,
          padding: const EdgeInsets.only(top: 28, left: 16, right: 16, bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
              width: 1.2,
            ),
          ),
          child: CustomPaint(
            painter: _GpaTrendPainter(gpaHistory, gpaLabels, isDark, theme.primaryColor),
          ),
        ),
        const SizedBox(height: 28),

        // Summary Calculator metrics banner
        Text(
          'WHAT-IF GPA PLANNER',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF0D9488).withOpacity(0.15), const Color(0xFF0F766E).withOpacity(0.05)]
                  : [theme.primaryColor.withOpacity(0.06), theme.primaryColor.withOpacity(0.01)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: theme.primaryColor.withOpacity(0.2),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      appState.translate('projected_gpa').toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      projectedTermGpa.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 50, color: theme.primaryColor.withOpacity(0.15)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      appState.translate('gpa_target').toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      projectedCumulativeGpa.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Courses select sheet
        ..._currentCourses.map((course) {
          final code = course['code'] as String;
          final name = course['name'] as String;
          final credits = course['credits'] as int;
          final selectedLetter = _projectedGrades[code] ?? 'A';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$code • $credits Credits',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                
                // Dropdown container
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: selectedLetter,
                    underline: const SizedBox(),
                    dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: theme.primaryColor,
                    ),
                    icon: Icon(Icons.arrow_drop_down, color: theme.primaryColor),
                    items: _gradeOptions.map((letter) {
                      return DropdownMenuItem<String>(
                        value: letter,
                        child: Text(letter),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _projectedGrades[code] = val;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

// Custom Painter for GPA Line Chart
class _GpaTrendPainter extends CustomPainter {
  final List<double> gpaHistory;
  final List<String> labels;
  final bool isDark;
  final Color primaryColor;

  _GpaTrendPainter(this.gpaHistory, this.labels, this.isDark, this.primaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    if (gpaHistory.isEmpty) return;

    final paintLine = Paint()
      ..color = primaryColor
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintDot = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final paintDotBorder = Paint()
      ..color = isDark ? const Color(0xFF1E293B) : Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final paintFill = Paint()
      ..style = PaintingStyle.fill;

    final double widthBetween = size.width / (gpaHistory.length - 1);
    final Path path = Path();
    final Path fillPath = Path();

    // Map Y coordinates (GPA bounds 3.0 to 4.0)
    double getY(double gpa) {
      final normalized = (gpa - 3.0) / 1.0; // scale 0.0 to 1.0
      return size.height - (normalized * (size.height - 50) + 25);
    }

    path.moveTo(0, getY(gpaHistory[0]));
    fillPath.moveTo(0, size.height);
    fillPath.lineTo(0, getY(gpaHistory[0]));

    for (int i = 1; i < gpaHistory.length; i++) {
      final x = i * widthBetween;
      final y = getY(gpaHistory[i]);
      path.lineTo(x, y);
      fillPath.lineTo(x, y);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Draw background gradient fill
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    paintFill.shader = LinearGradient(
      colors: [primaryColor.withOpacity(0.25), primaryColor.withOpacity(0.01)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(rect);

    canvas.drawPath(fillPath, paintFill);
    canvas.drawPath(path, paintLine);

    // Draw dots & labels
    for (int i = 0; i < gpaHistory.length; i++) {
      final x = i * widthBetween;
      final y = getY(gpaHistory[i]);

      // Draw dot
      canvas.drawCircle(Offset(x, y), 6, paintDot);
      canvas.drawCircle(Offset(x, y), 6, paintDotBorder);

      // Draw text label below or above the dot
      final textPainter = TextPainter(
        text: TextSpan(
          text: gpaHistory[i].toStringAsFixed(2),
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1E293B),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - 22));

      // Draw term label at the bottom
      final labelPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      labelPainter.paint(canvas, Offset(x - labelPainter.width / 2, size.height - 15));
    }
  }

  @override
  bool shouldRepaint(covariant _GpaTrendPainter oldDelegate) => true;
}
