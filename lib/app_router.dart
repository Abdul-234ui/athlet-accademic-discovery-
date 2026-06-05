import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'welcome_screen.dart';
import 'role_select_screen.dart';
import 'sign_in_screen.dart';
import 'parent_registration_screen.dart';
import 'home_screen.dart';
import 'compare_screen.dart';
import 'student_sign_in_screen.dart';
import 'coach_sign_in_screen.dart';
import 'coach_registration_screen.dart';
import 'student_registration_screen.dart';
import 'location_screen.dart'; // Import the new location screen

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/welcome',
    // The error builder catches broken routes so your app doesn't crash
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text('Page not found: ${state.uri.toString()}')),
    ),
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/role',
        builder: (context, state) => const RoleSelectScreen(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/student_signin',
        builder: (context, state) => const StudentSignInScreen(),
      ),
      GoRoute(
        path: '/coach_signin',
        builder: (context, state) => const CoachSignInScreen(),
      ),
      GoRoute(
        path: '/register/:role',
        builder: (context, state) {
          final role = state.pathParameters['role'] ?? 'Parent';

          if (role == 'Parent') {
            return ParentRegistrationScreen(role: role);
          }

          if (role == 'Coach') {
            return const CoachRegistrationScreen();
          }

          if (role == 'Student') {
            return StudentRegistrationScreen(role: role);
          }

          return Scaffold(
            appBar: AppBar(title: Text('$role Setup')),
            body: Center(child: Text('$role registration coming soon!')),
          );
        },
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/compare',
        builder: (context, state) {
          final selectedAcademies = state.extra as List<String>? ?? [];
          return CompareScreen(selectedAcademies: selectedAcademies);
        },
      ),
      GoRoute(
        path: '/location', // Define a path for the LocationScreen
        builder: (context, state) => const LocationScreen(),
      ),
    ],
  );
});
