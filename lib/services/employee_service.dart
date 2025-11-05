import 'package:novox_edtech_gamification/network/api_urls.dart';
import 'package:novox_edtech_gamification/support/dio_helper.dart';

class EmployeeService {
  static Future getAllEmployees() async {
    try {
      final dio = await DioHelper.getInstance();

      final response = await dio.get("$baseUrl/employeeList");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future createEmployee(data) async {
    try {
      final dio = await DioHelper.getInstance();

      final response = await dio.post("$baseUrl/addEmployee", data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future updateEmployee(id, data) async {
    try {
      final dio = await DioHelper.getInstance();

      final response = await dio.put(
        "$baseUrl/employeeUpdate/$id",
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

      final response = await dio.delete("$baseUrl/employeeDelete/$id");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
