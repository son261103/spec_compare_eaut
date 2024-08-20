// lib/data/repositories/role_repository.dart

import '../models/role.dart';
import '../datasources/firebase/firebase_role_datasource.dart';

class RoleRepository {
  final FirebaseRoleDatasource _roleDatasource;

  RoleRepository(this._roleDatasource);

  Future<void> initializeRoles() async {
    final roles = await getAllRoles();
    if (roles.isEmpty) {
      await createRole(Role(name: 'admin', isDefault: false));
      await createRole(Role(name: 'user', isDefault: true));
    }
  }

  Future<Role?> getRoleById(String roleId) async {
    return await _roleDatasource.getRoleById(roleId);
  }

  Future<List<Role>> getAllRoles() async {
    return await _roleDatasource.getAllRoles();
  }

  Future<bool> createRole(Role role) async {
    return await _roleDatasource.createRole(role);
  }

  Future<bool> updateRole(Role role) async {
    return await _roleDatasource.updateRole(role);
  }

  Future<bool> deleteRole(String roleId) async {
    return await _roleDatasource.deleteRole(roleId);
  }

  Future<Role?> getDefaultRole() async {
    return await _roleDatasource.getDefaultRole();
  }

  Future<List<Role>> searchRoles(String query) async {
    return await _roleDatasource.searchRoles(query);
  }
}