import 'package:dartz/dartz.dart';
import 'package:orders/core/error/failures.dart';
import 'package:orders/features/auth/data/dataScources/auth_remote_data_scource.dart';
import 'package:orders/features/auth/domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(userModel); // هنا بنرجع الـ Right (النجاح)
    } catch (e) {
      return Left(
        ServerFailure(e.toString().replaceAll('Exception: ', '')),
      ); // هنا بنرجع الـ Left (الخطأ)
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );
      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
