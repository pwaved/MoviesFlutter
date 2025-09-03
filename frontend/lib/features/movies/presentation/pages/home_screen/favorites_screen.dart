import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_fullstack/features/movies/presentation/providers/favorites_provider.dart';
import 'package:movies_fullstack/features/movies/presentation/widgets/movie_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesProvider);
    final favoritesNotifier = ref.read(favoritesProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) => favoritesNotifier.filterFavorites(query),
              decoration: const InputDecoration(
                labelText: 'Pesquisar nos favoritos...',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _buildBody(favoritesState),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(FavoritesState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return Center(child: Text('Erro: ${state.error}'));
    }
    if (state.allFavorites.isEmpty) {
      return const Center(child: Text('Você ainda não tem filmes favoritos.'));
    }
    if (state.filteredFavorites.isEmpty) {
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
      itemCount: state.filteredFavorites.length,
      itemBuilder: (context, index) => MovieCard(movie: state.filteredFavorites[index]),
    );
  }
}