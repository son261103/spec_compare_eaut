import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/role.dart';

class FirebaseRoleDatasource {
  final FirebaseFirestore _firestore;

  FirebaseRoleDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<Role?> getRoleById(String roleId) async {
    try {
      final roleDoc = await _firestore.collection('roles').doc(roleId).get();
      if (roleDoc.exists) {
        return Role.fromJson(roleDoc.data()!..['roleId'] = roleDoc.id);
      }
    } catch (e) {
      print('Error getting role: $e');
    }
    return null;
  }

  Future<List<Role>> getAllRoles() async {
    try {
      final querySnapshot = await _firestore.collection('roles').get();
      return querySnapshot.docs
          .map((doc) => Role.fromJson(doc.data()..['roleId'] = doc.id))
          .toList();
    } catch (e) {
      print('Error getting all roles: $e');
      return [];
    }
  }

  Future<bool> createRole(Role role) async {
    try {
      await _firestore.collection('roles').doc(role.roleId).set(role.toJson());
      return true;
    } catch (e) {
      print('Error creating role: $e');
      return false;
    }
  }

  Future<bool> updateRole(Role role) async {
    try {
      await _firestore.collection('roles').doc(role.roleId).update(role.toJson());
      return true;
    } catch (e) {
      print('Error updating role: $e');
      return false;
    }
  }

  Future<bool> deleteRole(String roleId) async {
    try {
      await _firestore.collection('roles').doc(roleId).delete();
      return true;
    } catch (e) {
      print('Error deleting role: $e');
      return false;
    }
  }

  Future<Role?> getDefaultRole() async {
    try {
      final querySnapshot = await _firestore
          .collection('roles')
          .where('isDefault', isEqualTo: true)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return Role.fromJson(querySnapshot.docs.first.data()..['roleId'] = querySnapshot.docs.first.id);
      }
    } catch (e) {
      print('Error getting default role: $e');
    }
    return null;
  }

  Future<List<Role>> searchRoles(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection('roles')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .get();
      return querySnapshot.docs
          .map((doc) => Role.fromJson(doc.data()..['roleId'] = doc.id))
          .toList();
    } catch (e) {
      print('Error searching roles: $e');
      return [];
    }
  }
}