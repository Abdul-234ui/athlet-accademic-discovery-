import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _jwtKey = 'jwt_token';

  AuthService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.read(key: _jwtKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Handle session expiration
            await logout();
            // In a real app, we would emit a state change to redirect to login
          }
          return handler.next(e);
        },
      ),
    );
  }

  // Generate a mock JWT for demonstration purposes
  String _generateMockJwt(Map<String, dynamic> payload) {
    final header = base64UrlEncode(utf8.encode(jsonEncode({'alg': 'HS256', 'typ': 'JWT'})));
    final encodedPayload = base64UrlEncode(utf8.encode(jsonEncode(payload)));
    final signature = base64UrlEncode(utf8.encode('mock_signature'));
    return '$header.$encodedPayload.$signature';
  }

  Future<Map<String, dynamic>> loginWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Network simulation

    if (password == 'wrongpassword') {
      throw Exception('Invalid credentials');
    }

    final token = _generateMockJwt({
      'sub': '1234567890',
      'email': email,
      'role': 'Student',
      'exp': DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch ~/ 1000,
    });

    await _secureStorage.write(key: _jwtKey, value: token);
    return {'token': token, 'email': email, 'displayName': email.split('@')[0]};
  }

  Future<Map<String, dynamic>> loginWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1)); 
    final token = _generateMockJwt({
      'sub': 'google_user',
      'email': 'google@example.com',
      'role': 'Student',
      'exp': DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch ~/ 1000,
    });
    await _secureStorage.write(key: _jwtKey, value: token);
    return {'token': token, 'email': 'google@example.com', 'displayName': 'Google User'};
  }

  Future<Map<String, dynamic>> loginWithMicrosoft() async {
    await Future.delayed(const Duration(seconds: 1)); 
    final token = _generateMockJwt({
      'sub': 'ms_user',
      'email': 'microsoft@example.com',
      'role': 'Student',
      'exp': DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch ~/ 1000,
    });
    await _secureStorage.write(key: _jwtKey, value: token);
    return {'token': token, 'email': 'microsoft@example.com', 'displayName': 'Microsoft User'};
  }

  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    if (otp == '123456') {
      final token = _generateMockJwt({
        'sub': 'phone_user',
        'phone': phoneNumber,
        'role': 'Student',
      });
      await _secureStorage.write(key: _jwtKey, value: token);
      return true;
    }
    throw Exception('Invalid OTP');
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate successful password reset email sent
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: _jwtKey);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _jwtKey);
  }
}
