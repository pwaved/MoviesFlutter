import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_fullstack/core/di/injection_container.dart';
import 'package:movies_fullstack/api/backend_api_service.dart';

class RegisterNotifier extends StateNotifier<AsyncValue<void>> {
  final BackendApiService _apiService;

  RegisterNotifier(this._apiService) : super(const AsyncValue.data(null));

  Future<void> register(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _apiService.register(email, password);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final registerProvider =
    StateNotifierProvider.autoDispose<RegisterNotifier, AsyncValue<void>>((ref) {
  return RegisterNotifier(ref.watch(backendApiServiceProvider));
});