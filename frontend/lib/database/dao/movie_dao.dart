import 'package:floor/floor.dart';
import 'package:movies_fullstack/features/movies/data/models/movie_model.dart';

@dao
abstract class MovieDao {
  @Query('SELECT * FROM Movie')
  Stream<List<MovieModel>> getAllMoviesAsStream();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMovies(List<MovieModel> movies);

  @Query('DELETE FROM Movie')
  Future<void> deleteAllMovies();
}