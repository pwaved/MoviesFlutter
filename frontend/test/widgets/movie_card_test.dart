// test/widgets/movie_card_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies_fullstack/features/movies/data/models/movie_model.dart';
import 'package:movies_fullstack/services/favorites_service.dart';
import 'package:movies_fullstack/features/movies/presentation/widgets/movie_card.dart';
import 'package:provider/provider.dart';

class MockFavoritesService extends Mock implements FavoritesService {}

void main() {
  late MockFavoritesService mockFavoritesService;
  late MovieModel testMovie;

  setUp(() {
    mockFavoritesService = MockFavoritesService();
    testMovie = const MovieModel(
      id: 1,
      title: 'Test Movie',
      overview: 'test movie.',
      posterPath: '/test_poster.jpg', 
    );
  });

  Future<void> pumpWidget(WidgetTester tester, {required MovieModel movie}) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<FavoritesService>.value(
        value: mockFavoritesService,
        child: MaterialApp(
          home: Scaffold(
            body: MovieCard(movie: movie),
          ),
        ),
      ),
    );
  }


  group('MovieCard', () {
    testWidgets('displays placeholder when posterPath is null',
        (WidgetTester tester) async {
      final movieWithoutPoster = MovieModel(id: 2, title: 'No Poster', overview: '');
      
      when(() => mockFavoritesService.isFavorite(any())).thenReturn(false);

      await pumpWidget(tester, movie: movieWithoutPoster);

      expect(find.byIcon(Icons.movie), findsOneWidget);
    });

    testWidgets('shows favorite_border icon and adds to favorites on tap',
        (WidgetTester tester) async {
      when(() => mockFavoritesService.isFavorite(testMovie.id)).thenReturn(false);

      when(() => mockFavoritesService.addFavorite(testMovie.id)).thenAnswer((_) async {});

      await pumpWidget(tester, movie: testMovie);

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump(); 

      verify(() => mockFavoritesService.addFavorite(testMovie.id)).called(1);
    });

    testWidgets('shows favorite icon and removes from favorites on tap',
        (WidgetTester tester) async {

      when(() => mockFavoritesService.isFavorite(testMovie.id)).thenReturn(true);

      when(() => mockFavoritesService.removeFavorite(testMovie.id)).thenAnswer((_) async {});

      await pumpWidget(tester, movie: testMovie);

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);

      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pump();

      verify(() => mockFavoritesService.removeFavorite(testMovie.id)).called(1);
    });
  });
}