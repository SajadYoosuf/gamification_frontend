import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/student_model.dart';
import '../../../providers/course_provider.dart';
import '../../../providers/student_provider.dart';

/// A responsive table widget that displays a list of students with their details
/// 
/// Features:
/// - Responsive design (adapts to screen size)
/// - Search functionality
/// - Filter by course and fee status
/// - Progress bars
/// - Color-coded fee status badges
/// - Action buttons for each row
class StudentListTableWidget extends StatefulWidget {
  /// List of students to display in the table
  final List<StudentModel> students;

  /// Callback when search text changes
  final Function(String)? onSearchChanged;

  /// Callback when "Register Student" button is pressed
  final VoidCallback? onRegisterStudent;

  /// Callback when view/action button is pressed for a student
  final Function(StudentModel)? onViewStudent;

  const StudentListTableWidget({
    super.key,
    required this.students,
    this.onSearchChanged,
    this.onRegisterStudent,
    this.onViewStudent,
  });

  @override
  State<StudentListTableWidget> createState() =>
      _StudentListTableWidgetState();
}

class _StudentListTableWidgetState extends State<StudentListTableWidget> {
  /// Controller for the search text field
  final TextEditingController _searchController = TextEditingController();

  /// Selected course filter
  String _selectedCourse = 'All Courses';

  /// (fee status is upcoming — no interactive filter yet)

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;
    final isTablet = screenWidth > 600 && screenWidth <= 1200;
    final isMobile = screenWidth <= 600;

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section with title and filters
          _buildHeader(isMobile, isTablet),
          SizedBox(height: isMobile ? 16 : 20),

          // Table section
          _buildTable(isMobile, isTablet, isDesktop),
        ],
      ),
    );
  }

  /// Builds the header section with title, search, filters, and register button
  Widget _buildHeader(bool isMobile, bool isTablet) {
    if (isMobile) {
      // Mobile layout: Stack vertically
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Student Management',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Manage and track all enrolled students',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF7F8C8D),
            ),
          ),
          const SizedBox(height: 16),
          _buildSearchBar(true),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildCourseFilter()),
              const SizedBox(width: 8),
              Expanded(child: _buildFeeStatusFilter()),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: _buildRegisterButton(),
          ),
        ],
      );
    }

    // Tablet and Desktop layout
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Student Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Manage and track all enrolled students',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
              ],
            ),

            // Register button
            _buildRegisterButton(),
          ],
        ),
        const SizedBox(height: 20),

        // Search and filters row
        Row(
          children: [
            Expanded(child: _buildSearchBar(false)),
            const SizedBox(width: 12),
            Expanded(child: _buildCourseFilter()),
            Expanded(child: _buildFeeStatusFilter()),
          ],
        ),
      ],
    );
  }

  /// Builds the search bar
  Widget _buildSearchBar(bool isMobile) {
    return Container(
      height: 45,
      constraints: BoxConstraints(
        maxWidth: isMobile ? double.infinity : 350,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: widget.onSearchChanged,
        decoration: const InputDecoration(
          hintText: 'Search students...',
          hintStyle: TextStyle(fontSize: 14, color: Color(0xFF95A5A6)),
          prefixIcon: Icon(Icons.search, color: Color(0xFF95A5A6), size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  /// Builds the course filter dropdown
  Widget _buildCourseFilter() {
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, _) {
        // Trigger fetch if empty and not loading
        if (!courseProvider.isLoading && courseProvider.courses.isEmpty) {
          Future.microtask(() => courseProvider.fetchCourses());

          // While fetch is scheduled/shallow state, show a clear "no data" placeholder
          // which will be replaced by a spinner once loading starts.
          return Container(
            height: 45,
            
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: const Text(
              'No courses available',
              style: TextStyle(fontSize: 14, color: Color(0xFF7F8C8D)),
            ),
          );
        }

        if (courseProvider.isLoading) {
          return Container(
            height: 45,
            alignment: Alignment.center,
            child: const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        final courseNames = <String>['All Courses'];
        courseNames.addAll(courseProvider.courses.map((c) => c.courseName));

        return Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: _selectedCourse,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF95A5A6)),
            items: courseNames.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF2C3E50)),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue == null) return;
              setState(() {
                _selectedCourse = newValue;
              });

              // Notify the StudentProvider to filter by the selected course
              final studentProv = Provider.of<StudentProvider>(context, listen: false);
              final selected = _selectedCourse == 'All Courses' ? null : _selectedCourse;
              studentProv.filterByCourse(selected);
            },
          ),
        );
      },
    );
  }

  /// Builds the fee status filter dropdown
  Widget _buildFeeStatusFilter() {
    // Fee status is an upcoming feature; show as non-clickable label
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: const Text(
        'Fee Status (upcoming)',
        style: TextStyle(fontSize: 14, color: Color(0xFF2C3E50)),
      ),
    );
  }

  /// Builds the register student button
  Widget _buildRegisterButton() {
    return ElevatedButton.icon(
      onPressed: widget.onRegisterStudent,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4A90E2),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
      icon: const Icon(Icons.add, size: 20),
      label: const Text(
        'Register Student',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Builds the data table with student information
  Widget _buildTable(bool isMobile, bool isTablet, bool isDesktop) {
    if (isMobile) {
      // Mobile: Use card layout instead of table
      return _buildMobileCardList();
    }

    // Tablet and Desktop: Use scrollable table
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width - 80,
        ),
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(const Color(0xFFF8F9FA)),
          columnSpacing: isTablet ? 20 : 40,
          horizontalMargin: 0,
          dataRowHeight: 70,
          columns: const [
            DataColumn(
              label: Text(
                'Student',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
              DataColumn(
                label: Text(
                  'Course',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Progress',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ),
            DataColumn(
              label: Text(
                'Fee Status',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Actions',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
          ],
          rows: widget.students.map((student) {
            return DataRow(
              cells: [
                // Student name cell with avatar
                DataCell(_buildStudentCell(student)),

                // Course cell with badge
                DataCell(_buildCourseBadge(student.course)),

                // Progress cell (API doesn't provide progress yet)
                DataCell(Text('Upcoming feature', style: const TextStyle(fontSize: 14, color: Color(0xFF2C3E50)))),

                // Fee Status (upcoming feature)
                DataCell(Text('Upcoming feature', style: const TextStyle(fontSize: 14, color: Color(0xFF2C3E50)))),

                // Actions cell
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Color(0xFF4A90E2)),
                    onPressed: () => widget.onViewStudent?.call(student),
                    tooltip: 'View Details',
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Builds mobile card list layout
  Widget _buildMobileCardList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.students.length,
      itemBuilder: (context, index) {
        final student = widget.students[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student info row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFFE3F2FD),
                      backgroundImage: student.imageUrl != null
                          ? NetworkImage(student.imageUrl!)
                          : null,
                      child: student.imageUrl == null
                            ? Text(
                                _getInitials(student.name),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF4A90E2),
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.name ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.visibility, color: Color(0xFF4A90E2)),
                      onPressed: () => widget.onViewStudent?.call(student),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Course
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Course',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7F8C8D),
                            ),
                          ),
                          const SizedBox(height: 4),
                          _buildCourseBadge(student.course),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Progress (not available via API yet)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Progress',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7F8C8D),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text('Upcoming feature', style: TextStyle(fontSize: 14, color: Color(0xFF2C3E50), fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),

                // Fee status and last login
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Fee Status (upcoming feature) — Last Login removed per requirements
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Fee Status',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7F8C8D),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('Upcoming feature', style: TextStyle(fontSize: 14, color: Color(0xFF2C3E50), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds student cell with avatar and name
  Widget _buildStudentCell(StudentModel student) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFFE3F2FD),
          backgroundImage:
              student.imageUrl != null ? NetworkImage(student.imageUrl!) : null,
          child: student.imageUrl == null
              ? Text(
                  _getInitials(student.name),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A90E2),
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              student.name ?? 'Unknown',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
            // ID removed from the compact cell as per requirements
          ],
        ),
      ],
    );
  }

  /// Builds course badge
  Widget _buildCourseBadge(String course) {
    Color backgroundColor;
    Color textColor;

    switch (course.toLowerCase()) {
      case 'advanced math':
        backgroundColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1976D2);
        break;
      case 'physics pro':
        backgroundColor = const Color(0xFFF3E5F5);
        textColor = const Color(0xFF7B1FA2);
        break;
      case 'chemistry':
        backgroundColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF388E3C);
        break;
      default:
        backgroundColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFF57C00);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 160),
        child: Text(
          course,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  // Progress feature is currently a placeholder; UI shows "Upcoming feature" elsewhere.

  // Fee status UI is currently an upcoming feature; badge helper removed.

  /// Extracts initials from student name (null-safe)
  String _getInitials(String? name) {
    final safe = (name ?? '').trim();
    if (safe.isEmpty) return '';
    final nameParts = safe.split(RegExp(r'\s+'));
    if (nameParts.isEmpty) return '';
    if (nameParts.length == 1) {
      return nameParts[0].substring(0, 1).toUpperCase();
    }
    return '${nameParts[0].substring(0, 1)}${nameParts[1].substring(0, 1)}'
        .toUpperCase();
  }
}
