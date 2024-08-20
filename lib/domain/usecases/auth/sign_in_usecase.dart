// lib/domain/usecases/auth/sign_in_usecase.dart
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<User?> execute(String email, String password) async {
    return await repository.signIn(email, password);
  }
}