import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/student_list_table_widget.dart';
import 'widgets/student_form.dart';
import '../../model/student_model.dart';
import '../../providers/student_provider.dart';
import '../../providers/course_provider.dart';
/// Main Student Management Screen
///
/// This screen displays:
/// 1. A searchable and filterable list of all students
/// 2. Student details including course, progress, fee status
/// 3. Responsive design that adapts to different screen sizes
///
/// The screen is fully responsive:
/// - Mobile: Card-based layout
/// - Tablet: Scrollable table with adjusted spacing
/// - Desktop: Full table with all columns visible
class StudentManagement extends StatefulWidget {
  const StudentManagement({super.key});

  @override
  State<StudentManagement> createState() => _StudentManagementState();
}

class _StudentManagementState extends State<StudentManagement> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StudentProvider()..fetchStudents()),
        ChangeNotifierProvider(create: (_) => CourseProvider()..fetchCourses()),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<StudentProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.error != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    provider.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }

            final students = provider.filtered;

            return SingleChildScrollView(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 20 : 12),
              child: Column(
                children: [
                  StudentListTableWidget(
                    students: students.map((d) => StudentModel(
                      id: d.id,
                      name: d.fullname,
                      course: d.course,
                      duration: '',
                      progress: 0,
                      feeStatus: '',
                      lastLogin: '',
                    )).toList(),
                    onSearchChanged: (q) => provider.search(q),
                    onRegisterStudent: () => _showRegisterStudentForm(context),
                    onViewStudent: (student) {
                      final s = provider.getStudentById(student.id);
                      if (s != null) _showStudentDetails(s);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showRegisterStudentForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Register Student'),
        content: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: SizedBox(width: 500, child: StudentForm()),
        ),
      ),
    );
  }

  void _showStudentDetails(Datum s) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.fullname),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('ID', s.id),
              _detailRow('Email', s.email),
              _detailRow('Phone', s.contactNumber),
              _detailRow('Guardian', s.guardian),
              _detailRow('Guardian Number', s.guardianNumber),
              _detailRow('Course', s.course),
              _detailRow('Joining Date', s.joiningDate.toIso8601String()),
              _detailRow('Emergency Contact', s.emergencyContactName),
              _detailRow('Emergency Number', s.emergencyNumber),
              _detailRow('Relationship', s.relationship),
              _detailRow('Address', s.address),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text('$label:')),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
