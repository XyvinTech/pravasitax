import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravasitax_flutter/src/data/api/auth_api.dart';
import '../services/secure_storage_service.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

class AuthState {
  final bool isAuthenticated;
  final String? token;
  final String? error;
  final String? userType;
  final String? userId;
  final bool isNewUser;

  AuthState({
    this.isAuthenticated = false,
    this.token,
    this.error,
    this.userType,
    this.userId,
    this.isNewUser = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? token,
    String? error,
    String? userType,
    String? userId,
    bool? isNewUser,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      error: error ?? this.error,
      userType: userType ?? this.userType,
      userId: userId ?? this.userId,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthAPI _authAPI;

  AuthNotifier(this._authAPI) : super(AuthState()) {
    _initializeAuthState();
  }

  Future<void> _initializeAuthState() async {
    final token = await SecureStorageService.getAuthToken();
    final isLoggedIn = await SecureStorageService.isLoggedIn();
    final userType = await SecureStorageService.getUserType();
    final userId = await SecureStorageService.getUserId();

    if (token != null && isLoggedIn) {
      state = state.copyWith(
        isAuthenticated: true,
        token: token,
        userType: userType,
        userId: userId,
      );
    }
  }

  Future<void> sendOTP(String email) async {
    try {
      developer.log('Initiating OTP send request',
          name: 'AuthNotifier.sendOTP');
      await _authAPI.sendOTP(email);
      developer.log('OTP sent successfully', name: 'AuthNotifier.sendOTP');
      state = state.copyWith(error: null);
    } catch (e) {
      developer.log('Failed to send OTP',
          error: e.toString(), name: 'AuthNotifier.sendOTP');
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> verifyOTP(String email, String otp) async {
    try {
      developer.log('Initiating OTP verification',
          name: 'AuthNotifier.verifyOTP');

      final response = await _authAPI.verifyOTP(email, otp);

      developer.log('OTP verification successful. Response: $response',
          name: 'AuthNotifier.verifyOTP');

      final token = response['token'] as String;
      final userType = response['user_type'] as String;
      final userId = response['user_id'] as String;
      final isNewUser = response['new_user'] as bool;

      await SecureStorageService.saveAuthToken(token);
      await SecureStorageService.saveUserType(userType);
      await SecureStorageService.saveUserId(userId);

      state = state.copyWith(
        isAuthenticated: true,
        token: token,
        userType: userType,
        userId: userId,
        isNewUser: isNewUser,
        error: null,
      );

      developer.log('Auth state updated successfully',
          name: 'AuthNotifier.verifyOTP');
    } catch (e) {
      developer.log('Failed to verify OTP',
          error: e.toString(), name: 'AuthNotifier.verifyOTP');
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      developer.log('Logging out user', name: 'AuthNotifier.logout');
      await SecureStorageService.clearCredentials();
      state = AuthState();
      developer.log('Logout successful', name: 'AuthNotifier.logout');
    } catch (e) {
      developer.log('Error during logout',
          error: e.toString(), name: 'AuthNotifier.logout');
      rethrow;
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authAPI = ref.watch(authAPIProvider);
  return AuthNotifier(authAPI);
});
