import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_fullstack/features/auth/presentation/pages/login_screen/login_screen.dart';
import 'package:movies_fullstack/features/auth/presentation/providers/auth_provider.dart';
import 'package:movies_fullstack/features/movies/presentation/pages/home_screen/favorites_screen.dart';
import 'package:movies_fullstack/features/movies/presentation/pages/home_screen/home_screen.dart';
import 'package:movies_fullstack/features/movies/presentation/pages/home_screen/movie_detail_screen.dart';
import 'package:movies_fullstack/features/auth/presentation/pages/login_screen/register_screen.dart';


final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    refreshListenable: GoRouterRefreshStream(ref.read(authProvider.notifier).stream),
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = ref.read(authProvider).asData?.value != null;
      final isLoggingIn = state.uri.path == '/login';
      final isRegistering = state.uri.path == '/register';

      if (!isLoggedIn && !isLoggingIn && !isRegistering) {
        return '/login';
      }

      if (isLoggedIn && (isLoggingIn || isRegistering)) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/movie/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return MovieDetailScreen(movieId: id);
        },
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}