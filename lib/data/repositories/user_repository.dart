import '../models/user.dart';
import '../models/role.dart';
import '../datasources/firebase/firebase_user_datasource.dart';
import '../repositories/role_repository.dart';

class UserRepository {
  final FirebaseUserDatasource _userDatasource;
  final RoleRepository _roleRepository;

  UserRepository(this._userDatasource, this._roleRepository);

  Future<User?> getUserById(String userId) async {
    return await _userDatasource.getUserById(userId);
  }

  Future<List<User>> getAllUsers() async {
    return await _userDatasource.getAllUsers();
  }

  Future<bool> updateUser(User user) async {
    return await _userDatasource.updateUser(user);
  }

  Future<bool> deleteUser(String userId) async {
    return await _userDatasource.deleteUser(userId);
  }

  Future<bool> changeUserRole(String userId, String newRoleId) async {
    return await _userDatasource.updateUserRole(userId, newRoleId);
  }

  Stream<User?> getUserStream(String userId) {
    return _userDatasource.getUserStream(userId);
  }

  Future<List<User>> searchUsers(String query) async {
    return await _userDatasource.searchUsers(query);
  }

  Future<bool> updateLastLoginTime(String userId) async {
    return await _userDatasource.updateLastLoginTime(userId);
  }

  Future<Role?> getUserRole(String userId) async {
    final roleId = await _userDatasource.getUserRole(userId);
    return await _roleRepository.getRoleById(roleId);
  }

  Future<List<User>> getUsersByRole(String roleId) async {
    return await _userDatasource.getUsersByRole(roleId);
  }
}