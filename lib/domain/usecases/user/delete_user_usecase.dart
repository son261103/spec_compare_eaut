// lib/domain/usecases/user/delete_user_usecase.dart
import '../../../data/repositories/user_repository.dart';

class DeleteUserUseCase {
  final UserRepository repository;

  DeleteUserUseCase(this.repository);

  Future<bool> execute(String userId) async {
    return await repository.deleteUser(userId);
  }
}