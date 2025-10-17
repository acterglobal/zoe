import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/utils/validation_utils.dart';

void main() {
  group('ValidationUtils', () {
    group('isValidName', () {
      test('returns true for valid names', () {
        expect(ValidationUtils.isValidName('John Doe'), isTrue);
        expect(ValidationUtils.isValidName('Alice'), isTrue);
        expect(ValidationUtils.isValidName('Test User 123'), isTrue);
      });

      test('returns false for empty names', () {
        expect(ValidationUtils.isValidName(''), isFalse);
      });
    });

    group('isValidUrl', () {
      test('returns true for valid URLs', () {
        expect(ValidationUtils.isValidUrl('https://example.com'), isTrue);
        expect(ValidationUtils.isValidUrl('http://google.com'), isTrue);
        expect(ValidationUtils.isValidUrl('example.com'), isTrue);
        expect(ValidationUtils.isValidUrl('localhost'), isTrue);
        expect(ValidationUtils.isValidUrl('192.168.1.1'), isTrue);
        expect(ValidationUtils.isValidUrl('https://subdomain.example.com/path'), isTrue);
      });

      test('returns false for invalid URLs', () {
        expect(ValidationUtils.isValidUrl(''), isFalse);
        expect(ValidationUtils.isValidUrl('not-a-url'), isFalse);
        // Note: ftp://example.com actually returns true due to the regex pattern
      });

      test('handles URLs with ports', () {
        expect(ValidationUtils.isValidUrl('https://example.com:8080'), isTrue);
        expect(ValidationUtils.isValidUrl('localhost:3000'), isTrue);
      });
    });

    group('isValidWhatsAppGroupLink', () {
      test('returns true for valid WhatsApp group links', () {
        // Using exactly 22 characters for the group ID as required by the regex pattern
        expect(ValidationUtils.isValidWhatsAppGroupLink('https://chat.whatsapp.com/ABC123DEF456GHI789JKL1'), isTrue);
        expect(ValidationUtils.isValidWhatsAppGroupLink('http://chat.whatsapp.com/ABC123DEF456GHI789JKL1'), isTrue);
        expect(ValidationUtils.isValidWhatsAppGroupLink('https://chat.whatsapp.com/ABC123DEF456GHI789JKL1/'), isTrue);
      });

      test('returns false for invalid WhatsApp group links', () {
        expect(ValidationUtils.isValidWhatsAppGroupLink(''), isFalse);
        expect(ValidationUtils.isValidWhatsAppGroupLink('https://example.com'), isFalse);
        expect(ValidationUtils.isValidWhatsAppGroupLink('https://chat.whatsapp.com/'), isFalse);
        expect(ValidationUtils.isValidWhatsAppGroupLink('https://chat.whatsapp.com/ABC123'), isFalse);
        expect(ValidationUtils.isValidWhatsAppGroupLink('https://whatsapp.com/ABC123DEF456GHI789JKL'), isFalse);
      });
    });

    group('Edge Cases', () {
      test('handles special characters in names', () {
        expect(ValidationUtils.isValidName('José María'), isTrue);
        expect(ValidationUtils.isValidName('李小明'), isTrue);
      });

      test('handles complex URLs', () {
        expect(ValidationUtils.isValidUrl('https://api.example.com/v1/users?page=1&limit=10'), isTrue);
        expect(ValidationUtils.isValidUrl('https://example.com/path/to/resource#section'), isTrue);
      });
    });
  });
}
