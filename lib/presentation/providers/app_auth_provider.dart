import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';
import '../../domain/usecases/auth/sign_in_usecase.dart';
import '../../domain/usecases/auth/sign_up_usecase.dart';
import '../../domain/usecases/auth/sign_out_usecase.dart';
import '../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../domain/usecases/user/get_user_role_usecase.dart';
import '../../domain/usecases/auth/sign_in_with_google_usecase.dart';
import '../../domain/usecases/auth/sign_in_with_facebook_usecase.dart';
import '../../data/models/user.dart';
import '../../data/models/role.dart';

class AppAuthProvider with ChangeNotifier {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GetUserRoleUseCase _getUserRoleUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignInWithFacebookUseCase _signInWithFacebookUseCase;
  final firebase_auth.FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  User? _currentUser;
  Role? _currentUserRole;

  AppAuthProvider(
      this._signInUseCase,
      this._signUpUseCase,
      this._signOutUseCase,
      this._getCurrentUserUseCase,
      this._getUserRoleUseCase,
      this._signInWithGoogleUseCase,
      this._signInWithFacebookUseCase,
      ) : _auth = firebase_auth.FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn(
          clientId: '1040319832702-iu59o58ksalqn71b2o81d958jfe5057i.apps.googleusercontent.com',
        );

  User? get currentUser => _currentUser;
  Role? get currentUserRole => _currentUserRole;

  Future<User?> signIn(String email, String password) async {
    try {
      final result = await _signInUseCase.execute(email, password);
      if (result != null) {
        _currentUser = result;
        await getUserRole(result.userId);
        notifyListeners();
      }
      return result;
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('Sign in error: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  Future<User?> signUp(String email, String password, String username) async {
    try {
      final result = await _signUpUseCase.execute(email, password, username);
      if (result != null) {
        _currentUser = result;
        await getUserRole(result.userId);
        notifyListeners();
      }
      return result;
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('Sign up error: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final result = await _signInWithGoogleUseCase.execute();
      if (result != null) {
        _currentUser = result;
        await getUserRole(result.userId);
        notifyListeners();
      }
      return result;
    } on PlatformException catch (e) {
      print('PlatformException during Google sign-in:');
      print('  Code: ${e.code}');
      print('  Message: ${e.message}');
      print('  Details: ${e.details}');
      rethrow;
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('FirebaseAuthException during Google sign-in: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error during Google sign-in: $e');
      rethrow;
    }
  }

  Future<User?> signInWithFacebook() async {
    try {
      final result = await _signInWithFacebookUseCase.execute();
      if (result != null) {
        _currentUser = result;
        await getUserRole(result.userId);
        notifyListeners();
      }
      return result;
    } catch (e) {
      print('Sign in with Facebook error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _signOutUseCase.execute();
      await _googleSignIn.signOut();
      _currentUser = null;
      _currentUserRole = null;
      notifyListeners();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  Future<void> getCurrentUser() async {
    try {
      _currentUser = await _getCurrentUserUseCase.execute();
      if (_currentUser != null) {
        await getUserRole(_currentUser!.userId);
      }
      notifyListeners();
    } catch (e) {
      print('Get current user error: $e');
      rethrow;
    }
  }

  Future<void> getUserRole(String userId) async {
    try {
      _currentUserRole = await _getUserRoleUseCase.execute(userId);
      notifyListeners();
    } catch (e) {
      print('Get user role error: $e');
      rethrow;
    }
  }

  Future<User?> signInAsAdmin(String email, String password) async {
    try {
      final user = await signIn(email, password);
      if (user != null) {
        if (_currentUserRole?.name.toLowerCase() != 'admin') {
          await signOut();
          return null;
        }
      }
      return user;
    } catch (e) {
      print('Sign in as admin error: $e');
      rethrow;
    }
  }

  String get userRole => _currentUserRole?.name ?? 'user';

  bool get isAdmin => _currentUserRole?.name.toLowerCase() == 'admin';

  bool get isDefaultRole => _currentUserRole?.isDefault ?? false;

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('Reset password error: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> userData) async {
    // Implement update user profile logic here
    // This is just a placeholder, you'll need to create the actual use case and repository method
    try {
      // await _updateUserProfileUseCase.execute(userId, userData);
      // Update _currentUser with new data
      // notifyListeners();
    } catch (e) {
      print('Update user profile error: $e');
      rethrow;
    }
  }

  Future<void> deleteAccount(String userId) async {
    // Implement delete account logic here
    // This is just a placeholder, you'll need to create the actual use case and repository method
    try {
      // await _deleteAccountUseCase.execute(userId);
      await signOut();
    } catch (e) {
      print('Delete account error: $e');
      rethrow;
    }
  }

  bool get isUserLoggedIn => _currentUser != null;

  String get userDisplayName => _currentUser?.username ?? 'Guest';

  String? get userEmail => _currentUser?.email;

  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      print('Send email verification error: $e');
      rethrow;
    }
  }

  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
      await getCurrentUser();
    } catch (e) {
      print('Reload user error: $e');
      rethrow;
    }
  }
}