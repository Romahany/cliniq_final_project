import 'package:cliniq_final_project/config/base/base_state.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:cliniq_final_project/features/auth/presentation/login/manager/login_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginState', () {
    test('default initial state has correct defaults', () {
      const state = LoginState();

      expect(state.loginState.isLoading, isFalse);
      expect(state.loginState.errorMessage, isEmpty);
      expect(state.loginState.data, isNull);
      expect(state.isPasswordVisible, isFalse);
      expect(state.rememberMe, isFalse);
      expect(state.props, [const BaseState<LoginEntity>(), false, false]);
    });

    test('copyWith updates specified fields and preserves other fields', () {
      const state = LoginState();
      const user = UserEntity(id: '1', email: 'test@cliniq.com');
      const loginEntity = LoginEntity(user: user, token: 'token');

      final updatedState = state.copyWith(
        loginState: const BaseState<LoginEntity>(
          isLoading: true,
          errorMessage: 'Error message',
          data: loginEntity,
        ),
        isPasswordVisible: true,
        rememberMe: true,
      );

      expect(updatedState.loginState.isLoading, isTrue);
      expect(updatedState.loginState.errorMessage, 'Error message');
      expect(updatedState.loginState.data, equals(loginEntity));
      expect(updatedState.isPasswordVisible, isTrue);
      expect(updatedState.rememberMe, isTrue);

      // copyWith with no args returns identical state values
      final unchangedState = updatedState.copyWith();
      expect(unchangedState, equals(updatedState));
    });
  });
}
