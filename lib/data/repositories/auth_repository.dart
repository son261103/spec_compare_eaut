import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user.dart';
import '../models/role.dart';
import '../datasources/firebase/firebase_auth_datasource.dart';
import '../datasources/firebase/firebase_user_datasource.dart';
import 'role_repository.dart';

class AuthRepository {
  final FirebaseAuthDatasource _authDatasource;
  final FirebaseUserDatasource _userDatasource;
  final RoleRepository _roleRepository;

  AuthRepository(this._authDatasource, this._userDatasource, this._roleRepository);

  Future<User?> signIn(String email, String password) async {
    final userCredential = await _authDatasource.signInWithEmailAndPassword(email, password);
    if (userCredential?.user != null) {
      await _userDatasource.updateLastLoginTime(userCredential!.user!.uid);
      return await _userDatasource.getUserById(userCredential.user!.uid);
    }
    return null;
  }

  Future<User?> signUp(String email, String password, String username) async {
    final userCredential = await _authDatasource.signUpWithEmailAndPassword(email, password);
    if (userCredential?.user != null) {
      final defaultRole = await _roleRepository.getDefaultRole();
      final newUser = User(
        userId: userCredential!.user!.uid,
        username: username,
        email: email,
        createdAt: DateTime.now(),
        roleId: defaultRole?.roleId ?? '',
      );
      await _userDatasource.saveUser(newUser);
      return newUser;
    }
    return null;
  }

  Future<User?> signInWithGoogle() async {
    final userCredential = await _authDatasource.signInWithGoogle();
    return await _handleSocialSignIn(userCredential);
  }

  Future<User?> signInWithFacebook() async {
    final userCredential = await _authDatasource.signInWithFacebook();
    return await _handleSocialSignIn(userCredential);
  }

  Future<User?> _handleSocialSignIn(firebase_auth.UserCredential? userCredential) async {
    if (userCredential?.user != null) {
      await _userDatasource.updateLastLoginTime(userCredential!.user!.uid);
      User? user = await _userDatasource.getUserById(userCredential.user!.uid);
      if (user == null) {
        final defaultRole = await _roleRepository.getDefaultRole();
        user = User(
          userId: userCredential.user!.uid,
          username: userCredential.user!.displayName ?? '',
          email: userCredential.user!.email!,
          createdAt: DateTime.now(),
          roleId: defaultRole?.roleId ?? '',
        );
        await _userDatasource.saveUser(user);
      }
      return user;
    }
    return null;
  }

  Future<void> signOut() async {
    await _authDatasource.signOut();
  }

  Future<Role?> getUserRole(String userId) async {
    final user = await _userDatasource.getUserById(userId);
    if (user != null && user.roleId.isNotEmpty) {
      return await _roleRepository.getRoleById(user.roleId);
    }
    return null;
  }

  Stream<User?> get authStateChanges => _authDatasource.authStateChanges.asyncMap((firebaseUser) async {
    if (firebaseUser == null) return null;
    return await _userDatasource.getUserById(firebaseUser.uid);
  });

  Future<User?> get currentUser async {
    final firebaseUser = _authDatasource.currentUser;
    if (firebaseUser != null) {
      return await _userDatasource.getUserById(firebaseUser.uid);
    }
    return null;
  }
}