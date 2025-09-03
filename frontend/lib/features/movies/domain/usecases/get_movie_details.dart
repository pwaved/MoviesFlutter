import 'package:movies_fullstack/features/movies/domain/entities/movie_entity.dart';
import 'package:movies_fullstack/features/movies/domain/repositories/movie_repository.dart';

class GetMovieDetails {
  final MovieRepository repository;

  GetMovieDetails(this.repository);

  Future<MovieEntity> call(int id) {
    return repository.getMovieDetails(id);
  }
}