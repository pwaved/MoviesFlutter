import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies_fullstack/main.dart';
import 'package:movies_fullstack/services/auth_service.dart';
import 'package:movies_fullstack/services/favorites_service.dart';
import 'package:provider/provider.dart';

class MockAuthService extends Mock implements AuthService {}
class MockFavoritesService extends Mock implements FavoritesService {}

void main() {
  late MockAuthService mockAuthService;
  late MockFavoritesService mockFavoritesService;

  setUp(() {
    mockAuthService = MockAuthService();
    mockFavoritesService = MockFavoritesService();
    
    when(() => mockAuthService.isLoggedIn).thenReturn(false); 
    when(() => mockAuthService.addListener(any())).thenAnswer((_) {});
  });

  Future<void> pumpMyApp(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthService>.value(value: mockAuthService),
          ChangeNotifierProvider<FavoritesService>.value(value: mockFavoritesService),
        ],
        child: const MyApp(),
      ),
    );
  }

  group('MyApp', () {
    testWidgets('renders using MaterialApp.router', (WidgetTester tester) async {
      await pumpMyApp(tester);

      final materialAppFinder = find.byType(MaterialApp);
      expect(materialAppFinder, findsOneWidget);

      final materialApp = tester.widget<MaterialApp>(materialAppFinder);
      expect(materialApp.routerConfig, isNotNull);
    });

    testWidgets('provides AuthService and FavoritesService to the widget tree',
        (WidgetTester tester) async {
      final testKey = GlobalKey();
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>.value(value: mockAuthService),
            ChangeNotifierProvider<FavoritesService>.value(value: mockFavoritesService),
          ],
          child: Builder(
            builder: (context) {
              final auth = Provider.of<AuthService>(context, listen: false);
              final favorites = Provider.of<FavoritesService>(context, listen: false);
              
              expect(auth, isA<MockAuthService>());
              expect(favorites, isA<MockFavoritesService>());
              
              return Container(key: testKey);
            },
          ),
        ),
      );

      expect(find.byKey(testKey), findsOneWidget);
    });
  });
}
