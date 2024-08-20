// lib/domain/usecases/role/get_default_role_usecase.dart
import '../../../data/repositories/role_repository.dart';
import '../../../data/models/role.dart';

class GetDefaultRoleUseCase {
  final RoleRepository repository;

  GetDefaultRoleUseCase(this.repository);

  Future<Role?> execute() async {
    return await repository.getDefaultRole();
  }
}