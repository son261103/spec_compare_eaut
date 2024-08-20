import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user.dart';

class SignInWithFacebookUseCase {
  final AuthRepository repository;

  SignInWithFacebookUseCase(this.repository);

  Future<User?> execute() async {
    return await repository.signInWithFacebook();
  }
}