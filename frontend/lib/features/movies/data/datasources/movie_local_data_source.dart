import 'package:movies_fullstack/database/dao/movie_dao.dart';
import 'package:movies_fullstack/features/movies/data/models/movie_model.dart';

class MovieLocalDataSource {
  final MovieDao movieDao;

  MovieLocalDataSource(this.movieDao);

  Stream<List<MovieModel>> getAllMoviesAsStream() {
    return movieDao.getAllMoviesAsStream();
  }

  Future<void> clearMovies() async {
    await movieDao.deleteAllMovies();
  }

  Future<void> insertMovies(List<MovieModel> movies) async {
    await movieDao.insertMovies(movies);
  }
}
