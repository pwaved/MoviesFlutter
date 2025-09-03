import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:movies_fullstack/features/movies/domain/entities/movie_entity.dart';
import 'movie_repository.dart';
import 'package:movies_fullstack/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:movies_fullstack/features/movies/data/datasources/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;
  final FirebaseCrashlytics crashlytics;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.crashlytics,
  });

  @override
  Stream<List<MovieEntity>> getPopularMovies() {
    _fetchAndCachePopularMovies();
    return localDataSource.getAllMoviesAsStream();
  }

  Future<void> _fetchAndCachePopularMovies() async {
    try {
      final movies = await remoteDataSource.getPopularMovies();
      await localDataSource.clearMovies();
      await localDataSource.insertMovies(movies);
    } catch (e, st) {
      crashlytics.recordError(e, st, reason: 'Failed to fetch popular movies');
    }
  }

  @override
  Future<List<MovieEntity>> searchMovies(String query) async {
    try {
      return await remoteDataSource.searchMovies(query);
    } catch (e, st) {
      crashlytics.recordError(e, st, reason: 'Failed to search movies');
      rethrow;
    }
  }
  
  @override
  Future<MovieEntity> getMovieDetails(int id) async{
    try {
      return await remoteDataSource.getMovieDetails(id);
    } catch (e, st){
      crashlytics.recordError(e, st, reason: 'Failed to get details from movie');
      rethrow;
    }
  }
}
