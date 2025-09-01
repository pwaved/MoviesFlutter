import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_fullstack/models/movie.dart';
import 'package:movies_fullstack/widgets/movie_poster.dart'; // Import the new widget

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    // GestureDetector adds the tap behavior
    return GestureDetector(
      onTap: () {
        // Use GoRouter to navigate, passing the movie object
        context.push('/movie', extra: movie);
      },
      child: MoviePoster(posterUrl: movie.fullPosterUrl),
    );
  }
}