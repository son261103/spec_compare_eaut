// lib/domain/usecases/role/create_role_usecase.dart
import '../../../data/repositories/role_repository.dart';
import '../../../data/models/role.dart';

class CreateRoleUseCase {
  final RoleRepository repository;

  CreateRoleUseCase(this.repository);

  Future<bool> execute(Role role) async {
    return await repository.createRole(role);
  }
}