// lib/domain/usecases/auth/sign_in_with_google_usecase.dart
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user.dart';

class SignInWithGoogleUseCase {
  final AuthRepository repository;

  SignInWithGoogleUseCase(this.repository);

  Future<User?> execute() async {
    return await repository.signInWithGoogle();
  }
}