// lib/domain/usecases/role/get_all_roles_usecase.dart
import '../../../data/repositories/role_repository.dart';
import '../../../data/models/role.dart';

class GetAllRolesUseCase {
  final RoleRepository repository;

  GetAllRolesUseCase(this.repository);

  Future<List<Role>> execute() async {
    return await repository.getAllRoles();
  }
}