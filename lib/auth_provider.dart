import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'services/firestore_service.dart';

final isGuestProvider = StateProvider<bool>((ref) => true);

class AppUser {
  final String? uid;
  final String? displayName;
  final String? email;
  final String? phoneNumber;
  final String? photoURL;
  final String? role;
  final Map<String, dynamic>? extraData;

  AppUser({
    this.uid,
    this.displayName,
    this.email,
    this.phoneNumber,
    this.photoURL,
    this.role,
    this.extraData,
  });

  AppUser copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? phoneNumber,
    String? photoURL,
    String? role,
    Map<String, dynamic>? extraData,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
      extraData: extraData ?? this.extraData,
    );
  }
}

class AuthStateNotifier extends Notifier<AsyncValue<AppUser?>> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription<User?>? _authStateSubscription;

  @override
  AsyncValue<AppUser?> build() {
    _authStateSubscription?.cancel();
    _authStateSubscription = _authService.authStateChanges.listen((User? user) {
      _handleUserChange(user);
    });
    
    // Initial state check
    final user = _authService.currentUser;
    if (user != null) {
      // Defer this to avoid modifying state during build
      Future.microtask(() => _handleUserChange(user));
    } else {
      // Defer this to avoid modifying other providers during build
      Future.microtask(() => ref.read(isGuestProvider.notifier).state = true);
    }
    
    return const AsyncValue.loading();
  }

  Future<void> _handleUserChange(User? user) async {
    print('DEBUG: _handleUserChange called with user: ${user?.uid}');
    if (user == null) {
      print('DEBUG: user is null, setting state to data(null)');
      state = const AsyncValue.data(null);
      ref.read(isGuestProvider.notifier).state = true;
    } else {
      // Set state to loading ONLY if we don't already have this user's profile loaded
      print('DEBUG: current state uid: ${state.value?.uid}, new user uid: ${user.uid}');
      if (state.value?.uid != user.uid) {
        state = const AsyncValue.loading();
      }
      
      try {
        // Try to fetch profile from firestore
        AppUser? profile = await _firestoreService.getUserProfile(user.uid).timeout(const Duration(seconds: 5));
        
        if (profile == null) {
          // Create new profile
          profile = AppUser(
            uid: user.uid,
            displayName: user.displayName,
            email: user.email,
            phoneNumber: user.phoneNumber,
            photoURL: user.photoURL,
          );
          await _firestoreService.saveUserProfile(user.uid, profile).timeout(const Duration(seconds: 5));
        } else {
          bool needsUpdate = false;
          if ((profile.photoURL == null || profile.photoURL!.isEmpty) && user.photoURL != null) {
            profile = profile.copyWith(photoURL: user.photoURL);
            needsUpdate = true;
          }
          if ((profile.displayName == null || profile.displayName!.isEmpty) && user.displayName != null) {
            profile = profile.copyWith(displayName: user.displayName);
            needsUpdate = true;
          }
          profile = profile.copyWith(uid: user.uid);
          
          if (needsUpdate) {
            await _firestoreService.saveUserProfile(user.uid, profile);
          }
        }
        
        state = AsyncValue.data(profile);
        ref.read(isGuestProvider.notifier).state = false;
      } catch (e) {
        print('Firestore error during user change: $e');
        // Fallback to basic profile if Firestore is offline or fails
        final fallbackProfile = AppUser(
          uid: user.uid,
          displayName: user.displayName,
          email: user.email,
          phoneNumber: user.phoneNumber,
          photoURL: user.photoURL,
        );
        state = AsyncValue.data(fallbackProfile);
        ref.read(isGuestProvider.notifier).state = false;
      }
    }
  }

  Future<void> registerWithEmail(String email, String password, String role, Map<String, dynamic> extraData) async {
    state = const AsyncValue.loading();
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        final profile = AppUser(
          uid: credential.user!.uid,
          email: email,
          displayName: extraData['name'] ?? extraData['parentName'] ?? extraData['coachName'], // Extract name
          phoneNumber: extraData['phone'],
          role: role,
          extraData: extraData,
        );
        print('DEBUG: registerWithEmail profile created: ${profile.uid}, ${profile.email}, role: ${profile.role}');
        
        try {
          await _firestoreService.saveUserProfile(credential.user!.uid, profile).timeout(const Duration(seconds: 5));
          print('DEBUG: registerWithEmail saveUserProfile success');
        } catch (e) {
          print('Warning: Failed to save profile to Firestore immediately (might be offline): $e');
        }
        
        // Immediately set the state so the user doesn't have to wait for the stream or Firestore
        state = AsyncValue.data(profile);
        print('DEBUG: registerWithEmail state set to data(profile)');
        ref.read(isGuestProvider.notifier).state = false;
      }
    } catch (e) {
      print('DEBUG: registerWithEmail caught error: $e');
      state = const AsyncValue.data(null);
      rethrow;
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _authService.loginWithEmail(email, password);
      // state changes handled by stream listener
    } catch (e) {
      state = const AsyncValue.data(null);
      rethrow;
    }
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      await _authService.loginWithGoogle();
      // state changes handled by stream listener
    } catch (e) {
      state = const AsyncValue.data(null);
      rethrow;
    }
  }

  Future<void> loginWithMicrosoft() async {
    state = const AsyncValue.loading();
    try {
      await _authService.loginWithMicrosoft();
      // state changes handled by stream listener
    } catch (e) {
      state = const AsyncValue.data(null);
      rethrow;
    }
  }

  Future<void> verifyOtp(String phone, String otp) async {
    state = const AsyncValue.loading();
    try {
      // Stub for OTP if needed later via Firebase Phone Auth
      throw Exception('Not implemented for Firebase yet');
    } catch (e) {
      state = const AsyncValue.data(null);
      rethrow;
    }
  }
  
  Future<void> resetPassword(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  void updateProfile({String? name, String? email, String? phone}) {
    if (state.value != null && state.value!.uid != null) {
      final updated = state.value!.copyWith(
        displayName: name,
        email: email,
        phoneNumber: phone,
      );
      state = AsyncValue.data(updated);
      _firestoreService.saveUserProfile(state.value!.uid!, updated).timeout(const Duration(seconds: 5)).catchError((e) => print(e));
    }
  }

  void updateProfilePhoto(String url) {
    if (state.value != null && state.value!.uid != null) {
      final updated = state.value!.copyWith(photoURL: url);
      state = AsyncValue.data(updated);
      _firestoreService.saveUserProfile(state.value!.uid!, updated).timeout(const Duration(seconds: 5)).catchError((e) => print(e));
    }
  }

  Future<void> signOut() async {
    await _authService.logout();
    // stream listener will set state to null
  }
}

final authStateProvider = NotifierProvider<AuthStateNotifier, AsyncValue<AppUser?>>(() {
  return AuthStateNotifier();
});

final authControllerProvider = Provider<AuthStateNotifier>((ref) {
  return ref.watch(authStateProvider.notifier);
});
