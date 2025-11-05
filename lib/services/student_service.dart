  import 'package:novox_edtech_gamification/network/api_urls.dart';
import 'package:novox_edtech_gamification/support/dio_helper.dart';

class StudentService {
  static Future getAllStudents() async {
    try {
      final dio = DioHelper.getInstance();

      final response = await dio.get("$baseUrl/studentList");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future createStudent(data) async {
    
    try {
      final dio = DioHelper.getInstance();

      final response = await dio.post("$baseUrl/", data: data);
      print(response.data??"adsfadfs");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future updateStudent(id, data) async {
    try {
      final dio = DioHelper.getInstance();

      final response = await dio.put(
        "$baseUrl/updateStudent/$id",
        data: data,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future deleteStudent(id) async {
    try {
      final dio = DioHelper.getInstance();

      final response = await dio.delete("$baseUrl/deleteStudent/$id");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch a single student by id. Endpoint: GET $baseUrl/oneStudent/:id
  static Future getStudentById(String id) async {
    try {
      final dio = DioHelper.getInstance();
      final response = await dio.get("$baseUrl/oneStudent/$id");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
