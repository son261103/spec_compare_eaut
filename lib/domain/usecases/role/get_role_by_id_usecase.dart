// lib/domain/usecases/role/get_role_by_id_usecase.dart
import '../../../data/repositories/role_repository.dart';
import '../../../data/models/role.dart';

class GetRoleByIdUseCase {
  final RoleRepository repository;

  GetRoleByIdUseCase(this.repository);

  Future<Role?> execute(String roleId) async {
    return await repository.getRoleById(roleId);
  }
}