import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_fullstack/api/backend_api_service.dart';
import 'package:movies_fullstack/api/tmdb_api_service.dart';
import 'package:movies_fullstack/core/di/injection_container.dart';
import 'package:movies_fullstack/features/auth/presentation/providers/auth_provider.dart';
import 'package:movies_fullstack/features/movies/domain/entities/movie_entity.dart';

class FavoritesState {
  final bool isLoading;
  final List<MovieEntity> allFavorites;
  final List<MovieEntity> filteredFavorites;
  final String? error;

  FavoritesState({
    this.isLoading = true,
    this.allFavorites = const [],
    this.filteredFavorites = const [],
    this.error,
  });

  FavoritesState copyWith({
    bool? isLoading,
    List<MovieEntity>? allFavorites,
    List<MovieEntity>? filteredFavorites,
    String? error,
    bool clearError = false,
  }) {
    return FavoritesState(
      isLoading: isLoading ?? this.isLoading,
      allFavorites: allFavorites ?? this.allFavorites,
      filteredFavorites: filteredFavorites ?? this.filteredFavorites,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final BackendApiService _backendApiService;
  final TmdbApiService _tmdbApiService;
  final Ref _ref;

  FavoritesNotifier(this._backendApiService, this._tmdbApiService, this._ref)
      : super(FavoritesState()) {
    loadFavorites();
  }

  Future<void> addFavorite(MovieEntity movie) async {
    final user = _ref.read(authProvider).asData?.value;
    if (user == null) return; 

    final previousState = state;
    final newFavorites = [...state.allFavorites, movie];
    state = state.copyWith(allFavorites: newFavorites, filteredFavorites: newFavorites);

    try {
      await _backendApiService.addFavorite(user.token, user.id, movie.id);
    } catch (e) {
      state = previousState;
    }
  }

  
  Future<void> removeFavorite(int movieId) async {
    final user = _ref.read(authProvider).asData?.value;
    if (user == null) return;

    final previousState = state;
    final newFavorites = state.allFavorites.where((m) => m.id != movieId).toList();
    state = state.copyWith(allFavorites: newFavorites, filteredFavorites: newFavorites);
    
    try {
      await _backendApiService.removeFavorite(user.token, user.id, movieId);
    } catch (e) {
      state = previousState;
    }
  }

  Future<void> loadFavorites() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = _ref.read(authProvider).asData?.value;
      if (user == null) throw Exception('Usuário não autenticado.');

      final favoriteIds =
          await _backendApiService.getFavorites(user.token, user.id);
      if (favoriteIds.isEmpty) {
        state = state.copyWith(isLoading: false, allFavorites: [], filteredFavorites: []);
        return;
      }
      
      final movieFutures =
          favoriteIds.map((id) => _tmdbApiService.getMovieDetails(id));
      final movies = await Future.wait(movieFutures);

      state = state.copyWith(
        isLoading: false,
        allFavorites: movies,
        filteredFavorites: movies,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void filterFavorites(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredFavorites: state.allFavorites);
    } else {
      final filtered = state.allFavorites.where((movie) {
        return movie.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
      state = state.copyWith(filteredFavorites: filtered);
    }
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  final backendApi = ref.watch(backendApiServiceProvider);
  final tmdbApi = ref.watch(tmdbApiServiceProvider);
  return FavoritesNotifier(backendApi, tmdbApi, ref);
});