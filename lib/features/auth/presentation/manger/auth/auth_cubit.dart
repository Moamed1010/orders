import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:orders/features/auth/domain/entities/user_entity.dart';
import 'package:orders/features/auth/domain/usecases/logib_usecase.dart';
import 'package:orders/features/auth/domain/usecases/register_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  AuthCubit({required this.loginUseCase, required this.registerUseCase})
    : super(AuthInitial());
    Future<void> login({required String email, required String password}) async {
      emit(AuthLoading());
      final result = await loginUseCase(email: email, password: password);
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => emit(AuthSuccess(user)),
      );
    }
    Future<void> register({
      required String name,
      required String email,
      required String password,
    }) async {
      emit(AuthLoading());
      final result = await registerUseCase(
        name: name,
        email: email,
        password: password,
      );
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => emit(AuthSuccess(user)),
      );
    }
}
