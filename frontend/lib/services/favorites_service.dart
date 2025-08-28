import 'dart:developer'; 
import 'package:flutter/material.dart';
import 'package:movies_fullstack/api/backend_api_service.dart';
import 'package:movies_fullstack/services/auth_service.dart';

class FavoritesService extends ChangeNotifier {
  final AuthService? _authService;
  final BackendApiService _apiService = BackendApiService();
  
  List<int> _favoriteMovieIds = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<int> get favoriteMovieIds => _favoriteMovieIds;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage; 

  FavoritesService(this._authService) {
    if (_authService?.isLoggedIn == true) {
      fetchFavorites();
    }
  }

  void clearError() {
    _errorMessage = null;
  }

  bool isFavorite(int movieId) => _favoriteMovieIds.contains(movieId);

  Future<void> fetchFavorites() async {
    if (_authService?.token == null) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _favoriteMovieIds = await _apiService.getFavorites(_authService!.token!, _authService.userId!);
    } catch (e) {
      _errorMessage = "Falha ao buscar os filmes favoritos. Tente novamente.";
      log('Erro em fetchFavorites: $e'); 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFavorite(int movieId) async {
    if (_authService?.token == null) return;

    _favoriteMovieIds.add(movieId);
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.addFavorite(_authService!.token!, _authService.userId!, movieId);
    } catch (e) {
      _favoriteMovieIds.remove(movieId);
      _errorMessage = "Não foi possível adicionar o filme aos favoritos.";
      log('Erro em addFavorite: $e');
      notifyListeners(); 
    }
  }

  Future<void> removeFavorite(int movieId) async {
    if (_authService?.token == null) return;
    _favoriteMovieIds.remove(movieId);
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.removeFavorite(_authService!.token!, _authService.userId!, movieId);
    } catch (e) {
      _favoriteMovieIds.add(movieId);
      _errorMessage = "Não foi possível remover o filme dos favoritos.";
      log('Erro em removeFavorite: $e');
      notifyListeners(); 
    }
  }
}