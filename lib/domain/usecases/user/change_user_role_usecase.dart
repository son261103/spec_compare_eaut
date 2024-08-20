// lib/domain/usecases/user/change_user_role_usecase.dart
import '../../../data/repositories/user_repository.dart';

class ChangeUserRoleUseCase {
  final UserRepository repository;

  ChangeUserRoleUseCase(this.repository);

  Future<bool> execute(String userId, String newRoleId) async {
    return await repository.changeUserRole(userId, newRoleId);
  }
}