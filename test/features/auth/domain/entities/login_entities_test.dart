import 'package:cliniq_final_project/features/auth/domain/entities/login_entity/login_credentials.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Login Domain Entities', () {
    test('LoginCredentials supports equality and value comparisons', () {
      const creds1 = LoginCredentials(
        email: 'test@cliniq.com',
        password: 'password123',
        rememberMe: true,
      );
      const creds2 = LoginCredentials(
        email: 'test@cliniq.com',
        password: 'password123',
        rememberMe: true,
      );
      const creds3 = LoginCredentials(
        email: 'other@cliniq.com',
        password: 'password123',
        rememberMe: false,
      );

      expect(creds1, equals(creds2));
      expect(creds1, isNot(equals(creds3)));
      expect(creds1.props, ['test@cliniq.com', 'password123', true]);
    });

    test('UserEntity supports equality and props', () {
      const user1 = UserEntity(
        id: 'user_1',
        email: 'user@cliniq.com',
        firstName: 'John',
        lastName: 'Doe',
        phone: '01012345678',
      );
      const user2 = UserEntity(
        id: 'user_1',
        email: 'user@cliniq.com',
        firstName: 'John',
        lastName: 'Doe',
        phone: '01012345678',
      );
      const user3 = UserEntity(id: 'user_2', email: 'other@cliniq.com');

      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
      expect(user1.props, [
        'user_1',
        'user@cliniq.com',
        'John',
        'Doe',
        '01012345678',
      ]);
    });

    test('LoginEntity holds user and tokens and supports equality', () {
      const user = UserEntity(id: 'user_1', email: 'user@cliniq.com');
      const entity1 = LoginEntity(
        user: user,
        token: 'access_jwt',
        refreshToken: 'refresh_jwt',
      );
      const entity2 = LoginEntity(
        user: user,
        token: 'access_jwt',
        refreshToken: 'refresh_jwt',
      );
      const entity3 = LoginEntity(user: user, token: 'different_jwt');

      expect(entity1, equals(entity2));
      expect(entity1, isNot(equals(entity3)));
      expect(entity1.props, [user, 'access_jwt', 'refresh_jwt']);
    });
  });
}
