import 'package:flutter/material.dart';

class MoviePoster extends StatelessWidget {
  final String posterUrl;

  const MoviePoster({super.key, required this.posterUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Image.network(
        posterUrl,
        fit: BoxFit.cover,
        // Shows a loading spinner while the image is loading
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        // Shows a placeholder icon if the image fails to load
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.movie, size: 50, color: Colors.grey),
          );
        },
      ),
    );
  }
}