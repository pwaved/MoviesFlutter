import 'package:movies_fullstack/features/movies/domain/entities/movie_entity.dart';
import 'package:movies_fullstack/features/movies/domain/repositories/movie_repository.dart';

class GetPopularMovies {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  Stream<List<MovieEntity>> call() {
    return repository.getPopularMovies();
  }
}
