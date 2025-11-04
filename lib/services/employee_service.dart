import 'package:novox_edtech_gamification/network/api_urls.dart';
import 'package:novox_edtech_gamification/support/dio_helper.dart';

class EmployeeService {
  static Future getAllEmployees() async {
    try {
      final dio = await DioHelper.getInstance();

      final response = await dio.get("$base_url/employeeList");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future createEmployee(data) async {
    try {
      final dio = await DioHelper.getInstance();

      final response = await dio.post("$base_url/addEmployee", data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future updateEmployee(id, data) async {
    try {
      final dio = await DioHelper.getInstance();

      final response = await dio.put(
        "$base_url/employeeUpdate/$id",
        data: data,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future deleteEmployee(id) async {
    try {
      final dio = await DioHelper.getInstance();

      final response = await dio.delete("$base_url/employeeDelete/$id");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
