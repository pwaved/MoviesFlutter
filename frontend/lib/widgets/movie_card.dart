import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:movies_fullstack/models/movie.dart';
import 'package:movies_fullstack/services/favorites_service.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    Widget placeholder = Container(
      color: Colors.grey.shade800,
      child: const Center(child: Icon(Icons.movie, color: Colors.white, size: 50)),
    );

    return GestureDetector(
      onTap: () {
        context.push('/movie', extra: movie);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            movie.posterPath != null
                ? Image.network(
                    movie.fullPosterUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => placeholder,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  )
                : placeholder,
            
            // Botão de favoritar
            Positioned(
              top: 4,
              right: 4,
              child: Consumer<FavoritesService>(
                builder: (context, favoritesService, child) {
                  final isFavorite = favoritesService.isFavorite(movie.id);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      if (isFavorite) {
                        favoritesService.removeFavorite(movie.id);
                      } else {
                        favoritesService.addFavorite(movie.id);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}