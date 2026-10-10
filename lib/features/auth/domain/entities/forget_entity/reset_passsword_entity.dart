import 'package:equatable/equatable.dart';

class ResetPasswordEntity extends Equatable {
  final String message;
  final bool isSuccess;

  const ResetPasswordEntity({required this.message, this.isSuccess = true});

  @override
  List<Object?> get props => [message, isSuccess];
}
