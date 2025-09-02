// lib/features/auth/presentation/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_fullstack/core/di/injection_container.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_logged_user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';

class AuthNotifier extends StateNotifier<AsyncValue<UserEntity?>> {
  final LoginUser loginUser;
  final LogoutUser logoutUser;
  final GetLoggedUser getLoggedUser;

  AuthNotifier({
    required this.loginUser,
    required this.logoutUser,
    required this.getLoggedUser,
  }) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    final user = await getLoggedUser();
    state = AsyncValue.data(user);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await loginUser(email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    await logoutUser();
    state = const AsyncValue.data(null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserEntity?>>((ref) {
  final loginUser = ref.watch(loginUserUseCaseProvider);
  final logoutUser = ref.watch(logoutUserUseCaseProvider);
  final getLoggedUser = ref.watch(getLoggedUserUseCaseProvider);

  return AuthNotifier(
    loginUser: loginUser,
    logoutUser: logoutUser,
    getLoggedUser: getLoggedUser,
  );
});