import 'package:flutter/material.dart';
import '../model/admin_dashboard_item_model.dart';

/// Dashboard Data Provider
///
/// This class provides dashboard data separated from the UI
/// In a production app, this would fetch data from an API
class DashboardData {
  /// Returns dashboard items for Admin role
  static List<DashboardItemModel> getAdminDashboardItems({
    VoidCallback? onWeeklyStudentTap,
    VoidCallback? onTotalStudentsTap,
    VoidCallback? onTotalEmployeesTap,
    VoidCallback? onCoursesOverviewTap,
    VoidCallback? onTodayStudentAttendanceTap,
    VoidCallback? onTodayEmployeeAttendanceTap,
    VoidCallback? onTodayStudentLeaveTap,
    VoidCallback? onTodayEmployeeLeaveTap,
  }) {
    return [
      // Row 1 - Metrics with values
      DashboardItemModel(
        title: 'Weekly Student',
        subtitle: 'attendance graph',
        value: '70.05%',
        icon: Icons.people,
        iconBackgroundColor: const Color(0xFFE3F2FD),
        iconColor: const Color(0xFF1976D2),
        trendText: '8.5%',
        trendIcon: Icons.trending_up,
        trendColor: const Color(0xFF4CAF50),
        actionText: 'Tap more info',
        onTap: onWeeklyStudentTap,
      ),
      DashboardItemModel(
        title: 'Total',
        subtitle: 'students count',
        value: '90.15%',
        icon: Icons.school,
        iconBackgroundColor: const Color(0xFFE3F2FD),
        iconColor: const Color(0xFF1976D2),
        trendText: '10.0%',
        trendIcon: Icons.trending_up,
        trendColor: const Color(0xFF4CAF50),
        actionText: 'Tap more info',
        onTap: onTotalStudentsTap,
      ),
      DashboardItemModel(
        title: 'Total',
        subtitle: 'employs',
        value: '95.05%',
        icon: Icons.badge,
        iconBackgroundColor: const Color(0xFFE3F2FD),
        iconColor: const Color(0xFF1976D2),
        trendText: '65.0%',
        trendIcon: Icons.trending_up,
        trendColor: const Color(0xFF4CAF50),
        actionText: 'Tap more info',
        onTap: onTotalEmployeesTap,
      ),

      // Row 2 - Quick access
      DashboardItemModel(
        title: 'Courses',
        subtitle: 'overview',
        value: '',
        icon: Icons.menu_book,
        iconBackgroundColor: const Color(0xFFE3F2FD),
        iconColor: const Color(0xFF1976D2),
        actionText: 'Tap more info',
        onTap: onCoursesOverviewTap,
      ),
      DashboardItemModel(
        title: 'Today',
        subtitle: 'Student Attendants',
        value: '',
        icon: Icons.people,
        iconBackgroundColor: const Color(0xFFE3F2FD),
        iconColor: const Color(0xFF1976D2),
        actionText: 'Tap more info',
        onTap: onTodayStudentAttendanceTap,
      ),
      DashboardItemModel(
        title: 'Today',
        subtitle: 'employ attendans',
        value: '',
        icon: Icons.computer,
        iconBackgroundColor: const Color(0xFFE3F2FD),
        iconColor: const Color(0xFF1976D2),
        actionText: 'Tap more info',
        onTap: onTodayEmployeeAttendanceTap,
      ),

      // Row 3 - Leave tracking
      DashboardItemModel(
        title: 'Today',
        subtitle: 'student leave',
        value: '',
        icon: Icons.event,
        iconBackgroundColor: const Color(0xFFE3F2FD),
        iconColor: const Color(0xFF1976D2),
        actionText: 'Tap more info',
        onTap: onTodayStudentLeaveTap,
      ),
      DashboardItemModel(
        title: 'Today',
        subtitle: 'employee leave',
        value: '',
        icon: Icons.assignment,
        iconBackgroundColor: const Color(0xFFE3F2FD),
        iconColor: const Color(0xFF1976D2),
        actionText: 'Tap more info',
        onTap: onTodayEmployeeLeaveTap,
      ),
    ];
  }

  /// Returns dashboard items for Student role
  static List<DashboardItemModel> getStudentDashboardItems({
    VoidCallback? onMyAttendanceTap,
    VoidCallback? onMyCoursesToap,
    VoidCallback? onMyProgressTap,
    VoidCallback? onUpcomingClassesTap,
  }) {
    return [
      DashboardItemModel(
        title: 'My Attendance',
        subtitle: 'this month',
        value: '85.5%',
        icon: Icons.check_circle,
        iconBackgroundColor: const Color(0xFFE8F5E9),
        iconColor: const Color(0xFF4CAF50),
        trendText: '5.0%',
        trendIcon: Icons.trending_up,
        trendColor: const Color(0xFF4CAF50),
        actionText: 'View details',
        onTap: onMyAttendanceTap,
      ),
      DashboardItemModel(
        title: 'My Courses',
        subtitle: 'enrolled',
        value: '5',
        icon: Icons.school,
        iconBackgroundColor: const Color(0xFFE3F2FD),
        iconColor: const Color(0xFF1976D2),
        actionText: 'View all',
        onTap: onMyCoursesToap,
      ),
      DashboardItemModel(
        title: 'Overall Progress',
        subtitle: 'completion',
        value: '67%',
        icon: Icons.trending_up,
        iconBackgroundColor: const Color(0xFFFFF3E0),
        iconColor: const Color(0xFFFFA726),
        trendText: '12%',
        trendIcon: Icons.trending_up,
        trendColor: const Color(0xFF4CAF50),
        actionText: 'View details',
        onTap: onMyProgressTap,
      ),
      DashboardItemModel(
        title: 'Upcoming Classes',
        subtitle: 'today',
        value: '3',
        icon: Icons.calendar_today,
        iconBackgroundColor: const Color(0xFFF3E5F5),
        iconColor: const Color(0xFF7B1FA2),
        actionText: 'View schedule',
        onTap: onUpcomingClassesTap,
      ),
    ];
  }

  /// Returns dashboard items for Employee role
  static List<DashboardItemModel> getEmployeeDashboardItems({
    VoidCallback? onMyAttendanceTap,
    VoidCallback? onMyClassesToap,
    VoidCallback? onStudentsAssignedTap,
    VoidCallback? onPendingTasksTap,
  }) {
    return [
      DashboardItemModel(
        title: 'My Attendance',
        subtitle: 'this month',
        value: '95.5%',
        icon: Icons.check_circle,
        iconBackgroundColor: const Color(0xFFE8F5E9),
        iconColor: const Color(0xFF4CAF50),
        trendText: '2.5%',
        trendIcon: Icons.trending_up,
        trendColor: const Color(0xFF4CAF50),
        actionText: 'View details',
        onTap: onMyAttendanceTap,
      ),
      DashboardItemModel(
        title: 'My Classes',
        subtitle: 'assigned',
        value: '8',
        icon: Icons.class_,
        iconBackgroundColor: const Color(0xFFE3F2FD),
        iconColor: const Color(0xFF1976D2),
        actionText: 'View all',
        onTap: onMyClassesToap,
      ),
      DashboardItemModel(
        title: 'Students Assigned',
        subtitle: 'total',
        value: '125',
        icon: Icons.people,
        iconBackgroundColor: const Color(0xFFFFF3E0),
        iconColor: const Color(0xFFFFA726),
        actionText: 'View list',
        onTap: onStudentsAssignedTap,
      ),
      DashboardItemModel(
        title: 'Pending Tasks',
        subtitle: 'to complete',
        value: '7',
        icon: Icons.assignment,
        iconBackgroundColor: const Color(0xFFFFEBEE),
        iconColor: const Color(0xFFEF5350),
        actionText: 'View tasks',
        onTap: onPendingTasksTap,
      ),
    ];
  }

  /// Returns dashboard items from API (example)
  ///
  /// In a production app, this would make an HTTP request
  static Future<List<DashboardItemModel>> fetchDashboardItems(
    String role,
  ) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return data based on role
    switch (role.toLowerCase()) {
      case 'admin':
        return getAdminDashboardItems();
      case 'student':
        return getStudentDashboardItems();
      case 'employee':
        return getEmployeeDashboardItems();
      default:
        return [];
    }
  }

  /// Returns dashboard items from Map (for API integration)
  ///
  /// Example API response:
  /// ```json
  /// [
  ///   {
  ///     "title": "Weekly Student",
  ///     "subtitle": "attendance graph",
  ///     "value": "70.05%",
  ///     "icon": "people",
  ///     "iconBackgroundColor": "#E3F2FD",
  ///     "iconColor": "#1976D2",
  ///     "trendText": "8.5%",
  ///     "trendIcon": "up",
  ///     "trendColor": "#4CAF50",
  ///     "actionText": "Tap more info"
  ///   }
  /// ]
  /// ```
  static List<DashboardItemModel> fromMapList(List<Map<String, dynamic>> data) {
    return data.map((item) => DashboardItemModel.fromMap(item)).toList();
  }
}
