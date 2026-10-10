import 'package:equatable/equatable.dart';

class VerifyOtpEntity extends Equatable {
  final String message;
  final bool isSuccess;
  final String? resetToken;

  const VerifyOtpEntity({
    required this.message,
    this.isSuccess = true,
    this.resetToken,
  });

  @override
  List<Object?> get props => [message, isSuccess, resetToken];
}
