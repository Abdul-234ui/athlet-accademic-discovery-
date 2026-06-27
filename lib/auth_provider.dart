import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service.dart';

final isGuestProvider = StateProvider<bool>((ref) => true);

class AppUser {
  final String? displayName;
  final String? email;
  final String? phoneNumber;
  final String? photoURL;

  AppUser({
    this.displayName,
    this.email,
    this.phoneNumber,
    this.photoURL,
  });

  AppUser copyWith({
    String? displayName,
    String? email,
    String? phoneNumber,
    String? photoURL,
  }) {
    return AppUser(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
    );
  }
}

class AuthStateNotifier extends Notifier<AsyncValue<AppUser?>> {
  final AuthService _authService = AuthService();

  @override
  AsyncValue<AppUser?> build() {
    _checkSession();
    return const AsyncValue.loading();
  }

  Future<void> _checkSession() async {
    final token = await _authService.getToken();
    if (token != null) {
      // Decode JWT here if we needed claims, but for mock we just assume valid
      state = AsyncValue.data(AppUser(
        displayName: 'Returning User',
        email: 'user@sportsos.com',
      ));
      ref.read(isGuestProvider.notifier).state = false;
    } else {
      state = const AsyncValue.data(null);
      ref.read(isGuestProvider.notifier).state = true;
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final result = await _authService.loginWithEmail(email, password);
      state = AsyncValue.data(AppUser(
        displayName: result['displayName'],
        email: result['email'],
      ));
      ref.read(isGuestProvider.notifier).state = false;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final result = await _authService.loginWithGoogle();
      state = AsyncValue.data(AppUser(
        displayName: result['displayName'],
        email: result['email'],
      ));
      ref.read(isGuestProvider.notifier).state = false;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> loginWithMicrosoft() async {
    state = const AsyncValue.loading();
    try {
      final result = await _authService.loginWithMicrosoft();
      state = AsyncValue.data(AppUser(
        displayName: result['displayName'],
        email: result['email'],
      ));
      ref.read(isGuestProvider.notifier).state = false;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> verifyOtp(String phone, String otp) async {
    state = const AsyncValue.loading();
    try {
      await _authService.verifyOtp(phone, otp);
      state = AsyncValue.data(AppUser(
        displayName: 'Phone User',
        phoneNumber: phone,
      ));
      ref.read(isGuestProvider.notifier).state = false;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
  
  Future<void> resetPassword(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  void updateProfile({String? name, String? email, String? phone}) {
    if (state.value != null) {
      state = AsyncValue.data(state.value!.copyWith(
        displayName: name,
        email: email,
        phoneNumber: phone,
      ));
    }
  }

  void updateProfilePhoto(String url) {
    if (state.value != null) {
      state = AsyncValue.data(state.value!.copyWith(photoURL: url));
    }
  }

  Future<void> signOut() async {
    await _authService.logout();
    state = const AsyncValue.data(null);
    ref.read(isGuestProvider.notifier).state = true;
  }
}

final authStateProvider = NotifierProvider<AuthStateNotifier, AsyncValue<AppUser?>>(() {
  return AuthStateNotifier();
});

final authControllerProvider = Provider<AuthStateNotifier>((ref) {
  return ref.watch(authStateProvider.notifier);
});
