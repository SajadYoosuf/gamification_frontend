  import 'package:novox_edtech_gamification/network/api_urls.dart';
import 'package:novox_edtech_gamification/support/dio_helper.dart';

class StudentService {
  static Future getAllStudents() async {
    try {
      final dio = DioHelper.getInstance();

      final response = await dio.get("$base_url/studentList");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future createStudent(data) async {
    
    try {
      final dio = DioHelper.getInstance();

      final response = await dio.post("$base_url/", data: data);
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
        "$base_url/updateStudent/$id",
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

      final response = await dio.delete("$base_url/deleteStudent/$id");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
