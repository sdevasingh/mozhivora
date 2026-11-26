import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mozhivora/core/config/supabase_config.dart';
import 'package:mozhivora/features/auth/domain/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final sb.SupabaseClient _client;

  AuthAccount? _mapUser(sb.User? user) {
    if (user == null) return null;
    return AuthAccount(
      id: user.id,
      email: user.email,
      phone: user.phone,
      fullName: user.userMetadata?['full_name'] as String?,
    );
  }

  @override
  AuthAccount? currentAccount() => _mapUser(_client.auth.currentUser);

  @override
  Stream<AuthAccount?> onAuthChange() =>
      _client.auth.onAuthStateChange.map((e) => _mapUser(e.session?.user));

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  @override
  Future<void> sendMagicLink({required String email}) async {
    await _client.auth.signInWithOtp(email: email);
  }

  @override
  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(sb.OAuthProvider.google);
  }

  @override
  Future<void> sendPhoneOtp({required String phone}) async {
    await _client.auth.signInWithOtp(phone: phone);
  }

  @override
  Future<void> verifyPhoneOtp({
    required String phone,
    required String token,
  }) async {
    await _client.auth.verifyOTP(
      type: sb.OtpType.sms,
      phone: phone,
      token: token,
    );
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  @override
  Future<void> signOut({bool allDevices = false}) async {
    await _client.auth.signOut(
      scope: allDevices ? sb.SignOutScope.global : sb.SignOutScope.local,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repo)
      : super(
          AuthState(
            status: _repo == null
                ? AuthStatus.unconfigured
                : (_repo.currentAccount() != null
                    ? AuthStatus.authenticated
                    : AuthStatus.guest),
            account: _repo?.currentAccount(),
          ),
        ) {
    _sub = _repo?.onAuthChange().listen((account) {
      state = state.copyWith(
        status: account != null ? AuthStatus.authenticated : AuthStatus.guest,
        account: account,
        clearAccount: account == null,
        isLoading: false,
      );
    });
  }

  final AuthRepository? _repo;
  StreamSubscription<AuthAccount?>? _sub;

  Future<void> _run(Future<void> Function(AuthRepository repo) action,
      {String? successMessage}) async {
    final repo = _repo;
    if (repo == null) {
      state = state.copyWith(
        errorMessage:
            'Supabase is not configured. Pass SUPABASE_URL and SUPABASE_ANON_KEY via --dart-define.',
        clearInfo: true,
      );
      return;
    }
    state = state.copyWith(isLoading: true, clearError: true, clearInfo: true);
    try {
      await action(repo);
      state = state.copyWith(isLoading: false, infoMessage: successMessage);
    } on sb.AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> signInWithEmail(String email, String password) =>
      _run((r) => r.signInWithEmail(email: email, password: password));

  Future<void> signUpWithEmail(String email, String password, String name) =>
      _run(
        (r) =>
            r.signUpWithEmail(email: email, password: password, fullName: name),
        successMessage: 'Check your email to confirm your account.',
      );

  Future<void> sendMagicLink(String email) => _run(
        (r) => r.sendMagicLink(email: email),
        successMessage: 'Magic link sent to your email.',
      );

  Future<void> signInWithGoogle() => _run((r) => r.signInWithGoogle());

  Future<void> sendPhoneOtp(String phone) => _run(
        (r) => r.sendPhoneOtp(phone: phone),
        successMessage: 'OTP sent to your phone.',
      );

  Future<void> verifyPhoneOtp(String phone, String token) =>
      _run((r) => r.verifyPhoneOtp(phone: phone, token: token));

  Future<void> sendPasswordReset(String email) => _run(
        (r) => r.sendPasswordReset(email: email),
        successMessage: 'Password reset link sent.',
      );

  Future<void> signOut({bool allDevices = false}) =>
      _run((r) => r.signOut(allDevices: allDevices));

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final authRepositoryProvider = Provider<AuthRepository?>((ref) {
  final client = SupabaseConfig.clientOrNull;
  return client != null ? SupabaseAuthRepository(client) : null;
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
