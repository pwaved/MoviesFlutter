import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_fullstack/models/movie.dart';
import 'package:movies_fullstack/repositories/movie_repository.dart';
import 'package:movies_fullstack/services/auth_service.dart';
import 'package:movies_fullstack/widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  Future<List<Movie>>? _searchFuture;

  void _searchMovies(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchFuture = null; 
      });
      return;
    }
    setState(() {
      _searchFuture = context.read<MovieRepository>().searchMovies(query);
    });
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
            child: _searchFuture != null
                ? FutureBuilder<List<Movie>>(
                    future: _searchFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('Nenhum filme encontrado.'));
                      }
                      return MovieGrid(movies: snapshot.data!);
                    },
                  )
                : StreamBuilder<List<Movie>>(
                    stream: context.read<MovieRepository>().getPopularMovies(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text('Erro ao carregar filmes. Verifique sua conexão.'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        // caso o cache esteja vazio
                        return const Center(child: CircularProgressIndicator());
                      }
                      // local cache
                      return MovieGrid(movies: snapshot.data!);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class MovieGrid extends StatelessWidget {
  const MovieGrid({super.key, required this.movies});
  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) => MovieCard(movie: movies[index]),
    );
  }
}