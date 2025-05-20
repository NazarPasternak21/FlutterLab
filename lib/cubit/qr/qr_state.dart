import 'package:equatable/equatable.dart';

abstract class QRState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QRInitial extends QRState {}

class QRLoading extends QRState {}

class QRSuccess extends QRState {
  final String data;
  QRSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class QRFailure extends QRState {
  final String error;
  QRFailure(this.error);

  @override
  List<Object?> get props => [error];
}