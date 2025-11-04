import 'package:flutter/material.dart';
import '../../../model/admin_dashboard_item_model.dart';

/// A reusable dashboard card widget
///
/// Displays dashboard metrics with icon, title, value, and trend
/// Fully responsive and adapts to different screen sizes
class DashboardCardWidget extends StatelessWidget {
  /// The dashboard item data to display
  final DashboardItemModel item;

  const DashboardCardWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top row: Title and Icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2C3E50),
                        ),
                      ),
                      if (item.subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle,
                          style: TextStyle(
                            fontSize: isMobile ? 10 : 11,
                            color: const Color(0xFF95A5A6),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Icon
                Container(
                  width: isMobile ? 40 : 48,
                  height: isMobile ? 40 : 48,
                  decoration: BoxDecoration(
                    color: item.iconBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.iconColor,
                    size: isMobile ? 20 : 24,
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 12 : 16),

            // Value
            Text(
              item.value,
              style: TextStyle(
                fontSize: isMobile ? 24 : 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2C3E50),
              ),
            ),
            SizedBox(height: isMobile ? 8 : 12),

            // Bottom row: Trend and Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Trend indicator
                if (item.trendText != null && item.trendIcon != null)
                  Row(
                    children: [
                      Icon(
                        item.trendIcon,
                        size: isMobile ? 14 : 16,
                        color: item.trendColor ?? const Color(0xFF4CAF50),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.trendText!,
                        style: TextStyle(
                          fontSize: isMobile ? 11 : 12,
                          fontWeight: FontWeight.w600,
                          color: item.trendColor ?? const Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  )
                else
                  const SizedBox(),

                // Action text
                if (item.actionText != null)
                  Text(
                    item.actionText!,
                    style: TextStyle(
                      fontSize: isMobile ? 10 : 11,
                      color: const Color(0xFF4A90E2),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
