// lib/domain/usecases/user/get_user_role_usecase.dart
import '../../../data/repositories/user_repository.dart';
import '../../../data/models/role.dart';

class GetUserRoleUseCase {
  final UserRepository repository;

  GetUserRoleUseCase(this.repository);

  Future<Role?> execute(String userId) async {
    return await repository.getUserRole(userId);
  }
}