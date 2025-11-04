import '../network/api_urls.dart';
import '../support/dio_helper.dart';

class LoginService {
 static Future adminLogin(data) async {
    try {
      final dio = DioHelper.getInstance();

      final response = await dio.post("$base_url/adminLogin",data: data);
      return response.data;
    } catch (e) {
      print(e);
    }
  }

 static Future employeeLogin(data) async {
   try {
     final dio = DioHelper.getInstance();

     final response = await dio.post("$base_url/employeeLogin",data: data);
     return response.data;
   } catch (e) {
     print(e);
   }
 }

 static Future studentLogin(data) async {
   try {
     final dio = DioHelper.getInstance();

     final response = await dio.post("$base_url/login",data: data);
     return response.data;
   } catch (e) {
     print(e);
   }
 }
}
