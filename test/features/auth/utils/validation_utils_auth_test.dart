import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/utils/validation_utils.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('ValidationUtils - Auth', () {
    group('validateName', () {
      testWidgets('returns null for valid names', (tester) async {
        await tester.pumpMaterialWidget(
          child: Container(),
        );
        final context = tester.element(find.byType(Container));

        expect(ValidationUtils.validateName(context, 'John Doe'), isNull);
        expect(ValidationUtils.validateName(context, 'Alice'), isNull);
        expect(ValidationUtils.validateName(context, 'Test User 123'), isNull);
      });

      testWidgets('returns error for empty names', (tester) async {
        await tester.pumpMaterialWidget(
          child: Container(),
        );
        final context = tester.element(find.byType(Container));

        expect(ValidationUtils.validateName(context, ''), isNotNull);
        expect(ValidationUtils.validateName(context, null), isNotNull);
      });

      testWidgets('handles special characters in names', (tester) async {
        await tester.pumpMaterialWidget(
          child: Container(),
        );
        final context = tester.element(find.byType(Container));

        expect(ValidationUtils.validateName(context, 'José María'), isNull);
        expect(ValidationUtils.validateName(context, '李小明'), isNull);
      });
    });

    group('validateEmail', () {
      testWidgets('returns null for valid emails', (tester) async {
        await tester.pumpMaterialWidget(child: Container());
        final context = tester.element(find.byType(Container));

        expect(
          ValidationUtils.validateEmail(context, 'test@example.com'),
          isNull,
        );
        expect(
          ValidationUtils.validateEmail(context, 'user.name@domain.co.uk'),
          isNull,
        );
        expect(
          ValidationUtils.validateEmail(context, 'test+tag@example.com'),
          isNull,
        );
      });

      testWidgets('returns error for invalid emails', (tester) async {
        await tester.pumpMaterialWidget(child: Container());
        final context = tester.element(find.byType(Container));

        expect(ValidationUtils.validateEmail(context, ''), isNotNull);
        expect(ValidationUtils.validateEmail(context, null), isNotNull);
        expect(ValidationUtils.validateEmail(context, 'notanemail'), isNotNull);
        expect(ValidationUtils.validateEmail(context, '@example.com'), isNotNull);
        expect(ValidationUtils.validateEmail(context, 'test@'), isNotNull);
      });

      testWidgets('handles edge cases', (tester) async {
        await tester.pumpMaterialWidget(child: Container());
        final context = tester.element(find.byType(Container));

        expect(
          ValidationUtils.validateEmail(context, 'a@b.co'),
          isNull,
        );
        expect(
          ValidationUtils.validateEmail(context, 'test..email@example.com'),
          isNull,
        );
      });
    });

    group('validatePassword', () {
      testWidgets('returns null for valid passwords', (tester) async {
        await tester.pumpMaterialWidget(child: Container());
        final context = tester.element(find.byType(Container));

        expect(ValidationUtils.validatePassword(context, '123456'), isNull);
        expect(
          ValidationUtils.validatePassword(context, 'password123'),
          isNull,
        );
        expect(
          ValidationUtils.validatePassword(context, 'P@ssw0rd!'),
          isNull,
        );
      });

      testWidgets('returns error for invalid passwords', (tester) async {
        await tester.pumpMaterialWidget(child: Container());
        final context = tester.element(find.byType(Container));

        expect(ValidationUtils.validatePassword(context, ''), isNotNull);
        expect(ValidationUtils.validatePassword(context, null), isNotNull);
        expect(ValidationUtils.validatePassword(context, '12345'), isNotNull);
        expect(ValidationUtils.validatePassword(context, 'abc'), isNotNull);
      });

      testWidgets('enforces minimum length of 6 characters', (tester) async {
        await tester.pumpMaterialWidget(child: Container());
        final context = tester.element(find.byType(Container));

        expect(ValidationUtils.validatePassword(context, '12345'), isNotNull);
        expect(ValidationUtils.validatePassword(context, '123456'), isNull);
        expect(ValidationUtils.validatePassword(context, '1234567'), isNull);
      });
    });

    group('validateConfirmPassword', () {
      testWidgets('returns null when passwords match', (tester) async {
        await tester.pumpMaterialWidget(child: Container());
        final context = tester.element(find.byType(Container));

        expect(
          ValidationUtils.validateConfirmPassword(
            context,
            'password123',
            'password123',
          ),
          isNull,
        );
        expect(
          ValidationUtils.validateConfirmPassword(
            context,
            'P@ssw0rd!',
            'P@ssw0rd!',
          ),
          isNull,
        );
      });

      testWidgets('returns error when passwords do not match', (tester) async {
        await tester.pumpMaterialWidget(child: Container());
        final context = tester.element(find.byType(Container));

        expect(
          ValidationUtils.validateConfirmPassword(
            context,
            'password123',
            'password456',
          ),
          isNotNull,
        );
        expect(
          ValidationUtils.validateConfirmPassword(
            context,
            'P@ssw0rd!',
            'P@ssw0rd',
          ),
          isNotNull,
        );
      });

      testWidgets('returns error for empty confirm password', (tester) async {
        await tester.pumpMaterialWidget(child: Container());
        final context = tester.element(find.byType(Container));

        expect(
          ValidationUtils.validateConfirmPassword(context, '', 'password123'),
          isNotNull,
        );
        expect(
          ValidationUtils.validateConfirmPassword(context, null, 'password123'),
          isNotNull,
        );
      });

      testWidgets('is case-sensitive', (tester) async {
        await tester.pumpMaterialWidget(child: Container());
        final context = tester.element(find.byType(Container));

        expect(
          ValidationUtils.validateConfirmPassword(
            context,
            'Password',
            'password',
          ),
          isNotNull,
        );
      });
    });

    group('Edge Cases', () {
      testWidgets('handles whitespace in passwords', (tester) async {
        await tester.pumpMaterialWidget(child: Container());
        final context = tester.element(find.byType(Container));

        expect(
          ValidationUtils.validatePassword(context, '   123456   '),
          isNull,
        );
        expect(
          ValidationUtils.validateConfirmPassword(
            context,
            '   123456   ',
            '   123456   ',
          ),
          isNull,
        );
      });

      testWidgets('handles special characters in emails', (tester) async {
        await tester.pumpMaterialWidget(child: Container());
        final context = tester.element(find.byType(Container));

        expect(
          ValidationUtils.validateEmail(context, 'test+tag@example.com'),
          isNull,
        );
        expect(
          ValidationUtils.validateEmail(context, 'test_user@example.com'),
          isNull,
        );
      });
    });
  });
} 
 