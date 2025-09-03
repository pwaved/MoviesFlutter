import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_fullstack/features/movies/domain/entities/movie_entity.dart';
import 'package:movies_fullstack/features/movies/presentation/providers/favorites_provider.dart';
import 'package:movies_fullstack/features/movies/presentation/widgets/movie_poster.dart';

class MovieCard extends ConsumerWidget {
  final MovieEntity movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesProvider);
    final isFavorite = favoritesState.allFavorites.any((favMovie) => favMovie.id == movie.id);

    return GestureDetector(
      onTap: () {
        context.push('/movie/${movie.id}');
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          MoviePoster(posterUrl: movie.fullPosterUrl),
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  final notifier = ref.read(favoritesProvider.notifier);
                  if (isFavorite) {
                    notifier.removeFavorite(movie.id);
                  } else {
                    notifier.addFavorite(movie);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black54,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}