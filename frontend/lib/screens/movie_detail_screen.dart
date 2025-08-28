import 'package:flutter/material.dart';
import 'package:movies_fullstack/models/movie.dart';
import 'package:movies_fullstack/widgets/movie_card.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exibe o card do filme para uma melhor UI e consistência visual
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 450, 
                ),
                child: AspectRatio(
                  aspectRatio: 2 / 3, 
                  child: MovieCard(movie: movie),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Título da Seção "Sinopse"
            Text(
              'Sinopse',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),

            // Texto da Sinopse
            Text(
              movie.overview.isNotEmpty
                  ? movie.overview
                  : 'Sinopse não disponível.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}