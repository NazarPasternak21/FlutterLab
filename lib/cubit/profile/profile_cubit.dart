import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/profile/profile_state.dart';
import 'package:my_project/services/local_auth_repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final LocalAuthRepository _repo = LocalAuthRepository();

  ProfileCubit() : super(const ProfileState(email: "", temperature: 37.0, reminderTime: "08:00"));

  Future<void> setEmail(String email) async {
    final temp = await _repo.getUserTemperature(email);
    final time = await _repo.getUserReminderTime(email);
    emit(state.copyWith(email: email, temperature: temp, reminderTime: time));
  }

  Future<void> setTemperature(double temp) async {
    if (state.email.isEmpty) return;
    await _repo.setUserTemperature(state.email, temp);
    emit(state.copyWith(temperature: temp));
  }

  Future<void> setReminderTime(String time) async {
    if (state.email.isEmpty) return;
    await _repo.setUserReminderTime(state.email, time);
    emit(state.copyWith(reminderTime: time));
  }
}
