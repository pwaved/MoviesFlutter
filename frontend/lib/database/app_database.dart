import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:movies_fullstack/features/movies/data/models/movie_model.dart';
import 'package:movies_fullstack/database/dao/movie_dao.dart';

part 'app_database.g.dart'; 

@Database(version: 1, entities: [MovieModel])
abstract class AppDatabase extends FloorDatabase {
  MovieDao get movieDao;
}