import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/services.dart';

class FirebaseAuthDatasource {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;

  FirebaseAuthDatasource({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
    FacebookAuth? facebookAuth,
  }) :
        _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(
          clientId: '1040319832702-iu59o58ksalqn71b2o81d958jfe5057i.apps.googleusercontent.com',
        ),
        _facebookAuth = facebookAuth ?? FacebookAuth.instance;

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print('Failed to sign in: ${e.message}');
      return null;
    }
  }

  Future<UserCredential?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print('Failed to sign up: ${e.message}');
      return null;
    }
  }

  Future<UserCredential?> signInWithCredential(AuthCredential credential) async {
    try {
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print('Failed to sign in with credential: ${e.message}');
      return null;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google Sign In was aborted by the user');
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await signInWithCredential(credential);
    } on PlatformException catch (e) {
      print('PlatformException during Google sign-in:');
      print('  Code: ${e.code}');
      print('  Message: ${e.message}');
      print('  Details: ${e.details}');
      return null;
    } catch (e) {
      print('Unexpected error during Google sign in: $e');
      return null;
    }
  }

  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await _facebookAuth.login();
      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken;
        if (accessToken != null) {
          final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.tokenString);
          return await signInWithCredential(credential);
        } else {
          print('Facebook access token is null');
          return null;
        }
      } else {
        print('Facebook login failed with status: ${result.status}');
        return null;
      }
    } catch (e) {
      print('Failed to sign in with Facebook: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Kiểm tra xem người dùng đã đăng nhập bằng Google chưa
      final googleSignInAccount = await _googleSignIn.signInSilently();
      if (googleSignInAccount != null) {
        await _googleSignIn.signOut();
        print('Đã đăng xuất khỏi Google');
      }
    } catch (e) {
      print('Lỗi khi đăng xuất khỏi Google: $e');
    }

    try {
      // Kiểm tra xem người dùng đã đăng nhập bằng Facebook chưa
      final AccessToken? accessToken = await _facebookAuth.accessToken;
      if (accessToken != null) {
        await _facebookAuth.logOut();
        print('Đã đăng xuất khỏi Facebook');
      }
    } catch (e) {
      print('Lỗi khi đăng xuất khỏi Facebook: $e');
    }

    // Cuối cùng, đăng xuất khỏi Firebase
    await _auth.signOut();
    print('Đã đăng xuất khỏi Firebase');
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print('Failed to send password reset email: ${e.message}');
      rethrow;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      print('Failed to update password: ${e.message}');
      rethrow;
    }
  }
}