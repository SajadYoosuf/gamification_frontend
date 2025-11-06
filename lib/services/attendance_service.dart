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
      final response = await dio.get('$baseUrl/student/attendlist');

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load student attendance: ${response.statusCode}',
        );
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
          final map = item is String
              ? json.decode(item) as Map<String, dynamic>
              : Map<String, dynamic>.from(item);
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
      final response = await dio.get('$baseUrl/attendlist');
      print(response);
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load employee attendance: ${response.statusCode}',
        );
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
          final map = item is String
              ? json.decode(item) as Map<String, dynamic>
              : Map<String, dynamic>.from(item);
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

  /// Try to get today's attendance entry for a specific user.
  ///
  /// Behavior:
  /// - First attempts a targeted endpoint: GET $baseUrl/student/attend/today/{userId}
  /// - If that fails (404 or unexpected), falls back to fetching the full
  ///   student attend list and client-side filtering by userId + today's date.
  /// Returns null when there's no attendance entry for today for the user.
static Future<StudentAttendance?> getTodayAttendanceForUser(
  String userId,
) async {
  try {
    final dio = await DioHelper.getInstance();
    print("user id in attendance service: $userId");

    // ✅ First API call only
    final resp = await dio.get(
      '$baseUrl/student/getAttendByUserId/$userId',
    );

    print("Response from API: ${resp.data}");

    if (resp.statusCode == 200) {
      final body = resp.data;

      if (body == null) return null;

      // ✅ Extract the "data" object
      if (body is Map && body["data"] is Map) {
        final dataMap = Map<String, dynamic>.from(body["data"]);
        return StudentAttendance.fromJson(dataMap);
      }
    }

    return null;
  } catch (e) {
    print("Error in getTodayAttendanceForUser: $e");
    return null;
  }
}


  /// Post attendance for a student (this covers checkin and checkout updates).
  ///
  /// Expected backend: POST $baseUrl/student/attend/{userId}
  /// Payload can contain: { "date": "yyyy-MM-dd", "Checkin": <iso>, "Checkout": <iso>, "Review": <string>, "Rating": <num> }
  /// This method returns the updated StudentAttendance object when available.
  static Future<StudentAttendance?> postAttendanceForUser(
    String userId,
    Map<String, dynamic> payload,
  ) async {
    try {
      final dio = await DioHelper.getInstance();
      final resp = await dio.post(
        '$baseUrl/student/attend/$userId',
        data: payload,
      );
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final body = resp.data;
        if (body == null) return null;
        final Map<String, dynamic> map = body is List && body.isNotEmpty
            ? Map<String, dynamic>.from(body[0])
            : Map<String, dynamic>.from(body);
        return StudentAttendance.fromJson(map);
      }
      return null;
    } catch (e) {
      print('AttendanceService.postAttendanceForUser error: $e');
      rethrow;
    }
  }

  /// Apply for leave for a student.
  ///
  /// Expected backend: POST $baseUrl/student/leave  with { "userId": <id>, "date": "yyyy-MM-dd", "Reason": "..." }
  // Leave endpoint removed — leave is no longer handled by the client.
}
