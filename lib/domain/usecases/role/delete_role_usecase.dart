// lib/domain/usecases/role/delete_role_usecase.dart
import '../../../data/repositories/role_repository.dart';

class DeleteRoleUseCase {
  final RoleRepository repository;

  DeleteRoleUseCase(this.repository);

  Future<bool> execute(String roleId) async {
    return await repository.deleteRole(roleId);
  }
}