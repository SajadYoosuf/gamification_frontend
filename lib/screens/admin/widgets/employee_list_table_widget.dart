import 'package:flutter/material.dart';
import '../../../model/employee_model.dart' as api;

/// A table widget that displays a list of employees with their details
///
/// Features:
/// - Sortable columns
/// - Search functionality
/// - Status badges
/// - Employment type badges
/// - Action buttons for each row
class EmployeeListTableWidget extends StatefulWidget {
  /// List of employees to display in the table
  final List<api.EmployeeModal> employees;

  /// Callback when search text changes
  final Function(String)? onSearchChanged;

  /// Callback when "New Employee" button is pressed
  final VoidCallback? onAddNewEmployee;

  const EmployeeListTableWidget({
    super.key,
    required this.employees,
    this.onSearchChanged,
    this.onAddNewEmployee,
  });

  @override
  State<EmployeeListTableWidget> createState() =>
      _EmployeeListTableWidgetState();
}

class _EmployeeListTableWidgetState extends State<EmployeeListTableWidget> {
  /// Controller for the search text field
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Derive designation (job title) from API model
  String _designationOf(api.EmployeeModal e) {
    return e.designation.isNotEmpty ? e.designation.first : 'Employee';
  }

  /// Derive employment type (default until API provides it)
  String _employmentTypeOf(api.EmployeeModal e) {
    return 'N/A';
  }

  /// Derive work model (default until API provides it)
  String _workModelOf(api.EmployeeModal e) {
    return 'On Site';
  }

  /// Derive status (default until API provides it)
  String _statusOf(api.EmployeeModal e) {
    return 'Active';
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    final isTablet = screenWidth > 600 && screenWidth <= 1024;

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
          // Header section with title, search, and add button
          _buildHeader(isMobile),
          SizedBox(height: isMobile ? 16 : 20),

          // Table or Card section based on screen size
          isMobile ? _buildMobileCards() : _buildTable(isTablet),
        ],
      ),
    );
  }

  /// Builds the header section with title, search bar, and add button
  Widget _buildHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Employees List',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 12),

          // Search field
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search employee',
                hintStyle: TextStyle(fontSize: 14, color: Color(0xFF95A5A6)),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF95A5A6),
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // New Employee button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onAddNewEmployee,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90E2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'New Employee',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title
        const Text(
          'Employees List',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),

        // Search and Add button
        Row(
          children: [
            // Search field
            Container(
              width: 250,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: widget.onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Search employee',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0xFF95A5A6)),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFF95A5A6),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // New Employee button
            ElevatedButton(
              onPressed: widget.onAddNewEmployee,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90E2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'New Employee',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds mobile card layout
  Widget _buildMobileCards() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.employees.length,
      itemBuilder: (context, index) {
        final employee = widget.employees[index];
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
                // Name and avatar
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFFE3F2FD),
                      child: Text(
                        _getInitials(employee.fullname),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4A90E2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            employee.fullname,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          Text(
                            'ID: ${employee.id}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF95A5A6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Job Title
                _buildMobileInfoRow('Job Title', _designationOf(employee)),
                const SizedBox(height: 8),

                // Employment Type
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Employment Type',
                      style: TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Work Model
                _buildMobileInfoRow('Work Model', _workModelOf(employee)),
                const SizedBox(height: 8),

                // Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
                    ),
                    _buildStatusBadge(_statusOf(employee)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds info row for mobile cards
  Widget _buildMobileInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
        ),
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

  /// Builds the data table with employee information
  Widget _buildTable(bool isTablet) {
    final dataTableWidget = DataTable(
      headingRowColor: MaterialStateProperty.all(const Color(0xFFF8F9FA)),
      columnSpacing: isTablet ? 20 : 40,
      horizontalMargin: 0,
      dataRowMinHeight: 60,
      dataRowMaxHeight: 80,
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
            'Role',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Phone',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Email',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Students',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Course Assigned',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Reviews',
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
      rows: widget.employees.map((employee) {
        return DataRow(
          cells: [
            // Employee cell with avatar and name
            DataCell(
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFFE3F2FD),
                    child: Text(
                      _getInitials(employee.fullname),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    employee.fullname,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ],
              ),
            ),

            // Role
            DataCell(
              Text(
                employee.designation.isNotEmpty ? employee.designation[0] : 'N/A',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),

            // Phone
            DataCell(
              Text(
                employee.contactNumber.isNotEmpty ? employee.contactNumber : 'N/A',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),

            // Email
            DataCell(
              Text(
                employee.email,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),

            // Students (default to 0)
            const DataCell(
              Text(
                '0',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),

            // Course Assigned
            DataCell(
              Text(
                employee.courseAssigned.isNotEmpty ? employee.courseAssigned : 'None',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),

            // Reviews (default to 0)
            const DataCell(
              Text(
                '0',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),

            // Actions
            DataCell(
              IconButton(
                icon: const Icon(Icons.visibility_outlined, color: Color(0xFF4A90E2)),
                onPressed: () => _showEmployeeDetails(employee),
              ),
            ),
          ],
        );
      }).toList(),
    );

    // On desktop, make table full width; on tablet, allow horizontal scroll
    if (isTablet) {
      // Tablet: Horizontal scroll
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: dataTableWidget,
      );
    } else {
      // Desktop: Full width
      return SizedBox(width: double.infinity, child: dataTableWidget);
    }
  }

  /// Builds a badge for employment type (Full-Time, Part-Time, etc.)
  Widget _buildEmploymentTypeBadge(String type) {
    Color backgroundColor;
    Color textColor;

    switch (type.toLowerCase()) {
      case 'full-time':
      case 'full time':
        backgroundColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1976D2);
        break;
      case 'part-time':
      case 'part time':
        backgroundColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFF57C00);
        break;
      case 'intern':
        backgroundColor = const Color(0xFFF3E5F5);
        textColor = const Color(0xFF7B1FA2);
        break;
      case 'on site':
        backgroundColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF388E3C);
        break;
      case 'hybrid':
        backgroundColor = const Color(0xFFFFF9C4);
        textColor = const Color(0xFFF57F17);
        break;
      default:
        backgroundColor = const Color(0xFFECEFF1);
        textColor = const Color(0xFF546E7A);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  /// Builds a badge for job status (Active, Inactive)
  Widget _buildStatusBadge(String status) {
    final isActive = status.toLowerCase() == 'active';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1976D2) : const Color(0xFF95A5A6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Returns the appropriate icon for the work model
  IconData _getWorkModelIcon(String workModel) {
    switch (workModel.toLowerCase()) {
      case 'hybrid':
        return Icons.home_work_outlined;
      case 'remote':
        return Icons.home_outlined;
      case 'on site':
        return Icons.business_outlined;
      default:
        return Icons.work_outline;
    }
  }

  /// Extracts initials from employee name
  String _getInitials(String name) {
    if (name.isEmpty) return '';
    final nameParts = name.trim().split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}';
    } else if (nameParts.isNotEmpty) {
      return nameParts[0].substring(0, nameParts[0].length > 1 ? 2 : 1);
    }
    return '';
  }

  /// Shows employee details in a dialog
  void _showEmployeeDetails(api.EmployeeModal employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFE3F2FD),
              child: Text(
                _getInitials(employee.fullname),
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF4A90E2),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                employee.fullname,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Role', employee.designation.isNotEmpty ? employee.designation[0] : 'N/A'),
              _buildDetailRow('Email', employee.email),
              _buildDetailRow('Phone', employee.contactNumber),
              _buildDetailRow('Aadhar', employee.aadharNumber),
              _buildDetailRow('PAN', employee.pan),
              _buildDetailRow('Joining Date', employee.joiningDate),
              _buildDetailRow('Blood Group', employee.blood),
              _buildDetailRow('Course Assigned', employee.courseAssigned.isNotEmpty ? employee.courseAssigned : 'None'),
              _buildDetailRow('Emergency Contact', '${employee.emergencyContactName} (${employee.relationship})'),
              _buildDetailRow('Emergency Number', employee.emergencyNumber),
              _buildDetailRow('Address', employee.address),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF7F8C8D),
              ),
            ),
          ),
          const Text(' : '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF2C3E50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
