import 'dart:convert';
import 'package:novox_edtech_gamification/model/course_model.dart';
import 'package:novox_edtech_gamification/network/api_urls.dart';
import 'package:novox_edtech_gamification/support/dio_helper.dart';

class CourseService {
  static Future<List<Course>> getAllCourses() async {
    try {
      final dio = await DioHelper.getInstance();
      final response = await dio.get("$baseUrl/courses");

      if (response.statusCode == 200) {
        final dynamic body = response.data;

        // Normalize response to a List<dynamic> regardless of how Dio returned it
        List<dynamic> dataList;

        if (body is String) {
          // response.data is a JSON string
          final decoded = json.decode(body);
          if (decoded is List) {
            dataList = decoded;
          } else if (decoded is Map && decoded['data'] is List) {
            dataList = decoded['data'];
          } else {
            throw Exception('Unexpected JSON structure for courses');
          }
        } else if (body is List) {
          // Dio already parsed JSON into a List (common on web)
          dataList = List<dynamic>.from(body);
        } else if (body is Map && body['data'] is List) {
          dataList = List<dynamic>.from(body['data']);
        } else {
          throw Exception('Unexpected response type for courses: ${body.runtimeType}');
        }

        return dataList.map((jsonItem) => Course.fromJson(jsonItem)).toList();
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }
 static Future createCourse(data) async {
    try {
      final dio = DioHelper.getInstance();

      final response = await dio.post("$baseUrl/createCourses", data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
   static Future updateCourse(id,data) async {
    try {
      final dio = DioHelper.getInstance();

      final response = await dio.put("$baseUrl/updateCourse/$id", data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
   static Future deleteCourse(id,data) async {
    try {
      final dio = DioHelper.getInstance();

      final response = await dio.delete("$baseUrl/deleteCourse/$id");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
  // Add other course-related API calls as needed
  // - createCourse
  // - updateCourse
  // - deleteCourse
  // - getCourseById
}
