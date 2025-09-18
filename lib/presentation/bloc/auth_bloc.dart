import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/verify_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final VerifyUser verifyUser;
  final LoginRegister loginRegister;
  final GetCurrentUser getCurrentUser;
  final Logout logout;

  AuthBloc({
    required this.verifyUser,
    required this.loginRegister,
    required this.getCurrentUser,
    required this.logout,
  }) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<VerifyPhoneNumber>(_onVerifyPhoneNumber);
    on<VerifyOTP>(_onVerifyOTP);
    on<RegisterUser>(_onRegisterUser);
    on<LogoutUser>(_onLogoutUser);
  }
  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      print('🔍 Checking auth status...');
      final result = await getCurrentUser();
      result.fold(
            (failure) {
          print('❌ Auth check failed: ${failure.message}');
          emit(AuthUnauthenticated());
        },
            (user) {
          if (user != null) {
            print('✅ User authenticated: ${user.firstName} (Token: ${user.token?.substring(0, 20)}...)');
            emit(AuthAuthenticated(user));
          } else {
            print('ℹ️ No authenticated user found');
            emit(AuthUnauthenticated());
          }
        },
      );
    } catch (e) {
      print('🔴 Auth check exception: $e');
      emit(AuthUnauthenticated());
    }
  }
  Future<void> _onVerifyPhoneNumber(
      VerifyPhoneNumber event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      print('🔍 Starting phone verification for: ${event.phoneNumber}');
      final result = await verifyUser(event.phoneNumber);

      result.fold(
            (failure) {
          print('❌ Verification failed: ${failure.message}');
          emit(AuthError(failure.message));
        },
            (response) {
          print('✅ Raw API response.userExists: ${response.userExists}');
          print('✅ Calculated isNewUser: ${!response.userExists}');

          if (response.success) {
            emit(PhoneVerificationRequired(
              phoneNumber: event.phoneNumber,
              isNewUser: !response.userExists, // This should be true for new users
              otp: response.otp,
            ));
          } else {
            emit(AuthError(response.message));
          }
        },
      );
    } catch (e) {
      print('🔴 Verification exception: $e');
      emit(AuthError('Unexpected error occurred: $e'));
    }
  }


  Future<void> _onVerifyOTP(
      VerifyOTP event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    print('🔍 Verifying OTP: ${event.otp} for phone: ${event.phoneNumber}');

    if (event.otp.length == 4 && event.otp.contains(RegExp(r'^\d+$'))) {
      // Get the current state to check user status
      final currentState = state;
      print('🔍 Current state type: ${currentState.runtimeType}');

      bool isNewUser = true; // Default to new user
      if (currentState is PhoneVerificationRequired) {
        isNewUser = currentState.isNewUser;
        print('🔍 State says isNewUser: $isNewUser');
      }

      if (isNewUser) {
        print('➡️ Navigating to registration (NEW USER)');
        emit(RegistrationRequired(event.phoneNumber));
      } else {
        print('➡️ Logging in existing user');
        // For existing users, provide a placeholder name to avoid validation error
        final result = await loginRegister(event.phoneNumber, 'ExistingUser');
        result.fold(
              (failure) {
            print('❌ Login failed: ${failure.message}');
            emit(AuthError(failure.message));
          },
              (response) {
            print('✅ Login successful: ${response.success}');
            if (response.success && response.user != null) {
              emit(AuthAuthenticated(response.user!));
            } else {
              emit(AuthError(response.message));
            }
          },
        );
      }
    } else {
      emit(const AuthError('Invalid OTP. Please enter a valid 4-digit code.'));
    }
  }

  Future<void> _onRegisterUser(
      RegisterUser event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      print('🔍 Starting registration for: ${event.phoneNumber}, name: ${event.firstName}');
      final result = await loginRegister(event.phoneNumber, event.firstName);

      result.fold(
            (failure) {
          print('❌ Registration failed: ${failure.message}');
          emit(AuthError(failure.message));
        },
            (response) {
          print('✅ Registration response: ${response.success}');
          print('✅ Response message: ${response.message}');
          print('✅ User object: ${response.user}');
          print('✅ Token: ${response.token?.substring(0, 20)}...');

          if (response.success && response.user != null) {
            print('➡️ Navigating to home - registration successful');
            emit(AuthAuthenticated(response.user!));
          } else {
            print('❌ Registration response missing user data');
            emit(AuthError(response.message.isNotEmpty ? response.message : 'Registration failed'));
          }
        },
      );
    } catch (e) {
      print('🔴 Registration exception: $e');
      emit(AuthError('Registration failed: $e'));
    }
  }
  Future<void> _onLogoutUser(
      LogoutUser event,
      Emitter<AuthState> emit,
      ) async {
    try {
      print('🚪 Logging out user...');
      await logout();
      print('✅ Logout successful');
      emit(AuthUnauthenticated());
    } catch (e) {
      print('🔴 Logout error: $e');
      emit(AuthError('Logout failed: $e'));
    }
  }
}