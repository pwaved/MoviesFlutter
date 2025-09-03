import 'package:movies_fullstack/api/tmdb_api_service.dart';
import 'package:movies_fullstack/features/movies/data/models/movie_model.dart';

class MovieRemoteDataSource {
  final TmdbApiService apiService;

  MovieRemoteDataSource(this.apiService);

  Future<List<MovieModel>> getPopularMovies() async {
    return await apiService.getPopularMovies();
  }

  Future<List<MovieModel>> searchMovies(String query) async {
    return await apiService.searchMovies(query);
  }
  Future<MovieModel> getMovieDetails(int id) {
    return apiService.getMovieDetails(id);
  }
}
