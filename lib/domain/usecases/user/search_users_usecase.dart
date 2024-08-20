// lib/domain/usecases/user/search_users_usecase.dart
import '../../../data/repositories/user_repository.dart';
import '../../../data/models/user.dart';

class SearchUsersUseCase {
  final UserRepository repository;

  SearchUsersUseCase(this.repository);

  Future<List<User>> execute(String query) async {
    return await repository.searchUsers(query);
  }
}