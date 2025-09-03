import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_fullstack/api/backend_api_service.dart';
import 'package:movies_fullstack/api/tmdb_api_service.dart';
import 'package:movies_fullstack/database/app_database.dart';
import 'package:movies_fullstack/database/dao/movie_dao.dart';
import 'package:movies_fullstack/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:movies_fullstack/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:movies_fullstack/features/auth/data/repositories/auth_local_data_source_impl.dart';
import 'package:movies_fullstack/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:movies_fullstack/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies_fullstack/features/auth/domain/usecases/get_logged_user.dart';
import 'package:movies_fullstack/features/auth/domain/usecases/login_user.dart';
import 'package:movies_fullstack/features/auth/domain/usecases/logout_user.dart';
import 'package:movies_fullstack/features/movies/data/datasources/movie_local_data_source.dart';
import 'package:movies_fullstack/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:movies_fullstack/features/movies/domain/entities/movie_entity.dart';
import 'package:movies_fullstack/features/movies/domain/repositories/movie_repository_impl.dart';
import 'package:movies_fullstack/features/movies/domain/repositories/movie_repository.dart';
import 'package:movies_fullstack/features/movies/domain/usecases/get_movie_details.dart';
import 'package:movies_fullstack/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:movies_fullstack/features/movies/domain/usecases/search_movies.dart';
import 'package:shared_preferences/shared_preferences.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('databaseProvider must be overridden in main.dart');
});

final movieDaoProvider = Provider<MovieDao>((ref) {
  return ref.watch(databaseProvider).movieDao;
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main.dart');
});

// --- API Service Providers ---
final backendApiServiceProvider = Provider<BackendApiService>((ref) {
  return BackendApiService();
});

final tmdbApiServiceProvider = Provider<TmdbApiService>((ref) {
  return TmdbApiService();
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final api = ref.watch(backendApiServiceProvider);
  return AuthRemoteDataSource(api);
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthLocalDataSourceImpl(prefs);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

final loginUserUseCaseProvider = Provider<LoginUser>((ref) {
  return LoginUser(ref.watch(authRepositoryProvider));
});

final logoutUserUseCaseProvider = Provider<LogoutUser>((ref) {
  return LogoutUser(ref.watch(authRepositoryProvider));
});

final getLoggedUserUseCaseProvider = Provider<GetLoggedUser>((ref) {
  return GetLoggedUser(ref.watch(authRepositoryProvider));
});


final movieRemoteDataSourceProvider = Provider<MovieRemoteDataSource>((ref) {
  final api = ref.watch(tmdbApiServiceProvider);
  return MovieRemoteDataSource(api);
});

final movieLocalDataSourceProvider = Provider<MovieLocalDataSource>((ref) {
  final dao = ref.watch(movieDaoProvider);
  return MovieLocalDataSource(dao);
});

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final remoteDataSource = ref.watch(movieRemoteDataSourceProvider);
  final localDataSource = ref.watch(movieLocalDataSourceProvider);

  return MovieRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    crashlytics: FirebaseCrashlytics.instance,
  );
});

final getPopularMoviesUseCaseProvider = Provider((ref) {
  return GetPopularMovies(ref.watch(movieRepositoryProvider));
});

final searchMoviesUseCaseProvider = Provider((ref) {
  return SearchMovies(ref.watch(movieRepositoryProvider));
});

final getMovieDetailsUseCaseProvider = Provider((ref) {
  return GetMovieDetails(ref.watch(movieRepositoryProvider));
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final movieListProvider = StreamProvider.autoDispose<List<MovieEntity>>((ref) {
  final query = ref.watch(searchQueryProvider);
  
  if (query.isEmpty) {
    final getPopularMovies = ref.watch(getPopularMoviesUseCaseProvider);
    return getPopularMovies();
  } else {
    final searchMovies = ref.watch(searchMoviesUseCaseProvider);
    return Stream.fromFuture(searchMovies(query));
  }
});

final movieDetailsProvider =
    FutureProvider.autoDispose.family<MovieEntity, int>((ref, movieId) {
  final getMovieDetails = ref.watch(getMovieDetailsUseCaseProvider);
  return getMovieDetails(movieId);
});