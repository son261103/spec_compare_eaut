// lib/domain/usecases/auth/sign_up_usecase.dart
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<User?> execute(String email, String password, String username) async {
    return await repository.signUp(email, password, username);
  }
}