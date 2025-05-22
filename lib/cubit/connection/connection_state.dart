import 'package:equatable/equatable.dart';

abstract class InternetState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InternetInitial extends InternetState {}

class InternetSuccess extends InternetState {}

class InternetFailure extends InternetState {}