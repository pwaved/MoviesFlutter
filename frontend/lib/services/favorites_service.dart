import 'package:flutter/material.dart';
import 'package:movies_fullstack/api/backend_api_service.dart';
import 'package:movies_fullstack/services/auth_service.dart';

class FavoritesService extends ChangeNotifier {
  final AuthService? _authService;
  final BackendApiService _apiService = BackendApiService();
  
  List<int> _favoriteMovieIds = [];
  bool _isLoading = false;

  List<int> get favoriteMovieIds => _favoriteMovieIds;
  bool get isLoading => _isLoading;

  FavoritesService(this._authService) {
    if (_authService?.isLoggedIn == true) {
      fetchFavorites();
    }
  }

  bool isFavorite(int movieId) => _favoriteMovieIds.contains(movieId);

  Future<void> fetchFavorites() async {
    if (_authService?.token == null) return;
    _isLoading = true;
    notifyListeners();
    try {
      _favoriteMovieIds = await _apiService.getFavorites(_authService!.token!, _authService.userId!);
    } catch (e) {
      // Tratar erro
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFavorite(int movieId) async {
    if (_authService?.token == null) return;
    try {
      await _apiService.addFavorite(_authService!.token!, _authService.userId!, movieId);
      _favoriteMovieIds.add(movieId);
      notifyListeners();
    } catch (e) {
      // Tratar erro
    }
  }

  Future<void> removeFavorite(int movieId) async {
    if (_authService?.token == null) return;
    try {
      await _apiService.removeFavorite(_authService!.token!, _authService.userId!, movieId);
      _favoriteMovieIds.remove(movieId);
      notifyListeners();
    } catch (e) {
      // Tratar erro
    }
  }
}