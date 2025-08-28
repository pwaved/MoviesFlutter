class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
    );
  }

  // Getter para construir a URL completa do pôster
  String get fullPosterUrl {
    if (posterPath != null) {
      return 'https://image.tmdb.org/t/p/w500$posterPath';
    }
    // Retorna uma URL de placeholder se não houver pôster
    return 'https://via.placeholder.com/500x750?text=No+Image';
  }
}