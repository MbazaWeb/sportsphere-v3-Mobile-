import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../storage/token_storage.dart';
import '../../features/auth/data/auth_api.dart';
import '../../features/home/data/feed_api.dart';
import '../../shared/models/user_profile.dart';
import '../../shared/models/post.dart';
import '../../shared/models/match.dart';

final tokenStorageProvider = Provider((ref) => TokenStorage());

final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(tokenStorageProvider);
  return ApiClient(tokenProvider: storage.readToken);
});

final authApiProvider = Provider((ref) => AuthApi(ref.watch(apiClientProvider)));
final feedApiProvider = Provider((ref) => FeedApi(ref.watch(apiClientProvider)));
final matchesApiProvider = Provider((ref) => MatchesApi(ref.watch(apiClientProvider)));
final standingsApiProvider = Provider((ref) => StandingsApi(ref.watch(apiClientProvider)));
final pollsApiProvider = Provider((ref) => PollsApi(ref.watch(apiClientProvider)));
final predictionsApiProvider = Provider((ref) => PredictionsApi(ref.watch(apiClientProvider)));

class AuthState {
  const AuthState({
    this.user,
    this.isLoading = false,
    this.hydrated = false,
    this.error,
  });

  final UserProfile? user;
  final bool isLoading;
  final bool hydrated;
  final String? error;

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserProfile? user,
    bool? isLoading,
    bool? hydrated,
    String? error,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      hydrated: hydrated ?? this.hydrated,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authApi, this._storage) : super(const AuthState()) {
    hydrate();
  }

  final AuthApi _authApi;
  final TokenStorage _storage;

  Future<void> hydrate() async {
    final token = await _storage.readToken();
    if (token == null || token.isEmpty) {
      state = state.copyWith(hydrated: true);
      return;
    }
    try {
      final user = await _authApi.me();
      state = AuthState(user: user, hydrated: true);
    } catch (_) {
      await _storage.clear();
      state = const AuthState(hydrated: true);
    }
  }

  Future<bool> login({String? email, String? handle, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _authApi.login(email: email, handle: handle, password: password);
      await _storage.saveToken(result.token, expiresAt: result.expiresAt);
      state = AuthState(user: result.user, hydrated: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String handle,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _authApi.register(
        name: name, email: email, handle: handle, password: password,
      );
      await _storage.saveToken(result.token, expiresAt: result.expiresAt);
      state = AuthState(user: result.user, hydrated: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _authApi.logout();
    await _storage.clear();
    state = const AuthState(hydrated: true);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authApiProvider), ref.watch(tokenStorageProvider));
});

final feedProvider = FutureProvider.family<List<Post>, String?>((ref, type) async {
  return ref.watch(feedApiProvider).getFeed(type: type, limit: 30);
});

final matchesProvider = FutureProvider.family<List<MatchItem>, String?>((ref, status) async {
  return ref.watch(matchesApiProvider).getMatches(status: status);
});

final standingsProvider = FutureProvider((ref) async {
  return ref.watch(standingsApiProvider).getStandings();
});
