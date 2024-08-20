// lib/domain/usecases/role/initialize_roles_usecase.dart

import '../../../data/repositories/role_repository.dart';

class InitializeRolesUseCase {
  final RoleRepository _roleRepository;

  InitializeRolesUseCase(this._roleRepository);

  Future<void> execute() async {
    await _roleRepository.initializeRoles();
  }
}
