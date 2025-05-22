import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/auth/auth_state.dart';
import 'package:my_project/services/local_auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final LocalAuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final isValid = await _authRepository.loginUser(email, password);
    if (isValid) {
      emit(AuthSuccess(email));
    } else {
      emit(AuthFailure("Невірний логін або пароль"));
    }
  }

  Future<void> register(String email, String password) async {
    emit(AuthLoading());
    final existingPassword = await _authRepository.getUserPassword(email);
    if (existingPassword != null) {
      emit(AuthFailure("Користувач з таким email вже існує"));
    } else {
      await _authRepository.registerUser(email, password);
      emit(AuthSuccess(email));
    }
  }

  Future<bool> autoLogin() async {
    final success = await _authRepository.tryAutoLogin();
    if (success) {
      final email = await _authRepository.getCurrentUserEmail();
      if (email != null) {
        emit(AuthSuccess(email));
        return true;
      }
    }
    emit(AuthInitial());
    return false;
  }


  Future<void> logout() async {
    await _authRepository.logoutUser();
    emit(AuthInitial());
  }
}
