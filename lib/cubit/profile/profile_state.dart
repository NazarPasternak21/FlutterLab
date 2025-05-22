import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String email;
  final double temperature;
  final String reminderTime;

  const ProfileState({
    required this.email,
    required this.temperature,
    required this.reminderTime,
  });

  ProfileState copyWith({
    String? email,
    double? temperature,
    String? reminderTime,
  }) {
    return ProfileState(
      email: email ?? this.email,
      temperature: temperature ?? this.temperature,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }

  @override
  List<Object?> get props => [email, temperature, reminderTime];
}
