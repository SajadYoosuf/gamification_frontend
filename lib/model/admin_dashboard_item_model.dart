import 'package:flutter/material.dart';

/// Model class representing a dashboard item/card
/// 
/// This class is designed for reusability and can be used to create
/// various dashboard cards with different data
class DashboardItemModel {
  /// Title of the dashboard item
  final String title;
  
  /// Subtitle or description
  final String subtitle;
  
  /// Main value to display (e.g., "70.05%", "90.15%")
  final String value;
  
  /// Icon to display
  final IconData icon;
  
  /// Background color for the icon
  final Color iconBackgroundColor;
  
  /// Icon color
  final Color iconColor;
  
  /// Trend text (e.g., "8.5%", "10.0%")
  final String? trendText;
  
  /// Trend icon (up/down arrow)
  final IconData? trendIcon;
  
  /// Trend color (green for up, red for down)
  final Color? trendColor;
  
  /// Action text (e.g., "Tap more info")
  final String? actionText;
  
  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Creates a DashboardItemModel instance
  DashboardItemModel({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    this.trendText,
    this.trendIcon,
    this.trendColor,
    this.actionText,
    this.onTap,
  });

  /// Creates a DashboardItemModel from a Map
  /// 
  /// This is useful for creating dashboard items from JSON or dynamic data
  /// 
  /// Example:
  /// ```dart
  /// final item = DashboardItemModel.fromMap({
  ///   'title': 'Weekly Student',
  ///   'subtitle': 'attendance graph',
  ///   'value': '70.05%',
  ///   'icon': 'people',
  ///   'iconBackgroundColor': '#E3F2FD',
  ///   'iconColor': '#1976D2',
  ///   'trendText': '8.5%',
  ///   'trendIcon': 'up',
  ///   'trendColor': '#4CAF50',
  ///   'actionText': 'Tap more info',
  /// });
  /// ```
  factory DashboardItemModel.fromMap(Map<String, dynamic> map) {
    return DashboardItemModel(
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
      value: map['value'] as String,
      icon: _parseIcon(map['icon'] as String),
      iconBackgroundColor: _parseColor(map['iconBackgroundColor'] as String),
      iconColor: _parseColor(map['iconColor'] as String),
      trendText: map['trendText'] as String?,
      trendIcon: map['trendIcon'] != null 
          ? _parseTrendIcon(map['trendIcon'] as String)
          : null,
      trendColor: map['trendColor'] != null
          ? _parseColor(map['trendColor'] as String)
          : null,
      actionText: map['actionText'] as String?,
    );
  }

  /// Converts the model to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'value': value,
      'icon': icon.codePoint.toString(),
      'iconBackgroundColor': '#${iconBackgroundColor.value.toRadixString(16).substring(2)}',
      'iconColor': '#${iconColor.value.toRadixString(16).substring(2)}',
      'trendText': trendText,
      'trendIcon': trendIcon?.codePoint.toString(),
      'trendColor': trendColor != null 
          ? '#${trendColor!.value.toRadixString(16).substring(2)}'
          : null,
      'actionText': actionText,
    };
  }

  /// Helper method to parse icon from string
  static IconData _parseIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'people':
      case 'group':
        return Icons.people;
      case 'person':
        return Icons.person;
      case 'school':
        return Icons.school;
      case 'work':
      case 'badge':
        return Icons.badge;
      case 'calendar':
      case 'event':
        return Icons.event;
      case 'book':
        return Icons.menu_book;
      case 'chart':
      case 'analytics':
        return Icons.analytics;
      case 'computer':
      case 'desktop':
        return Icons.computer;
      case 'assignment':
        return Icons.assignment;
      default:
        return Icons.dashboard;
    }
  }

  /// Helper method to parse trend icon from string
  static IconData _parseTrendIcon(String trendType) {
    switch (trendType.toLowerCase()) {
      case 'up':
      case 'trending_up':
        return Icons.trending_up;
      case 'down':
      case 'trending_down':
        return Icons.trending_down;
      case 'flat':
      case 'trending_flat':
        return Icons.trending_flat;
      default:
        return Icons.trending_up;
    }
  }

  /// Helper method to parse color from hex string
  static Color _parseColor(String hexColor) {
    // Remove # if present
    hexColor = hexColor.replaceAll('#', '');
    
    // Add FF for alpha if not present
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    
    return Color(int.parse(hexColor, radix: 16));
  }

  /// Creates a copy with some fields replaced
  DashboardItemModel copyWith({
    String? title,
    String? subtitle,
    String? value,
    IconData? icon,
    Color? iconBackgroundColor,
    Color? iconColor,
    String? trendText,
    IconData? trendIcon,
    Color? trendColor,
    String? actionText,
    VoidCallback? onTap,
  }) {
    return DashboardItemModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      value: value ?? this.value,
      icon: icon ?? this.icon,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      iconColor: iconColor ?? this.iconColor,
      trendText: trendText ?? this.trendText,
      trendIcon: trendIcon ?? this.trendIcon,
      trendColor: trendColor ?? this.trendColor,
      actionText: actionText ?? this.actionText,
      onTap: onTap ?? this.onTap,
    );
  }
}
