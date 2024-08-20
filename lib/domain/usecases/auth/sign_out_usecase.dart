// lib/domain/usecases/auth/sign_out_usecase.dart
import '../../../data/repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  Future<void> execute() async {
    await repository.signOut();
  }
}