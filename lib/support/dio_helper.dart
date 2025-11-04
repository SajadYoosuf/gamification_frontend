import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DioHelper {


  static Dio getInstance() {
     final Logger _logger = Logger();
     final Dio _dio = Dio( BaseOptions(

       headers: {
         "Accept": "application/json",
       },
     ));

    // Add interceptors only once
    if (_dio.interceptors.isEmpty) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            _logger.d('API call - ${options.method} - ${options.uri}');
            // Example: Add auth token if available
            // options.headers['Authorization'] = 'Bearer your_token';
            handler.next(options);
          },
          onResponse: (response, handler) {
            _logger.d('API response - ${response.statusCode} - ${response.requestOptions.uri}');
            handler.next(response);
          },
          onError: (e, handler) {
            if (e.response != null) {
              _logger.e('API error - ${e.response?.statusCode} - ${e.response?.statusMessage}');
              _logger.e(e.response?.data);
            } else {
              _logger.e('API error - ${e.message}');
            }
            handler.next(e);
          },
        ),
      );
    }
    return _dio;
  }
}
