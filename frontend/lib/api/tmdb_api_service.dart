import 'package:dio/dio.dart';
import 'package:movies_fullstack/features/movies/data/models/movie_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TmdbApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
  )
  );

final String _apiKey = dotenv.env['TMDB_API_KEY'] ?? 'API_KEY_NOT_FOUND';

  Future<List<MovieModel>> getPopularMovies() async {
    try {
      final response = await _dio.get(
        '/movie/popular',
        queryParameters: {
          'api_key': _apiKey,
          'language': 'pt-BR',
          'page': 1,
        },
      );

      final results = response.data['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } catch (e) {
      print('Erro ao buscar filmes populares: $e');
      throw Exception('Falha ao carregar filmes populares');
    }
  }
    Future<List<MovieModel>> searchMovies(String query) async {
    try {
      final response = await _dio.get(
        '/search/movie',
        queryParameters: {'api_key': _apiKey, 'language': 'pt-BR', 'query': query},
      );
      final results = response.data['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Falha ao buscar filmes');
    }
  }

  Future<MovieModel> getMovieDetails(int movieId) async {
    try {
      final response = await _dio.get(
        '/movie/$movieId',
        queryParameters: {'api_key': _apiKey, 'language': 'pt-BR'},
      );
      return MovieModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Falha ao carregar detalhes do filme');
    }
  }
}
