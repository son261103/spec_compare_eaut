// lib/domain/usecases/user/get_all_users_usecase.dart
import '../../../data/repositories/user_repository.dart';
import '../../../data/models/user.dart';

class GetAllUsersUseCase {
  final UserRepository repository;

  GetAllUsersUseCase(this.repository);

  Future<List<User>> execute() async {
    return await repository.getAllUsers();
  }
}