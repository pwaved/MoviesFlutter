import 'package:floor/floor.dart';
import 'package:movies_fullstack/models/movie.dart';

@dao
abstract class MovieDao {
  @Query('SELECT * FROM Movie')
  Stream<List<Movie>> getAllMoviesAsStream();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMovies(List<Movie> movies);

  @Query('DELETE FROM Movie')
  Future<void> deleteAllMovies();
}