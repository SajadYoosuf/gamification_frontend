import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/attendance_table_widget.dart';
import '../../model/attendance_model.dart';
import '../../providers/attendance_provider.dart';

/// Main Attendance Management Screen
///
/// This screen displays:
/// 1. Toggle between Students and Employees attendance
/// 2. Filters for date, month, and status
/// 3. Attendance records table with check-in/check-out times
/// 4. Export functionality for reports
///
/// The screen is fully responsive:
/// - Mobile: Card-based layout with stacked filters
/// - Tablet: Scrollable table with adjusted spacing
/// - Desktop: Full table with all columns visible
class AttendanceManagement extends StatefulWidget {
  const AttendanceManagement({super.key});

  @override
  State<AttendanceManagement> createState() => _AttendanceManagementState();
}

class _AttendanceManagementState extends State<AttendanceManagement> {
  /// Currently selected attendance type (student or employee)
  AttendanceType _selectedType = AttendanceType.student;

  /// List of all attendance records (in a real app, this would come from a database/API)
  late List<AttendanceModel> _allRecords = [];

  /// Filtered list of attendance records
  late List<AttendanceModel> _filteredRecords = [];

  @override
  void initState() {
    super.initState();
    // initial filtered list is empty; we'll load student data from provider when needed
    _filteredRecords = [];
    // If starting with student view, fetch the initial attendance set
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AttendanceProvider>(context, listen: false);
      if (_selectedType == AttendanceType.student) {
        provider.fetchStudentAttendance().then((_) {
          setState(() {
            _allRecords = provider.studentAttendance;
            _updateFilteredRecords();
          });
        });
      } else {
        provider.fetchEmployeeAttendance().then((_) {
          setState(() {
            _allRecords = provider.employeeAttendance;
            _updateFilteredRecords();
          });
        });
      }
    });
  }

  /// Updates filtered records based on selected type
  void _updateFilteredRecords() {
    setState(() {
      _filteredRecords = _allRecords
          .where((record) => record.type == _selectedType)
          .toList();
    });
  }

  /// Handles type change (student/employee)
  void _handleTypeChange(AttendanceType type) {
    setState(() {
      _selectedType = type;
    });

    if (type == AttendanceType.student) {
      // fetch student attendance and update list
      final provider = Provider.of<AttendanceProvider>(context, listen: false);
      provider.fetchStudentAttendance().then((_) {
        setState(() {
          _allRecords = provider.studentAttendance;
          _updateFilteredRecords();
        });
      });
    } else {
            final provider = Provider.of<AttendanceProvider>(context, listen: false);

     provider.fetchEmployeeAttendance().then((_) {
        setState(() {
          _allRecords = provider.employeeAttendance;
          _updateFilteredRecords();
        });
      });
    }
  }

  /// Handles filter application
  /// In a real app, this would filter the records based on the provided criteria
  void _handleFilterApplied(DateTime? date, String? month, String? status) {
    setState(() {
      _filteredRecords = _allRecords.where((record) {
        // Filter by type
        if (record.type != _selectedType) return false;

        // Filter by status if provided
        if (status != null && record.status != status) return false;

        // In a real app, you would also filter by date and month
        return true;
      }).toList();
    });

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Filters applied: ${status ?? "All Status"}',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF4A90E2),
      ),
    );
  }

  /// Handles export functionality
  /// In a real app, this would export the data to CSV/PDF
  void _handleExport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Exporting ${_selectedType == AttendanceType.student ? "Student" : "Employee"} attendance report...',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = Provider.of<AttendanceProvider>(context);

    // If provider just fetched attendance for current type, populate local lists once
    if (_allRecords.isEmpty) {
      if (_selectedType == AttendanceType.student && attendanceProvider.studentAttendance.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _allRecords = attendanceProvider.studentAttendance;
            _updateFilteredRecords();
          });
        });
      } else if (_selectedType == AttendanceType.employee && attendanceProvider.employeeAttendance.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _allRecords = attendanceProvider.employeeAttendance;
            _updateFilteredRecords();
          });
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
    body: attendanceProvider.loading
      ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width > 600 ? 20 : 12,
              ),
              child: Column(
                children: [
                  if (attendanceProvider.error != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFEF9A9A)),
                      ),
                      child: Text(
                        'Failed to load attendance: ${attendanceProvider.error}',
                        style: const TextStyle(color: Color(0xFFB71C1C)),
                      ),
                    ),
                  AttendanceTableWidget(
                    attendanceRecords: _filteredRecords,
                    selectedType: _selectedType,
                    onTypeChanged: _handleTypeChange,
                    onFilterApplied: _handleFilterApplied,
                    onExport: _handleExport,
                  ),
                ],
              ),
            ),
    );
  }
}
