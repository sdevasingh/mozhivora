enum AuthStatus { guest, authenticated, unconfigured }

class AuthAccount {
  const AuthAccount({
    required this.id,
    this.email,
    this.phone,
    this.fullName,
  });

  final String id;
  final String? email;
  final String? phone;
  final String? fullName;
}

class AuthState {
  const AuthState({
    required this.status,
    this.account,
    this.isLoading = false,
    this.errorMessage,
    this.infoMessage,
    this.guestDemosRemaining = 3,
  });

  final AuthStatus status;
  final AuthAccount? account;
  final bool isLoading;
  final String? errorMessage;
  final String? infoMessage;
  final int guestDemosRemaining;

  bool get isSignedIn => status == AuthStatus.authenticated && account != null;

  AuthState copyWith({
    AuthStatus? status,
    AuthAccount? account,
    bool clearAccount = false,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    String? infoMessage,
    bool clearInfo = false,
    int? guestDemosRemaining,
  }) {
    return AuthState(
      status: status ?? this.status,
      account: clearAccount ? null : (account ?? this.account),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      infoMessage: clearInfo ? null : (infoMessage ?? this.infoMessage),
      guestDemosRemaining: guestDemosRemaining ?? this.guestDemosRemaining,
    );
  }
}

abstract interface class AuthRepository {
  AuthAccount? currentAccount();
  Stream<AuthAccount?> onAuthChange();

  Future<void> signInWithEmail(
      {required String email, required String password});
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  });
  Future<void> sendMagicLink({required String email});
  Future<void> signInWithGoogle();
  Future<void> sendPhoneOtp({required String phone});
  Future<void> verifyPhoneOtp({required String phone, required String token});
  Future<void> sendPasswordReset({required String email});
  Future<void> signOut({bool allDevices = false});
}
