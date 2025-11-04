import 'package:flutter/material.dart';

/// Constants used throughout the Employee Management module
/// 
/// This file centralizes all colors, text styles, and other constants
/// to maintain consistency and make updates easier
class EmployeeManagementConstants {
  // Private constructor to prevent instantiation
  EmployeeManagementConstants._();

  // ==================== COLORS ====================
  
  /// Primary blue color used for buttons and accents
  static const Color primaryBlue = Color(0xFF4A90E2);
  
  /// Dark text color for headings and important text
  static const Color darkText = Color(0xFF2C3E50);
  
  /// Gray text color for secondary information
  static const Color grayText = Color(0xFF7F8C8D);
  
  /// Light gray text color for hints and disabled text
  static const Color lightGrayText = Color(0xFF95A5A6);
  
  /// Background color for cards and containers
  static const Color cardBackground = Colors.white;
  
  /// Light background color for input fields
  static const Color inputBackground = Color(0xFFF5F5F5);
  
  /// Border color for cards and dividers
  static const Color borderColor = Color(0xFFE0E0E0);
  
  /// Background color for table headers
  static const Color tableHeaderBackground = Color(0xFFF8F9FA);
  
  /// Light blue background for icons and badges
  static const Color lightBlueBackground = Color(0xFFE3F2FD);

  // ==================== STATUS COLORS ====================
  
  /// Color for active status badge
  static const Color activeStatusColor = Color(0xFF1976D2);
  
  /// Color for inactive status badge
  static const Color inactiveStatusColor = Color(0xFF95A5A6);

  // ==================== EMPLOYMENT TYPE COLORS ====================
  
  /// Full-time employment badge colors
  static const Color fullTimeBackground = Color(0xFFE3F2FD);
  static const Color fullTimeText = Color(0xFF1976D2);
  
  /// Part-time employment badge colors
  static const Color partTimeBackground = Color(0xFFFFF3E0);
  static const Color partTimeText = Color(0xFFF57C00);
  
  /// Intern employment badge colors
  static const Color internBackground = Color(0xFFF3E5F5);
  static const Color internText = Color(0xFF7B1FA2);
  
  /// On-site work model badge colors
  static const Color onSiteBackground = Color(0xFFE8F5E9);
  static const Color onSiteText = Color(0xFF388E3C);
  
  /// Hybrid work model badge colors
  static const Color hybridBackground = Color(0xFFFFF9C4);
  static const Color hybridText = Color(0xFFF57F17);

  // ==================== SPACING ====================
  
  /// Standard padding for containers
  static const double standardPadding = 20.0;
  
  /// Small spacing between elements
  static const double smallSpacing = 8.0;
  
  /// Medium spacing between elements
  static const double mediumSpacing = 16.0;
  
  /// Large spacing between sections
  static const double largeSpacing = 24.0;

  // ==================== BORDER RADIUS ====================
  
  /// Standard border radius for cards
  static const double cardBorderRadius = 12.0;
  
  /// Border radius for buttons
  static const double buttonBorderRadius = 8.0;
  
  /// Border radius for badges
  static const double badgeBorderRadius = 16.0;

  // ==================== TEXT STYLES ====================
  
  /// Style for page titles
  static const TextStyle pageTitleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: darkText,
  );
  
  /// Style for section headings
  static const TextStyle sectionHeadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: darkText,
  );
  
  /// Style for card titles
  static const TextStyle cardTitleStyle = TextStyle(
    fontSize: 14,
    color: grayText,
    fontWeight: FontWeight.w500,
  );
  
  /// Style for large numbers/values
  static const TextStyle largeValueStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: darkText,
  );
  
  /// Style for employee names
  static const TextStyle employeeNameStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: darkText,
  );
  
  /// Style for job titles
  static const TextStyle jobTitleStyle = TextStyle(
    fontSize: 12,
    color: grayText,
  );
  
  /// Style for table headers
  static const TextStyle tableHeaderStyle = TextStyle(
    fontWeight: FontWeight.w600,
    color: darkText,
  );
  
  /// Style for hint text
  static const TextStyle hintTextStyle = TextStyle(
    fontSize: 14,
    color: lightGrayText,
  );

  // ==================== SHADOW ====================
  
  /// Standard box shadow for cards
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];
}
