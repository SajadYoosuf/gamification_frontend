import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../model/attendance_model.dart';

/// A responsive table widget that displays attendance records
/// 
/// Features:
/// - Responsive design (adapts to screen size)
/// - Filter by date, month, and status
/// - Color-coded status badges
/// - Export functionality
/// - Separate views for students and employees
class AttendanceTableWidget extends StatefulWidget {
  /// List of attendance records to display
  final List<AttendanceModel> attendanceRecords;

  /// Callback when filters are applied
  final Function(DateTime? date, String? month, String? status)? onFilterApplied;

  /// Callback when export button is pressed
  final VoidCallback? onExport;

  /// Currently selected type (student or employee)
  final AttendanceType selectedType;

  /// Callback when type is changed
  final Function(AttendanceType)? onTypeChanged;

  const AttendanceTableWidget({
    super.key,
    required this.attendanceRecords,
    this.onFilterApplied,
    this.onExport,
    required this.selectedType,
    this.onTypeChanged,
  });

  @override
  State<AttendanceTableWidget> createState() => _AttendanceTableWidgetState();
}

class _AttendanceTableWidgetState extends State<AttendanceTableWidget> {
  /// Selected date filter
  DateTime? _selectedDate;

  /// Selected month filter
  String _selectedMonth = 'January 2024';

  /// Selected status filter
  String _selectedStatus = 'All Status';

  /// Date controller for date picker
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    final isTablet = screenWidth > 600 && screenWidth <= 1200;

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
          // Header section
          _buildHeader(isMobile),
          SizedBox(height: isMobile ? 16 : 20),

          // Type selector (Students/Employees)
          _buildTypeSelector(isMobile),
          SizedBox(height: isMobile ? 16 : 20),

          // Filters section
          _buildFilters(isMobile, isTablet),
          SizedBox(height: isMobile ? 16 : 20),

          // Table section
          _buildTable(isMobile, isTablet),
        ],
      ),
    );
  }

  /// Builds the header section with title and export button
  Widget _buildHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Attendance Management',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Track and manage attendance records',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF7F8C8D),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: _buildExportButton(),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Attendance Management',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Track and manage attendance records',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF7F8C8D),
              ),
            ),
          ],
        ),
        _buildExportButton(),
      ],
    );
  }

  /// Builds the export button
  Widget _buildExportButton() {
    return ElevatedButton.icon(
      onPressed: widget.onExport,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4A90E2),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
      icon: const Icon(Icons.download, size: 20),
      label: const Text(
        'Export Report',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Builds the type selector (Students/Employees)
  Widget _buildTypeSelector(bool isMobile) {
    return Row(
      children: [
        Expanded(
          child: _buildTypeButton(
            'Students',
            Icons.school,
            AttendanceType.student,
            isMobile,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTypeButton(
            'Employees',
            Icons.badge,
            AttendanceType.employee,
            isMobile,
          ),
        ),
      ],
    );
  }

  /// Builds a single type button
  Widget _buildTypeButton(
    String label,
    IconData icon,
    AttendanceType type,
    bool isMobile,
  ) {
    final isSelected = widget.selectedType == type;

    return InkWell(
      onTap: () => widget.onTypeChanged?.call(type),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 12 : 16,
          horizontal: isMobile ? 12 : 20,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4A90E2) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF4A90E2) : const Color(0xFFE0E0E0),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF7F8C8D),
              size: isMobile ? 18 : 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF7F8C8D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the filters section
  Widget _buildFilters(bool isMobile, bool isTablet) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateFilter(true),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildMonthFilter()),
              const SizedBox(width: 8),
              Expanded(child: _buildStatusFilter()),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: _buildApplyButton(),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(flex: 2, child: _buildDateFilter(false)),
        const SizedBox(width: 12),
        Expanded(flex: 2, child: _buildMonthFilter()),
        const SizedBox(width: 12),
        Expanded(flex: 2, child: _buildStatusFilter()),
        const SizedBox(width: 12),
        _buildApplyButton(),
      ],
    );
  }

  /// Builds the date filter
  Widget _buildDateFilter(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filter by Date',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF7F8C8D),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: TextField(
            controller: _dateController,
            readOnly: true,
            onTap: () => _selectDate(context),
            decoration: const InputDecoration(
              hintText: 'mm/dd/yyyy',
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFF95A5A6)),
              suffixIcon: Icon(Icons.calendar_today, size: 18, color: Color(0xFF95A5A6)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the month filter
  Widget _buildMonthFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filter by Month',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF7F8C8D),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: DropdownButton<String>(
            value: _selectedMonth,
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF95A5A6)),
            items: [
              'January 2024',
              'February 2024',
              'March 2024',
              'April 2024',
              'May 2024',
              'June 2024',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF2C3E50)),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedMonth = newValue!;
              });
            },
          ),
        ),
      ],
    );
  }

  /// Builds the status filter
  Widget _buildStatusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF7F8C8D),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: DropdownButton<String>(
            value: _selectedStatus,
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF95A5A6)),
            items: ['All Status', 'Present', 'Late', 'Absent', 'Half Day']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF2C3E50)),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedStatus = newValue!;
              });
            },
          ),
        ),
      ],
    );
  }

  /// Builds the apply button
  Widget _buildApplyButton() {
    return ElevatedButton(
      onPressed: () {
        widget.onFilterApplied?.call(
          _selectedDate,
          _selectedMonth,
          _selectedStatus == 'All Status' ? null : _selectedStatus,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4A90E2),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        minimumSize: const Size(0, 45),
      ),
      child: const Text(
        'Apply',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Builds the data table
  Widget _buildTable(bool isMobile, bool isTablet) {
    if (isMobile) {
      return _buildMobileCardList();
    }

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
                'Name',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Date',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Check-In',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Check-Out',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Total Hours',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Status',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Rating',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Feedback',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
          ],
          rows: widget.attendanceRecords.map((record) {
            return DataRow(
              cells: [
                // Name cell with avatar
                DataCell(_buildNameCell(record)),

                // Date cell
                DataCell(Text(
                  DateFormat('MMMM dd, yyyy').format(record.date),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2C3E50),
                  ),
                )),

                // Check-in cell
                DataCell(Text(
                  record.checkInTime ?? '-',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2C3E50),
                  ),
                )),

                // Check-out cell
                DataCell(Text(
                  record.checkOutTime ?? '-',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2C3E50),
                  ),
                )),

                // Total hours cell
                DataCell(Text(
                  record.totalHours,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2C3E50),
                  ),
                )),

                // Status cell with badge
                DataCell(_buildStatusBadge(record.status)),
                // Rating cell
                DataCell(Text(
                  record.rating?.toString() ?? '-',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2C3E50),
                  ),
                )),
                // Feedback cell
                DataCell(Text(
                  record.review ?? '-',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2C3E50),
                  ),
                )),
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
      itemCount: widget.attendanceRecords.length,
      itemBuilder: (context, index) {
        final record = widget.attendanceRecords[index];
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
                // Name and status row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFFE3F2FD),
                      backgroundImage: record.imageUrl != null
                          ? NetworkImage(record.imageUrl!)
                          : null,
                      child: record.imageUrl == null
                          ? Text(
                              _getInitials(record.name),
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
                            record.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          Text(
                            record.courseOrDepartment,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF95A5A6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(record.status),
                  ],
                ),
                const Divider(height: 24),

                // Date
                _buildInfoRow('Date', DateFormat('MMMM dd, yyyy').format(record.date)),
                const SizedBox(height: 8),

                // Check-in and Check-out
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow('Check-In', record.checkInTime ?? '-'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoRow('Check-Out', record.checkOutTime ?? '-'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Total hours
                _buildInfoRow('Total Hours', record.totalHours),
                const SizedBox(height: 8),

                // Rating and Feedback
                _buildInfoRow('Rating', record.rating?.toString() ?? '-'),
                const SizedBox(height: 8),
                _buildInfoRow('Feedback', record.review ?? '-'),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds an info row for mobile cards
  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF7F8C8D),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }

  /// Builds name cell with avatar
  Widget _buildNameCell(AttendanceModel record) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFFE3F2FD),
          backgroundImage:
              record.imageUrl != null ? NetworkImage(record.imageUrl!) : null,
          child: record.imageUrl == null
              ? Text(
                  _getInitials(record.name),
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
              record.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
            Text(
              record.courseOrDepartment,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF95A5A6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds status badge
  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'present':
        backgroundColor = const Color(0xFF4CAF50);
        textColor = Colors.white;
        break;
      case 'late':
        backgroundColor = const Color(0xFFFFA726);
        textColor = Colors.white;
        break;
      case 'absent':
        backgroundColor = const Color(0xFFEF5350);
        textColor = Colors.white;
        break;
      case 'half day':
        backgroundColor = const Color(0xFF42A5F5);
        textColor = Colors.white;
        break;
      default:
        backgroundColor = const Color(0xFF95A5A6);
        textColor = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  /// Extracts initials from name
  String _getInitials(String name) {
    final nameParts = name.trim().split(' ');
    if (nameParts.isEmpty) return '';
    if (nameParts.length == 1) {
      return nameParts[0].substring(0, 1).toUpperCase();
    }
    return '${nameParts[0].substring(0, 1)}${nameParts[1].substring(0, 1)}'
        .toUpperCase();
  }

  /// Shows date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }
}
