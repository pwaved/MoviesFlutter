import 'package:dio/dio.dart';
import 'package:movies_fullstack/api/dio_client.dart';

class BackendApiService {
  final Dio _dio = DioClient.instance;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Falha ao fazer login';
    }
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {'email': email, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Falha ao registrar';
    }
  }
  Future<List<int>> getFavorites(String token, int userId) async {
    try {
      final response = await _dio.get(
        '/users/$userId/favorites',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return List<int>.from(response.data);
    } on DioException {
      throw 'Falha ao buscar favoritos';
    }
  }

  Future<void> addFavorite(String token, int userId, int movieId) async {
    try {
      await _dio.post(
        '/users/$userId/favorites',
        data: {'movieId': movieId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException {
      throw 'Falha ao adicionar favorito';
    }
  }

  Future<void> removeFavorite(String token, int userId, int movieId) async {
    try {
      await _dio.delete(
        '/users/$userId/favorites/$movieId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException {
      throw 'Falha ao remover favorito';
    }
  }
}
