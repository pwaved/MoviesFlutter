import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_fullstack/api/tmdb_api_service.dart';
import 'package:movies_fullstack/models/movie.dart';
import 'package:movies_fullstack/services/auth_service.dart';
import 'package:movies_fullstack/widgets/movie_card.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TmdbApiService _tmdbService = TmdbApiService();
  final _searchController = TextEditingController();
  List<Movie> _movies = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchPopularMovies();
  }

  Future<void> _fetchPopularMovies() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
    final movies = await _tmdbService.getPopularMovies();
    setState(() => _movies = movies);
  } catch (e, stackTrace) { 
    FirebaseCrashlytics.instance.recordError(
      e,
      stackTrace,
      reason: 'Falha ao buscar filmes populares da API TMDB',
      fatal: false 
    );
    setState(() => _errorMessage = 'Erro ao carregar filmes. Tente novamente.');

  } finally {
    setState(() => _isLoading = false);
  }
}

  Future<void> _searchMovies(String query) async {
    if (query.isEmpty) {
      _fetchPopularMovies();
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final movies = await _tmdbService.searchMovies(query);
      setState(() => _movies = movies);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CineFlutter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => context.push('/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthService>().logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          TextButton(
    onPressed: () => throw Exception(),
    child: const Text("Throw Test Exception"),
),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar filmes...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchMovies(_searchController.text),
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: _searchMovies,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(child: Text(_errorMessage))
                    : GridView.builder(
                        padding: const EdgeInsets.all(10.0),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 2 / 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _movies.length,
                        itemBuilder: (context, index) => MovieCard(movie: _movies[index]),
                      ),
          ),
        ],
      ),
    );
  }
}