// lib/domain/usecases/user/get_user_by_id_usecase.dart
import '../../../data/repositories/user_repository.dart';
import '../../../data/models/user.dart';

class GetUserByIdUseCase {
  final UserRepository repository;

  GetUserByIdUseCase(this.repository);

  Future<User?> execute(String userId) async {
    return await repository.getUserById(userId);
  }
}