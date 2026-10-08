import 'package:cliniq_final_project/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/register_entity/register_entity.dart';
import 'package:cliniq_final_project/features/auth/domain/entities/register_entity/register_params.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Domain Entities Tests', () {
    test('UserEntity should support value equality', () {
      const user1 = UserEntity(
        id: '1',
        firstName: 'Ahmed',
        lastName: 'Ali',
        email: 'ahmed@test.com',
        phone: '01012345678',
        gender: 'male',
      );

      const user2 = UserEntity(
        id: '1',
        firstName: 'Ahmed',
        lastName: 'Ali',
        email: 'ahmed@test.com',
        phone: '01012345678',
        gender: 'male',
      );

      const user3 = UserEntity(
        id: '2',
        firstName: 'Sara',
        lastName: 'Hassan',
        email: 'sara@test.com',
        phone: '01112345678',
        gender: 'female',
      );

      expect(user1, equals(user2));
      expect(user1 == user3, isFalse);
      expect(user1.props, [
        '1',
        'Ahmed',
        'Ali',
        'ahmed@test.com',
        '01012345678',
        'male',
      ]);
    });

    test('RegisterEntity should support value equality', () {
      const user = UserEntity(id: '1', firstName: 'Sara');
      const entity1 = RegisterEntity(
        message: 'Success',
        user: user,
        token: 'token123',
      );

      const entity2 = RegisterEntity(
        message: 'Success',
        user: user,
        token: 'token123',
      );

      const entity3 = RegisterEntity(message: 'Failed');

      expect(entity1, equals(entity2));
      expect(entity1 == entity3, isFalse);
      expect(entity1.props, ['Success', user, 'token123']);
    });

    test('RegisterParams should support value equality', () {
      const params1 = RegisterParams(
        firstName: 'Sara',
        lastName: 'Mohamed',
        email: 'sara@test.com',
        password: 'Password@123',
        confirmPassword: 'Password@123',
        phone: '01098765432',
        gender: 'Female',
      );

      const params2 = RegisterParams(
        firstName: 'Sara',
        lastName: 'Mohamed',
        email: 'sara@test.com',
        password: 'Password@123',
        confirmPassword: 'Password@123',
        phone: '01098765432',
        gender: 'Female',
      );

      const params3 = RegisterParams(
        firstName: 'Ali',
        lastName: 'Mohamed',
        email: 'ali@test.com',
        password: 'Password@123',
        confirmPassword: 'Password@123',
        phone: '01098765432',
        gender: 'Male',
      );

      expect(params1, equals(params2));
      expect(params1 == params3, isFalse);
      expect(params1.props, [
        'Sara',
        'Mohamed',
        'sara@test.com',
        'Password@123',
        'Password@123',
        '01098765432',
        'Female',
      ]);
    });
  });
}
