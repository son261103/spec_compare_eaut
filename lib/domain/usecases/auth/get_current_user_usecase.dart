// lib/domain/usecases/auth/get_current_user_usecase.dart
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<User?> execute() async {
    return await repository.currentUser;
  }
}