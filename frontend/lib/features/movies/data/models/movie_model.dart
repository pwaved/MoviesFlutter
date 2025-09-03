import 'package:floor/floor.dart';
import 'package:movies_fullstack/features/movies/domain/entities/movie_entity.dart';

@Entity(tableName: 'movies')
class MovieModel extends MovieEntity {
  @override
  @primaryKey
  final int id;
  @override
  final String title;
  @override
  final String overview;
  @override
  final String? posterPath;

  const MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
  }) : super(
          id: id,
          title: title,
          overview: overview,
          posterPath: posterPath,
        );

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
    );
  }
}
