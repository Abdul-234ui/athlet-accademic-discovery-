import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mock user class so the profile screen can compile without Firebase
class AppUser {
  final String? displayName = 'Guest User';
  final String? email = 'guest@sportsos.com';
  final String? photoURL = null;
}

// -----------------------------------------------------------------------------
// 1. Auth State Provider
// -----------------------------------------------------------------------------
// Exposes a mock authentication state to the UI.
final authStateProvider = StreamProvider<AppUser?>((ref) async* {
  yield null; // Set to `yield AppUser();` if you want to test the logged-in profile view
});

final authControllerProvider = NotifierProvider<AuthController, void>(() {
  return AuthController();
});

class AuthController extends Notifier<void> {
  @override
  void build() {}

  Future<void> signOut() async {
    print("Signed out successfully (Mock)");
  }
}
