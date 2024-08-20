// lib/domain/usecases/user/update_user_usecase.dart
import '../../../data/repositories/user_repository.dart';
import '../../../data/models/user.dart';

class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  Future<bool> execute(User user) async {
    return await repository.updateUser(user);
  }
}