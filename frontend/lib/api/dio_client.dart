import 'package:dio/dio.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.3:3000/api', 
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  )..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

  static Dio get instance => _dio;
}