// lib/domain/usecases/role/search_roles_usecase.dart
import '../../../data/repositories/role_repository.dart';
import '../../../data/models/role.dart';

class SearchRolesUseCase {
  final RoleRepository repository;

  SearchRolesUseCase(this.repository);

  Future<List<Role>> execute(String query) async {
    return await repository.searchRoles(query);
  }
}