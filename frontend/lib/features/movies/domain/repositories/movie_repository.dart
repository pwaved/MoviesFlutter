import 'package:movies_fullstack/features/movies/domain/entities/movie_entity.dart';

abstract class MovieRepository {
  Stream<List<MovieEntity>> getPopularMovies();
  Future<List<MovieEntity>> searchMovies(String query);
  Future<MovieEntity> getMovieDetails(int id);
}
