import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../model/student_model.dart';
import '../services/student_service.dart';

/// Provider to manage students (API calls, state, search, errors)
class StudentProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  // Form state
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController guardianController = TextEditingController();
  final TextEditingController guardianNumberController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  final TextEditingController joiningDateController = TextEditingController();
  final TextEditingController emergencyContactController = TextEditingController();
  final TextEditingController emergencyNumberController = TextEditingController();
  final TextEditingController relationshipController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? selectedBloodGroup;
  String? selectedCourseName;
  bool _isSubmitting = false;

  List<Datum> _students = [];
  List<Datum> _filtered = [];
  String? _courseFilter;
  String _lastQuery = '';

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Datum> get students => List.unmodifiable(_students);
  List<Datum> get filtered => List.unmodifiable(_filtered);
  bool get isSubmitting => _isSubmitting;

  Future<void> fetchStudents() async {
    _setLoading(true);
    _error = null;
    try {
      final resp = await StudentService.getAllStudents();

      dynamic body = resp;

      // Normalize response: could be String, Map, or already parsed structure
      Map<String, dynamic> jsonBody;
      if (body is String) {
        jsonBody = json.decode(body) as Map<String, dynamic>;
      } else if (body is Map<String, dynamic>) {
        jsonBody = body;
      } else {
        // Some Dio configurations may return a JS map-like object; try to cast
        jsonBody = Map<String, dynamic>.from(body as Map);
      }

      if (jsonBody['data'] is List) {
        final list = List<dynamic>.from(jsonBody['data']);
        _students = list.map<Datum>((e) => Datum.fromJson(Map<String, dynamic>.from(e))).toList();
        _filtered = List.from(_students);
        // reset filters when reloading raw students
        _courseFilter = null;
        _lastQuery = '';
      } else {
        throw Exception('Unexpected students data format');
      }
    } catch (e) {
      _error = 'Failed to load students: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  /// Initialize form controllers (for add or edit)
  void initForm([Datum? d]) {
    nameController.text = d?.fullname ?? '';
    emailController.text = d?.email ?? '';
    contactNumberController.text = d?.contactNumber ?? '';
    guardianController.text = d?.guardian ?? '';
    guardianNumberController.text = d?.guardianNumber ?? '';
    dobController.text = d?.dob ?? '';
    aadharController.text = d?.aadhar ?? '';
    panController.text = d?.pan ?? '';
    joiningDateController.text = d?.joiningDate.toIso8601String() ?? '';
    emergencyContactController.text = d?.emergencyContactName ?? '';
    emergencyNumberController.text = d?.emergencyNumber ?? '';
    relationshipController.text = d?.relationship ?? '';
    addressController.text = d?.address ?? '';
    selectedBloodGroup = d?.bloodGroup;
    selectedCourseName = d?.course;
  }

  void disposeForm() {
    nameController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    guardianController.dispose();
    guardianNumberController.dispose();
    dobController.dispose();
    aadharController.dispose();
    panController.dispose();
    joiningDateController.dispose();
    emergencyContactController.dispose();
    emergencyNumberController.dispose();
    relationshipController.dispose();
    addressController.dispose();
  }

  /// Builds the payload expected by the backend for creating/updating a student
  Map<String, dynamic> _buildStudentPayload() {
    return {
      'Fullname': nameController.text.trim(),
      'Email': emailController.text.trim(),
      'ContactNumber': contactNumberController.text.trim(),
      'Guardian': guardianController.text.trim(),
      'GuardianNumber': guardianNumberController.text.trim(),
      'DOB': dobController.text.trim(),
      'Aadhar': aadharController.text.trim(),
      'PAN': panController.text.trim(),
      'BloodGroup': selectedBloodGroup ?? '',
      'JoiningDate': joiningDateController.text.trim(),
      'Course': selectedCourseName ?? '',
      'EmergencyContactName': emergencyContactController.text.trim(),
      'EmergencyNumber': emergencyNumberController.text.trim(),
      'Relationship': relationshipController.text.trim(),
      'Address': addressController.text.trim(),
    };
  }

  /// Create student via API. Returns true on success.
  Future<bool> createStudent() async {
    if (!formKey.currentState!.validate()) return false;
    _isSubmitting = true;
    notifyListeners();

    try {
      final payload = _buildStudentPayload();
      final resp = await StudentService.createStudent(payload);
print(resp??"skjaflsadjfklj");
      // Normalize response and read server message/status if provided
      dynamic body = resp;
      Map<String, dynamic>? jsonBody;
      if (body is String) {
        try {
          jsonBody = json.decode(body) as Map<String, dynamic>;
        } catch (_) {
          jsonBody = null;
        }
      } else if (body is Map<String, dynamic>) {
        jsonBody = body;
      } else if (body is Map) {
        jsonBody = Map<String, dynamic>.from(body);
      }

      String serverMessage = 'Student created';
      bool success = true;
      if (jsonBody != null) {
          // status/success may be bool, int (1/0) or string; handle common cases safely
          final statusVal = jsonBody['status'];
          final successVal = jsonBody['success'];
          bool? parsed;
          if (statusVal != null) {
            if (statusVal is bool) parsed = statusVal;
            else if (statusVal is num) parsed = statusVal != 0;
            else if (statusVal is String) parsed = statusVal.toLowerCase() == 'true' || statusVal == '1';
          }
          if (parsed == null && successVal != null) {
            if (successVal is bool) parsed = successVal;
            else if (successVal is num) parsed = successVal != 0;
            else if (successVal is String) parsed = successVal.toLowerCase() == 'true' || successVal == '1';
          }
          if (parsed != null) success = parsed;
        
      }

      if (success) {
        // Refresh list and return true
        await fetchStudents();
        return true;
      }

      // Not successful according to server
      _error = serverMessage;
      debugPrint('createStudent server returned failure: $_error');
      return false;
    } catch (e) {
      // Try to extract server response if present (works with DioError/DioException structures)
      try {
        final dyn = e as dynamic;
        final resp = dyn.response;
        if (resp != null) {
          String message = 'Failed to create student (status ${resp?.statusCode})';
          try {
            final data = resp?.data;
            if (data is Map) {
              if (data['message'] != null) {
                message = data['message'].toString();
              } else if (data['error'] != null) {
                message = data['error'].toString();
              } else if (data['errors'] != null) {
                final errs = data['errors'];
                if (errs is Map) {
                  message = errs.values.map((v) => v.toString()).join(', ');
                } else {
                  message = errs.toString();
                }
              }
            } else if (data is String) {
              message = data;
            }
          } catch (_) {
            // ignore and fallback
          }

          _error = message;
          debugPrint('createStudent error: $_error');
          return false;
        }
      } catch (_) {
        // ignore reflection/cast failures
      }

      _error = 'Failed to create student: $e';
      debugPrint(_error);
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Datum? getStudentById(String id) {
    try {
      return _students.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  void search(String query) {
    _lastQuery = query;
    _applyFilters();
  }

  /// Filter students by course. Pass `null` to clear the course filter.
  void filterByCourse(String? course) {
    _courseFilter = course?.trim().isEmpty ?? true ? null : course;
    _applyFilters();
  }

  void _applyFilters() {
    final q = _lastQuery.trim().toLowerCase();

    List<Datum> temp = List.from(_students);

    // Apply search query if provided
    if (q.isNotEmpty) {
      temp = temp.where((s) {
        final name = s.fullname.toLowerCase();
        final id = s.id.toLowerCase();
        final course = s.course.toLowerCase();
        return name.contains(q) || id.contains(q) || course.contains(q) || s.contactNumber.contains(q);
      }).toList();
    }

    // Apply course filter if set
    if (_courseFilter != null && _courseFilter!.toLowerCase() != 'all courses') {
      final cf = _courseFilter!.toLowerCase();
      temp = temp.where((s) => s.course.toLowerCase() == cf).toList();
    }

    _filtered = temp;
    notifyListeners();
  }

  // You can add create/update/delete methods that call StudentService and then refresh.

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }
}
