// lib/dashboard_views.dart

import 'package:flutter/material.dart';
import 'widgets/dashboard_card_widget.dart';
import '../../model/admin_dashboard_item_model.dart';
import '../../data/admin_dashboard_data.dart';

/// Dashboard Screen with responsive grid layout
///
/// Displays dashboard metrics in a responsive grid that adapts to:
/// - Mobile: 1 column
/// - Tablet: 2 columns
/// - Desktop: 3 columns
class DashboardScreen extends StatefulWidget {
  final String role;
  final String screenTitle;

  const DashboardScreen({
    super.key,
    required this.role,
    required this.screenTitle,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  /// List of dashboard items
  late List<DashboardItemModel> _dashboardItems;

  @override
  void initState() {
    super.initState();
    _initializeDashboardItems();
  }

  /// Initializes dashboard items with data from DashboardData provider
  /// Data is now separated from UI logic
  void _initializeDashboardItems() {
    // Get dashboard items based on role
    // Data is now managed in the DashboardData class
    switch (widget.role.toLowerCase()) {
      case 'admin':
        _dashboardItems = DashboardData.getAdminDashboardItems(
          onWeeklyStudentTap: () => _handleCardTap('Weekly Student Attendance'),
          onTotalStudentsTap: () => _handleCardTap('Total Students'),
          onTotalEmployeesTap: () => _handleCardTap('Total Employees'),
          onCoursesOverviewTap: () => _handleCardTap('Courses Overview'),
          onTodayStudentAttendanceTap: () =>
              _handleCardTap('Today Student Attendance'),
          onTodayEmployeeAttendanceTap: () =>
              _handleCardTap('Today Employee Attendance'),
          onTodayStudentLeaveTap: () => _handleCardTap('Today Student Leave'),
          onTodayEmployeeLeaveTap: () => _handleCardTap('Today Employee Leave'),
        );
        break;
      case 'student':
        _dashboardItems = DashboardData.getStudentDashboardItems(
          onMyAttendanceTap: () => _handleCardTap('My Attendance'),
          onMyCoursesToap: () => _handleCardTap('My Courses'),
          onMyProgressTap: () => _handleCardTap('My Progress'),
          onUpcomingClassesTap: () => _handleCardTap('Upcoming Classes'),
        );
        break;
      case 'employee':
        _dashboardItems = DashboardData.getEmployeeDashboardItems(
          onMyAttendanceTap: () => _handleCardTap('My Attendance'),
          onMyClassesToap: () => _handleCardTap('My Classes'),
          onStudentsAssignedTap: () => _handleCardTap('Students Assigned'),
          onPendingTasksTap: () => _handleCardTap('Pending Tasks'),
        );
        break;
      default:
        _dashboardItems = [];
    }
  }

  /// Handles card tap
  void _handleCardTap(String cardName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tapped on: $cardName'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF4A90E2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    final isTablet = screenWidth > 600 && screenWidth <= 1024;

    // Determine grid columns based on screen size
    int crossAxisCount;
    double childAspectRatio;

    if (isMobile) {
      crossAxisCount = 1;
      childAspectRatio = 2.5;
    } else if (isTablet) {
      crossAxisCount = 2;
      childAspectRatio = 2.2;
    } else {
      crossAxisCount = 3;
      childAspectRatio = 2.0;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 12 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: isMobile ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C3E50),
                ),
              ),
            ),

            // Dashboard grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: isMobile ? 12 : 16,
                mainAxisSpacing: isMobile ? 12 : 16,
                childAspectRatio: childAspectRatio,
              ),
              itemCount: _dashboardItems.length,
              itemBuilder: (context, index) {
                return DashboardCardWidget(item: _dashboardItems[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
