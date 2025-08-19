import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movies_fullstack/api/tmdb_api_service.dart';
import 'package:movies_fullstack/models/movie.dart';
import 'package:movies_fullstack/services/favorites_service.dart';
import 'package:movies_fullstack/widgets/movie_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TmdbApiService _tmdbService = TmdbApiService();
  List<Movie> _allFavoriteMovies = [];
  List<Movie> _filteredFavoriteMovies = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _searchController.addListener(_filterFavorites);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    final favoritesService = context.read<FavoritesService>();
    if (favoritesService.favoriteMovieIds.isEmpty) {
      // Se não houver favoritos, busca no backend.
      // A UI já mostra um loading indicator através do Consumer.
      await favoritesService.fetchFavorites();
    }
    // Após o fetch, busca os detalhes
    final movieDetails = await _fetchMovieDetails(favoritesService.favoriteMovieIds);
    setState(() {
      _allFavoriteMovies = movieDetails;
      _filteredFavoriteMovies = movieDetails;
    });
  }

  Future<List<Movie>> _fetchMovieDetails(List<int> movieIds) async {
    if (movieIds.isEmpty) return [];
    final movieFutures = movieIds.map((id) => _tmdbService.getMovieDetails(id));
    return Future.wait(movieFutures);
  }

  void _filterFavorites() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFavoriteMovies = _allFavoriteMovies.where((movie) {
        return movie.title.toLowerCase().contains(query);
      }).toList();
    });
  }

  Widget _buildBody(FavoritesService favoritesService) {
    if (favoritesService.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (favoritesService.favoriteMovieIds.isEmpty) {
      return const Center(child: Text('Você ainda não tem filmes favoritos.'));
    }
    if (_filteredFavoriteMovies.isEmpty && _searchController.text.isNotEmpty) {
      return const Center(child: Text('Nenhum favorito encontrado para sua busca.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _filteredFavoriteMovies.length,
      itemBuilder: (context, index) => MovieCard(movie: _filteredFavoriteMovies[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritesService = context.watch<FavoritesService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Pesquisar nos favoritos...',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(child: _buildBody(favoritesService)),
        ],
      ),
    );
  }
}