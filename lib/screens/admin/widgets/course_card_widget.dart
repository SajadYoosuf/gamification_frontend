import 'package:flutter/material.dart';
import '../../../model/course_model.dart';

class CourseCardWidget extends StatelessWidget {
  final Course course;
  final VoidCallback? onTap;

  const CourseCardWidget({super.key, required this.course, this.onTap});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return SizedBox(
      width: double.infinity, // ✅ ensures measurable area
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(isMobile ? 14 : 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.courseName,
                style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2C3E50)),
              ),
              const SizedBox(height: 8),
              Text(
                course.discription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isMobile ? 13 : 14,
                  color: const Color(0xFF7F8C8D),
                  height: 1.4,
                ),
              ),
              const Spacer(),
              const Divider(color: Color(0xFFE0E0E0)),
              const SizedBox(height: 8),
              _detailRow('Duration', course.duration, isMobile),
              const SizedBox(height: 6),
              _detailRow('Mentor', course.assignedMentor, isMobile),
              const SizedBox(height: 6),
              _detailRow('Fee', '\$${course.fee}', isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: isMobile ? 13 : 14, color: const Color(0xFF7F8C8D))),
        Text(value,
            style: TextStyle(
                fontSize: isMobile ? 13 : 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2C3E50))),
      ],
    );
  }
}
