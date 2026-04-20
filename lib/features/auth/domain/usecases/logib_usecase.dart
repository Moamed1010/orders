import 'package:dartz/dartz.dart';
import 'package:orders/core/error/failures.dart';

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  // بنستقبل الـ Repository عن طريق الـ Constructor عشان الـ Dependency Injection
  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(email: email, password: password);
  }
}