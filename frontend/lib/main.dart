import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movies_fullstack/database/dao/movie_dao.dart';
import 'package:provider/provider.dart';
import 'package:movies_fullstack/navigation/app_router.dart';
import 'package:movies_fullstack/services/auth_service.dart';
import 'package:movies_fullstack/services/favorites_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';
import 'package:movies_fullstack/services/push_notification_service.dart';
import 'package:movies_fullstack/api/tmdb_api_service.dart';
import 'package:movies_fullstack/database/app_database.dart';
import 'package:movies_fullstack/repositories/movie_repository.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
       await PushNotificationService().initialize();
    }


    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }

     final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    runApp(
      MultiProvider(
        providers: [
        Provider(create: (_) => database.movieDao),        
        Provider(create: (_) => TmdbApiService()),
        ProxyProvider2<MovieDao, TmdbApiService, MovieRepository>(
          update: (_, movieDao, apiService, __) => MovieRepository(apiService, movieDao),
        ),
          ChangeNotifierProvider(create: (context) => AuthService()),
          ChangeNotifierProxyProvider<AuthService, FavoritesService>(
            create: (context) => FavoritesService(null),
            update: (context, auth, previous) => FavoritesService(auth),
          ),
        ],
        child: const MyApp(),
      ),
    );
  }, (error, stack) {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    } else {
      debugPrint('Erro capturado: $error\n$stack');
    }
  });
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
