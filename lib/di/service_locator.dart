import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// Datasources
import '../data/datasources/firebase/firebase_auth_datasource.dart';
import '../data/datasources/firebase/firebase_user_datasource.dart';
import '../data/datasources/firebase/firebase_role_datasource.dart';

// Repositories
import '../data/repositories/auth_repository.dart';
import '../data/repositories/user_repository.dart';
import '../data/repositories/role_repository.dart';

// Use cases
import '../domain/usecases/auth/sign_in_usecase.dart';
import '../domain/usecases/auth/sign_up_usecase.dart';
import '../domain/usecases/auth/sign_out_usecase.dart';
import '../domain/usecases/auth/get_current_user_usecase.dart';
import '../domain/usecases/user/get_user_role_usecase.dart';
import '../domain/usecases/role/initialize_roles_usecase.dart';
import '../domain/usecases/auth/sign_in_with_google_usecase.dart';
import '../domain/usecases/auth/sign_in_with_facebook_usecase.dart';

// Providers
import '../presentation/providers/app_auth_provider.dart';
import '../presentation/providers/theme_provider.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Firebase
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton(() => GoogleSignIn());
  getIt.registerLazySingleton(() => FacebookAuth.instance);

  // Datasources
  getIt.registerLazySingleton(() => FirebaseAuthDatasource(
    auth: getIt<FirebaseAuth>(),
    googleSignIn: getIt<GoogleSignIn>(),
    facebookAuth: getIt<FacebookAuth>(),
  ));
  getIt.registerLazySingleton(() => FirebaseUserDatasource(firestore: getIt<FirebaseFirestore>()));
  getIt.registerLazySingleton(() => FirebaseRoleDatasource(firestore: getIt<FirebaseFirestore>()));

  // Repositories
  getIt.registerLazySingleton(() => AuthRepository(
    getIt<FirebaseAuthDatasource>(),
    getIt<FirebaseUserDatasource>(),
    getIt<RoleRepository>(),
  ));
  getIt.registerLazySingleton(() => UserRepository(
    getIt<FirebaseUserDatasource>(),
    getIt<RoleRepository>(),
  ));
  getIt.registerLazySingleton(() => RoleRepository(getIt<FirebaseRoleDatasource>()));

  // Use cases
  getIt.registerLazySingleton(() => SignInUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignUpUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignOutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetUserRoleUseCase(getIt<UserRepository>()));
  getIt.registerLazySingleton(() => InitializeRolesUseCase(getIt<RoleRepository>()));
  getIt.registerLazySingleton(() => SignInWithGoogleUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignInWithFacebookUseCase(getIt<AuthRepository>()));

  // Providers
  getIt.registerLazySingleton(() => AppAuthProvider(
    getIt<SignInUseCase>(),
    getIt<SignUpUseCase>(),
    getIt<SignOutUseCase>(),
    getIt<GetCurrentUserUseCase>(),
    getIt<GetUserRoleUseCase>(),
    getIt<SignInWithGoogleUseCase>(),
    getIt<SignInWithFacebookUseCase>(),
  ));

  // Theme Provider
  getIt.registerLazySingleton(() => ThemeProvider());
}