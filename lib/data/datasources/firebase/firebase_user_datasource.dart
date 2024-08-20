import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user.dart';

class FirebaseUserDatasource {
  final FirebaseFirestore _firestore;

  FirebaseUserDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<bool> saveUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.userId).set(user.toJson());
      return true;
    } catch (e) {
      print('Error saving user: $e');
      return false;
    }
  }

  Future<User?> getUserById(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return User.fromJson(userDoc.data()!..['userId'] = userDoc.id);
      }
    } catch (e) {
      print('Error getting user: $e');
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs
          .map((doc) => User.fromJson(doc.data()..['userId'] = doc.id))
          .toList();
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

  Future<bool> updateUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.userId).update(user.toJson());
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      return true;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

  Future<bool> updateLastLoginTime(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error updating last login time: $e');
      return false;
    }
  }

  Future<String> getUserRole(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return userDoc.data()?['roleId'] ?? '';
    } catch (e) {
      print('Error getting user role: $e');
      return '';
    }
  }

  Future<bool> updateUserRole(String userId, String newRoleId) async {
    try {
      await _firestore.collection('users').doc(userId).update({'roleId': newRoleId});
      return true;
    } catch (e) {
      print('Error updating user role: $e');
      return false;
    }
  }

  Stream<User?> getUserStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) => snapshot.exists ? User.fromJson(snapshot.data()!..['userId'] = snapshot.id) : null);
  }

  Future<List<User>> searchUsers(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThan: query + 'z')
          .get();

      return querySnapshot.docs
          .map((doc) => User.fromJson(doc.data()..['userId'] = doc.id))
          .toList();
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

  Future<List<User>> getUsersByRole(String roleId) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('roleId', isEqualTo: roleId)
          .get();
      return querySnapshot.docs
          .map((doc) => User.fromJson(doc.data()..['userId'] = doc.id))
          .toList();
    } catch (e) {
      print('Error getting users by role: $e');
      return [];
    }
  }
}