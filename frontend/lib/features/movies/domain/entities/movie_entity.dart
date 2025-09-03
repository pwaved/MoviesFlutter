class MovieEntity {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;

  const MovieEntity({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
  });

  String get fullPosterUrl {
    if (posterPath != null) {
      return 'https://image.tmdb.org/t/p/w500$posterPath';
    }
    return 'https://via.placeholder.com/500x750?text=No+Image';
  }
}
