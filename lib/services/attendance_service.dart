import 'dart:convert';
import 'package:novox_edtech_gamification/model/student_attendance_modal.dart';
import 'package:novox_edtech_gamification/network/api_urls.dart';
import 'package:novox_edtech_gamification/support/dio_helper.dart';

class AttendanceService {
  /// Fetches raw student attendance entries from the API and returns
  /// a list of parsed [StudentAttendance] models.
  ///
  /// Note: this service does NOT perform business mapping (ID->name, time
  /// formatting, UI model conversion). Those belong in the provider/business
  /// layer.
  static Future<List<StudentAttendance>> fetchStudentAttendanceRaw() async {
    try {
      final dio = await DioHelper.getInstance();
      final response = await dio.get('$base_url/student/attendlist');

      if (response.statusCode != 200) {
        throw Exception('Failed to load student attendance: ${response.statusCode}');
      }

  final body = response.data;
  // Debug: print the raw employee attendance response so we can inspect
  // exact payload shapes in the console (useful for troubleshooting).
  print('AttendanceService student raw response: $body');
      final List dataList = body is List
          ? body
          : (body is Map && body['data'] is List)
              ? body['data']
              : [];

      final List<StudentAttendance> results = [];
      for (final item in dataList) {
        try {
          final map = item is String ? json.decode(item) as Map<String, dynamic> : Map<String, dynamic>.from(item);
          results.add(StudentAttendance.fromJson(map));
        } catch (_) {
          // skip malformed
          continue;
        }
      }

      return results;
    } catch (e) {
      // Keep logging here for diagnostics
      print('AttendanceService error: $e');
      rethrow;
    }
  }

  /// Fetches raw employee attendance entries from the API and returns
  /// a list of parsed [StudentAttendance] models (employee attendance uses
  /// the `/attendlist` endpoint). This method mirrors
  /// [fetchStudentAttendanceRaw] but targets the employee endpoint.
  static Future<List<StudentAttendance>> fetchEmployeeAttendanceRaw() async {
    try {
      final dio = await DioHelper.getInstance();
      final response = await dio.get('$base_url/attendlist');
print(response);
      if (response.statusCode != 200) {
        throw Exception('Failed to load employee attendance: ${response.statusCode}');
      }

      final body = response.data;
        print('employee attendce employee raw response: $body');

      final List dataList = body is List
          ? body
          : (body is Map && body['data'] is List)
              ? body['data']
              : [];

      final List<StudentAttendance> results = [];
      for (final item in dataList) {
        try {
          final map = item is String ? json.decode(item) as Map<String, dynamic> : Map<String, dynamic>.from(item);
          results.add(StudentAttendance.fromJson(map));
        } catch (_) {
          // skip malformed
          continue;
        }
      }

      return results;
    } catch (e) {
      print('AttendanceService (employee) error: $e');
      rethrow;
    }
  }
}