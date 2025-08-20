import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_fullstack/models/movie.dart';
import 'package:movies_fullstack/screens/favorites_screen.dart';
import 'package:movies_fullstack/screens/home_screen.dart';
import 'package:movies_fullstack/screens/login_screen.dart';
import 'package:movies_fullstack/screens/register_screen.dart';
import 'package:movies_fullstack/services/auth_service.dart';
import 'package:movies_fullstack/screens/movie_detail_screen.dart';

class AppRouter {
  final AuthService authService;
  late final GoRouter router;

  AppRouter(this.authService) {
    router = GoRouter(
      initialLocation: '/login',
      refreshListenable: authService,
      routes: [
        GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
        GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(path: '/favorites', builder: (context, state) => const FavoritesScreen()),
        GoRoute(
          path: '/movie',
          builder: (context, state) {
            final movie = state.extra as Movie;
            return MovieDetailScreen(movie: movie);
          },
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final bool loggedIn = authService.isLoggedIn;
        final bool isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/register';

        if (!loggedIn && !isAuthRoute) return '/login';
        if (loggedIn && isAuthRoute) return '/home';
        
        return null;
      },
    );
  }
}