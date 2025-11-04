import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:novox_edtech_gamification/model/course_model.dart';
import 'package:novox_edtech_gamification/providers/course_provider.dart';
import 'widgets/course_card_widget.dart';
import 'widgets/course_statistics_card.dart';
import 'widgets/course_form.dart';

class CourseManagement extends StatefulWidget {
  const CourseManagement({super.key});

  @override
  State<CourseManagement> createState() => _CourseManagementState();
}

class _CourseManagementState extends State<CourseManagement> {
  List<Course> _courses = [];
  bool _isLoading = true;
  String? _error;

  int _totalCourses = 0;
  int _activeStudents = 0;
  double _avgCompletion = 0.0;
  double _totalRevenue = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      final provider = Provider.of<CourseProvider>(context, listen: false);
      await provider.fetchCourses();
      setState(() {
        _courses = provider.courses;
        _isLoading = false;
        _calculateStats();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load courses';
      });
    }
  }

  void _calculateStats() {
    _totalCourses = _courses.length;
    _activeStudents = _totalCourses * 15;
    _avgCompletion = 75.0;
    _totalRevenue = _courses.fold(0.0, (sum, c) {
      final fee = double.tryParse(c.fee) ?? 0;
      return sum + fee * 15;
    });
  }

  void _handleAddCourse() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Course'),
        content: SizedBox(width: 500, child: CourseForm()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;
    final isTablet = width >= 700 && width < 1100;

    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(_error!));

    int crossAxisCount = isMobile ? 1 : isTablet ? 2 : 3;

    return Scaffold(
      backgroundColor: Colors.white,
      // Show floating Add button on mobile since header Add button is hidden there
      floatingActionButton: isMobile
          ? FloatingActionButton(
              onPressed: _handleAddCourse,
              backgroundColor: const Color(0xFF4A90E2),
              child: const Icon(Icons.add),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 12 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isMobile),
              SizedBox(height: isMobile ? 16 : 24),
              _buildStats(isMobile, isTablet),
              SizedBox(height: isMobile ? 20 : 32),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _courses.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: isMobile ? 12 : 20,
                  crossAxisSpacing: isMobile ? 12 : 20,
                  childAspectRatio: isMobile ? 1.05 : 0.85,
                ),
                itemBuilder: (_, i) => CourseCardWidget(
                  course: _courses[i],
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening ${_courses[i].courseName}...'),
                      duration: const Duration(seconds: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      mainAxisAlignment:
          isMobile ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Course Management',
                style: TextStyle(
                    fontSize: isMobile ? 20 : 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2C3E50))),
            const SizedBox(height: 4),
            const Text(
              'Create and manage educational courses',
              style: TextStyle(fontSize: 14, color: Color(0xFF7F8C8D)),
            ),
          ],
        ),
        if (!isMobile)
          ElevatedButton.icon(
            onPressed: _handleAddCourse,
            icon: const Icon(Icons.add),
            label: const Text('Add Course'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildStats(bool isMobile, bool isTablet) {
    final stats = [
      ('Total Courses', _totalCourses.toString(), Icons.menu_book,
          Color(0xFFE3F2FD), Color(0xFF1976D2)),
      ('Active Students', _activeStudents.toString(), Icons.people,
          Color(0xFFE8F5E9), Color(0xFF4CAF50)),
      ('Avg. Completion', '$_avgCompletion%', Icons.bar_chart,
          Color(0xFFFFF3E0), Color(0xFFFFA726)),
      ('Total Revenue', '\$${_totalRevenue.toStringAsFixed(0)}',
          Icons.attach_money, Color(0xFFF3E5F5), Color(0xFF7B1FA2)),
    ];

    if (isMobile) {
      return Column(
        children: stats
            .map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CourseStatisticsCard(
                    title: s.$1,
                    value: s.$2,
                    icon: s.$3,
                    iconBackgroundColor: s.$4,
                    iconColor: s.$5,
                  ),
                ))
            .toList(),
      );
    }

    return GridView.count(
      crossAxisCount: isTablet ? 2 : 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 3,
      children: stats
          .map((s) => CourseStatisticsCard(
                title: s.$1,
                value: s.$2,
                icon: s.$3,
                iconBackgroundColor: s.$4,
                iconColor: s.$5,
              ))
          .toList(),
    );
  }
}
