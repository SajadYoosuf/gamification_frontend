import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/employee_model.dart';
import '../services/employee_service.dart';
import '../network/api_urls.dart';
import '../services/course_service.dart';
import '../model/course_model.dart';

/// Provider responsible for managing employee data and business logic
class EmployeeProvider extends ChangeNotifier {
  final List<String> _designations = [
    'Developer & Mentor',
    'Digital Marketer & Mentor',
    'Business Development',
    'HR',
    'UI/UX & Mentor',
  ];

  // Form controllers and selection state (moved from UI to provider)
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  final TextEditingController joiningDateController = TextEditingController();
  final TextEditingController emergencyContactController = TextEditingController();
  final TextEditingController emergencyNumberController = TextEditingController();
  final TextEditingController relationshipController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? selectedBloodGroup;
  String? selectedDesignation;
  String? selectecCourseName;

  final List<String> _bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];

  // State management
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Employee lists
  List<EmployeeModal> _employees = [];
  List<EmployeeModal> _filtered = [];
  List<Course> _courses = [];

  // Getters
  List<EmployeeModal> get employees => List.unmodifiable(_employees);
  List<EmployeeModal> get filtered => List.unmodifiable(_filtered);
  List<Course> get courses => List.unmodifiable(_courses);
  List<String> get designations => List.unmodifiable(_designations);
  List<String> get bloodGroups => List.unmodifiable(_bloodGroups);

  // Form validation
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  EmployeeProvider() {
    // no-op for now; controllers are already initialized above
  }

  /// Initialize form controllers and selection state from optional initial data
  void initForm(EmployeeModal? data) {
    if (data == null) {
      // clear
      nameController.text = '';
      emailController.text = '';
      phoneController.text = '';
      aadharController.text = '';
      panController.text = '';
      joiningDateController.text = '';
      emergencyContactController.text = '';
      emergencyNumberController.text = '';
      relationshipController.text = '';
      addressController.text = '';
      selectedBloodGroup = null;
      selectedDesignation = null;
      selectecCourseName = null;
    } else {
      nameController.text = data.fullname;
      emailController.text = data.email;
      phoneController.text = data.contactNumber;
      aadharController.text = data.aadharNumber;
      panController.text = data.pan;
      joiningDateController.text = data.joiningDate;
      emergencyContactController.text = data.emergencyContactName;
      emergencyNumberController.text = data.emergencyNumber;
      relationshipController.text = data.relationship;
      addressController.text = data.address;
      selectedBloodGroup = data.blood.isNotEmpty ? data.blood : null;
      selectedDesignation = data.designation.isNotEmpty ? data.designation[0] : null;
      selectecCourseName = data.courseAssigned;
    }
    notifyListeners();
  }

  /// Dispose controllers when provider is disposed (optional)
  void disposeForm() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    aadharController.dispose();
    panController.dispose();
    joiningDateController.dispose();
    emergencyContactController.dispose();
    emergencyNumberController.dispose();
    relationshipController.dispose();
    addressController.dispose();
  }

  /// Build an EmployeeModal from current form state (keeps initialData fields when provided)
  EmployeeModal buildEmployeeFromForm({EmployeeModal? initialData}) {
    return EmployeeModal(
      id: initialData?.id ?? '',
      fullname: nameController.text.trim(),
      email: emailController.text.trim(),
      contactNumber: phoneController.text.trim(),
      aadharNumber: aadharController.text.trim(),
      pan: panController.text.trim().toUpperCase(),
      joiningDate: joiningDateController.text.trim(),
      blood: selectedBloodGroup ?? '',
      designation: selectedDesignation != null ? [selectedDesignation!] : [],
      courseAssigned: selectecCourseName ?? '',
      emergencyContactName: emergencyContactController.text.trim(),
      emergencyNumber: emergencyNumberController.text.trim(),
      relationship: relationshipController.text.trim(),
      address: addressController.text.trim(),
      password: initialData?.password ?? '',
      salary: initialData?.salary ?? [],
      createdAt: initialData?.createdAt ?? '',
      updatedAt: initialData?.updatedAt ?? '',
    );
  }

  // Selection setters
  void setSelectedBloodGroup(String? value) {
    selectedBloodGroup = value;
    notifyListeners();
  }

  void setSelectedDesignation(String? value) {
    selectedDesignation = value;
    notifyListeners();
  }

  void setselectecCourseName(String? value) {
    selectecCourseName = value;
    notifyListeners();
  }

  /// Validation helpers used by the UI
  String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName is required';
    return null;
  }

  /// Fetches employees from the API
  Future<void> fetchEmployees() async {
    _setLoading(true);
    try {
      final response = await EmployeeService.getAllEmployees();

      if (response == null) throw Exception('No data received from server');
      if (response is! List)
        throw Exception('Expected List but got ${response.runtimeType}');

      _employees = (response).map<EmployeeModal>((e) {
        if (e is! Map<String, dynamic>) {
          throw Exception(
            'Expected Map<String,dynamic> but got ${e.runtimeType}',
          );
        }
        return EmployeeModal.fromJson(e);
      }).toList();

      _filtered = List.from(_employees);
      _error = null;
    } catch (e) {
      _handleError('Failed to load employees', e);
    } finally {
      _setLoading(false);
    }
  }

  /// Fetches available courses for employee assignment
  Future<void> fetchCourses() async {
    try {
      _courses = await CourseService.getAllCourses();
      notifyListeners();
    } catch (e) {
      _handleError('Failed to load courses', e);
    }
  }

  /// Creates a new employee
  Future<bool> createEmployee(EmployeeModal employee) async {
    if (!_formKey.currentState!.validate()) return false;

    _setLoading(true);
    try {
      // Convert employee to JSON and send to API
      final response = await EmployeeService.createEmployee(employee.toJson());

      if (response != null) {
        // Refresh the full list from server to ensure server-side defaults/relations are applied
        await fetchEmployees();
        return true;
      }
      return false;
    } catch (e) {
      _handleError('Failed to create employee', e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Updates an existing employee
  Future<bool> updateEmployee(EmployeeModal employee) async {
    if (!_formKey.currentState!.validate()) return false;

    _setLoading(true);
    try {
      final response = await EmployeeService.updateEmployee(
        employee.id,
        employee.toJson(),
      );

      if (response != null) {
        final index = _employees.indexWhere((e) => e.id == employee.id);
        if (index != -1) {
          _employees[index] = EmployeeModal.fromJson(response);
          _filtered = List.from(_employees);
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      _handleError('Failed to update employee', e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Deletes an employee
  Future<bool> deleteEmployee(String id) async {
    _setLoading(true);
    try {
      final success = await EmployeeService.deleteEmployee(id);

      if (success) {
        _employees.removeWhere((e) => e.id == id);
        _filtered = List.from(_employees);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _handleError('Failed to delete employee', e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Gets an employee by ID
  EmployeeModal? getEmployeeById(String id) {
    try {
      return _employees.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Searches employees by name, email, or designation
  void search(String query) {
    if (query.isEmpty) {
      _filtered = List.from(_employees);
    } else {
    final q = query.toLowerCase();
    _filtered = _employees.where((e) {
    final name = e.fullname.toLowerCase();
    final email = e.email.toLowerCase();
    final designation = e.designation.isNotEmpty
      ? e.designation.first.toLowerCase()
      : '';

    return name.contains(q) ||
      email.contains(q) ||
      designation.contains(q) ||
      e.contactNumber.contains(q);
    }).toList();
    }
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _handleError(String message, dynamic error) {
    _error = '$message: ${error.toString()}';
    debugPrint(_error);
    notifyListeners();
  }

  // Form validation methods
  String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    if (value.length < 3) return 'Name must be at least 3 characters';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Enter a valid 10-digit number';
    }
    return null;
  }

  String? validateAadhar(String? value) {
    // Validation removed: Aadhar is not validated by the form anymore.
    return null;
  }

  String? validatePAN(String? value) {
    // Validation removed: PAN is not validated by the form anymore.
    return null;
  }

  String? validateSelection(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName is required';
    return null;
  }
}
