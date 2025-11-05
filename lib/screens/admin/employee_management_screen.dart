import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/employee_list_table_widget.dart';
import '../../styles/employee_management_constants.dart';
import '../../providers/employee_provider.dart';
import 'widgets/employee_form.dart';

/// Main Employee Management Screen
///
/// This screen displays:
/// 1. Statistics cards showing key metrics (total employees, new additions, updates, deletions)
/// 2. Featured employees section with quick view cards
/// 3. Complete employee list in a searchable table
///
/// The screen is organized into clear sections for better user experience
class EmployeeManagement extends StatefulWidget {
  const EmployeeManagement({super.key});

  @override
  State<EmployeeManagement> createState() => _EmployeeManagementState();
}

class _EmployeeManagementState extends State<EmployeeManagement> {
  @override
  void initState() {
    super.initState();
    // No-op: fetching is triggered in Provider create
  }

  /// Handles search functionality
  /// Filters employees based on name, job title, or ID
  void _handleSearch(String query) {
    context.read<EmployeeProvider>().search(query);
  }

  /// Handles adding a new employee
  /// Opens the employee form in a dialog to add a new employee.
  /// Uses the existing `EmployeeProvider` to initialize/submit the form.
  Future<void> _handleAddNewEmployee() async {
    final provider = context.read<EmployeeProvider>();

    // Ensure form is cleared before showing
    provider.initForm(null);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Employee'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: EmployeeForm(
                initialData: null,
                onSubmit: (employee) async {
                  // Attempt to create employee via provider
                  final success = await provider.createEmployee(employee);
                  if (success) {
                    // createEmployee now refreshes the list, just close dialog
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Employee added successfully')),
                    );
                  } else {
                    final errorMsg = provider.error ?? 'Failed to add employee';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMsg)),
                    );
                  }
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  /// Handles viewing employee details
  /// In a real app, this would navigate to employee detail screen                    

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmployeeProvider()..fetchEmployees(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(title: Text("Employee Management")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(
            EmployeeManagementConstants.standardPadding,
          ),
          child: Consumer<EmployeeProvider>(
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

              final employees = provider.filtered;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Employee list table section
                  EmployeeListTableWidget(
                    employees: employees,
                    onSearchChanged: _handleSearch,
                    onAddNewEmployee: _handleAddNewEmployee,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
