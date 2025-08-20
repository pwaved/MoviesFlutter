import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movies_fullstack/navigation/app_router.dart';
import 'package:movies_fullstack/services/auth_service.dart';
import 'package:movies_fullstack/services/favorites_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProxyProvider<AuthService, FavoritesService>(
          create: (context) => FavoritesService(null),
          update: (context, auth, previousFavorites) => FavoritesService(auth),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final router = AppRouter(authService).router;

    return MaterialApp.router(
      title: 'CineFlutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}