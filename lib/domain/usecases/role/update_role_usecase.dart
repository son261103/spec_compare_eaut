// lib/domain/usecases/role/update_role_usecase.dart
import '../../../data/repositories/role_repository.dart';
import '../../../data/models/role.dart';

class UpdateRoleUseCase {
  final RoleRepository repository;

  UpdateRoleUseCase(this.repository);

  Future<bool> execute(Role role) async {
    return await repository.updateRole(role);
  }
}