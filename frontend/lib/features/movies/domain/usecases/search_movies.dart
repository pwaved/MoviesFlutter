import 'package:movies_fullstack/features/movies/domain/entities/movie_entity.dart';
import 'package:movies_fullstack/features/movies/domain/repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository repository;

  SearchMovies(this.repository);

  Future<List<MovieEntity>> call(String query) {
    return repository.searchMovies(query);
  }
}
