// lib/dashboard_routes.dart
import 'package:flutter/material.dart';

/// A class to hold the properties for a single navigation destination.
class NavDestination {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String routeName; // Optional: for named routing later

  const NavDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.routeName = '',
  });

  /// A helper function to convert this object into a NavigationRailDestination.
  NavigationRailDestination toNavigationRailDestination() {
    return NavigationRailDestination(
      label: Text(label),
      icon: Icon(icon),
      selectedIcon: Icon(selectedIcon),
    );
  }
}

/// A centralized place for all role-based navigation routes.
class DashboardRoutes {
  // --- Admin Routes ---
  static const List<NavDestination> admin = [
    NavDestination(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      routeName: '/admin/dashboard',
    ),
    NavDestination(
      label: 'student Management',
      icon: Icons.group_outlined,
      selectedIcon: Icons.school,
      routeName: '/admin/users',
    ),
    NavDestination(
      label: 'Employee Management',
      icon: Icons.badge_outlined,
      selectedIcon: Icons.badge,
      routeName: '/admin/employees',
    ),

    NavDestination(
      label: 'Attendance Management',
      icon: Icons.edit_calendar,
      selectedIcon: Icons.edit_square,
      routeName: '/admin/attendance',
    ),
    NavDestination(
      label: 'Course Management',
      icon: Icons.book,
      selectedIcon: Icons.play_lesson,
      routeName: '/admin/course_management',
    ),
  ];

  // --- Student Routes ---
  static const List<NavDestination> student = [
    NavDestination(
      label: 'Dashboard',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      routeName: '/student/dashboard',
    ),
    NavDestination(
      label: 'Checkin & Checkout',
      icon: Icons.book_outlined,
      selectedIcon: Icons.book,
      routeName: '/student/checkin_checkout',
    ),
  ];

  // --- Employee Routes ---
  static const List<NavDestination> employee = [
    NavDestination(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      routeName: '/employee/dashboard',
    ),

    NavDestination(
      label: 'Checkin & Checkout',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      routeName: '/employee/checkin_checkout',
    ),
  ];
}
