import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:movies_fullstack/api/tmdb_api_service.dart';
import 'package:movies_fullstack/database/dao/movie_dao.dart';
import 'package:movies_fullstack/models/movie.dart';

class MovieRepository {
  final TmdbApiService _apiService;
  final MovieDao _movieDao;
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  MovieRepository(this._apiService, this._movieDao);

  // This method stays the same
  Stream<List<Movie>> getPopularMovies() {
    _fetchAndCachePopularMovies();
    return _movieDao.getAllMoviesAsStream();
  }

  Future<void> _fetchAndCachePopularMovies() async {
    try {
      final moviesFromApi = await _apiService.getPopularMovies();
      await _movieDao.deleteAllMovies();
      await _movieDao.insertMovies(moviesFromApi);
    } catch (e, stackTrace) {
      _crashlytics.recordError(
        e,
        stackTrace,
        reason: 'Failed to fetch and cache popular movies',
      );
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    try {
      return await _apiService.searchMovies(query);
    } catch (e, stackTrace) {
      _crashlytics.recordError(
        e,
        stackTrace,
        reason: 'Failed to search movies for query: $query',
      );
      throw Exception('Error searching for movies. Please try again.');
    }
  }
}