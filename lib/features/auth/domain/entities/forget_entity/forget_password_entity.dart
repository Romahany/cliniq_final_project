import 'package:equatable/equatable.dart';

class ForgetPasswordEntity extends Equatable {
  final String message;
  final bool isSuccess;

  const ForgetPasswordEntity({required this.message, this.isSuccess = true});

  @override
  List<Object?> get props => [message, isSuccess];
}
