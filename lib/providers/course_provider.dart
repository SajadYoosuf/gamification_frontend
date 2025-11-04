import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../model/course_model.dart';
import '../services/course_service.dart';

class CourseProvider extends ChangeNotifier {
  List<Course> _courses = [];

  bool _isLoading = false;
  String? _error;
  // Form state for creating/updating a course
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController assignedMentorController = TextEditingController();
  bool _isSubmitting = false;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isSubmitting => _isSubmitting;

  /// Initialize form controllers (optionally with an existing course)
  void initForm([Course? c]) {
    courseNameController.text = c?.courseName ?? '';
    descriptionController.text = c?.discription ?? '';
    durationController.text = c?.duration ?? '';
    feeController.text = c?.fee ?? '';
    assignedMentorController.text = c?.assignedMentor ?? '';
    startDate = c?.startDate;
    endDate = c?.endDate;
  }

  void disposeForm() {
    courseNameController.dispose();
    descriptionController.dispose();
    durationController.dispose();
    feeController.dispose();
    assignedMentorController.dispose();
  }

  void setStartDate(DateTime d) {
    startDate = d;
    notifyListeners();
  }

  void setEndDate(DateTime d) {
    endDate = d;
    notifyListeners();
  }

  Map<String, dynamic> _buildCoursePayload() {
    return {
      'CourseName': courseNameController.text.trim(),
      'Discription': descriptionController.text.trim(),
      'Duration': durationController.text.trim(),
      'Fee': feeController.text.trim(),
      'StartDate': startDate?.toIso8601String() ?? '',
      'EndDate': endDate?.toIso8601String() ?? '',
      'AssignedMentor': assignedMentorController.text.trim(),
    };
  }

  /// Create course via API. Returns true on success and sets _error on failure.
  Future<bool> createCourse() async {
    if (!formKey.currentState!.validate()) return false;
    _isSubmitting = true;
    notifyListeners();

    try {
      final payload = _buildCoursePayload();
      final resp = await CourseService.createCourse(payload);

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

      String serverMessage = 'Course created';
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

        if (jsonBody.containsKey('message')) {
          serverMessage = jsonBody['message'].toString();
        } else if (jsonBody.containsKey('error')) {
          serverMessage = jsonBody['error'].toString();
        }
      }

      if (success) {
        await fetchCourses();
        return true;
      }

      _error = serverMessage;
      return false;
    } catch (e) {
      _error = 'Failed to create course: $e';
      debugPrint(_error);
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> fetchCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _courses = await CourseService.getAllCourses();
      print(_courses);
      _error = null;
    } catch (e) {
      _error = 'Failed to load courses: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get course by ID
  Course? getCourseById(String id) {
    try {
      return _courses.firstWhere((course) => course.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get courses by status
}
