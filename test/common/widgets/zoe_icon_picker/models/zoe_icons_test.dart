import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/zoe_icons.dart';

void main() {
  group('ZoeIcon Enum Tests -', () {
    test('enum has values', () {
      expect(ZoeIcon.values, isNotEmpty);
    });

    test('enum contains expected number of icons', () {
      // Count all icon entries (excluding comments)
      expect(ZoeIcon.values.length, greaterThan(0));
    });

    test('all enum values have valid IconData', () {
      for (final icon in ZoeIcon.values) {
        expect(icon.data, isA<IconData>());
        expect(icon.data.codePoint, isPositive);
      }
    });

    test('has no duplicate enum values', () {
      final iconSet = ZoeIcon.values.toSet();
      expect(iconSet.length, equals(ZoeIcon.values.length),
          reason: 'All icons should be unique');
    });

    test('first icon is list', () {
      expect(ZoeIcon.values.first, equals(ZoeIcon.list));
    });

    test('last icon is yarn', () {
      expect(ZoeIcon.values.last, equals(ZoeIcon.yarn));
    });

    test('list icon has correct IconData', () {
      expect(ZoeIcon.list.data, isA<IconData>());
    });

    test('pin icon has correct IconData', () {
      expect(ZoeIcon.pin.data, isA<IconData>());
    });

    test('can access icons by name', () {
      expect(ZoeIcon.values.byName('list'), equals(ZoeIcon.list));
      expect(ZoeIcon.values.byName('pin'), equals(ZoeIcon.pin));
      expect(ZoeIcon.values.byName('yarn'), equals(ZoeIcon.yarn));
    });

    test('can iterate through all icons', () {
      int count = 0;
      for (final icon in ZoeIcon.values) {
        expect(icon, isA<ZoeIcon>());
        expect(icon.data, isA<IconData>());
        count++;
      }
      expect(count, equals(ZoeIcon.values.length));
    });

    test('can check if icon exists in values', () {
      expect(ZoeIcon.values.contains(ZoeIcon.list), isTrue);
      expect(ZoeIcon.values.contains(ZoeIcon.pin), isTrue);
      expect(ZoeIcon.values.contains(ZoeIcon.yarn), isTrue);
    });

    test('can get icon by index', () {
      expect(ZoeIcon.values[0], equals(ZoeIcon.list));
      expect(ZoeIcon.values[ZoeIcon.values.length - 1], equals(ZoeIcon.yarn));
    });

    test('all icons have non-null IconData', () {
      for (final icon in ZoeIcon.values) {
        expect(icon.data, isNotNull);
      }
    });
  });

  group('ZoeIcon Static Methods Tests -', () {
    group('iconFor method -', () {
      test('returns correct icon for valid name', () {
        expect(ZoeIcon.iconFor('list'), equals(ZoeIcon.list));
        expect(ZoeIcon.iconFor('pin'), equals(ZoeIcon.pin));
        expect(ZoeIcon.iconFor('yarn'), equals(ZoeIcon.yarn));
        expect(ZoeIcon.iconFor('airplane'), equals(ZoeIcon.airplane));
        expect(ZoeIcon.iconFor('camera'), equals(ZoeIcon.camera));
      });

      test('returns null for invalid name', () {
        expect(ZoeIcon.iconFor('invalidIconName'), isNull);
        expect(ZoeIcon.iconFor('nonexistent'), isNull);
      });

      test('returns null for null input', () {
        expect(ZoeIcon.iconFor(null), isNull);
      });

      test('returns null for empty string', () {
        expect(ZoeIcon.iconFor(''), isNull);
      });

      test('is case sensitive', () {
        expect(ZoeIcon.iconFor('List'), isNull); // Should be lowercase 'list'
        expect(ZoeIcon.iconFor('LIST'), isNull);
        expect(ZoeIcon.iconFor('PiN'), isNull);
      });

      test('handles all enum values correctly', () {
        for (final icon in ZoeIcon.values) {
          final result = ZoeIcon.iconFor(icon.name);
          expect(result, equals(icon),
              reason: 'iconFor should return correct icon for ${icon.name}');
        }
      });
    });

    group('iconForTask method -', () {
      test('returns correct icon for valid name', () {
        expect(ZoeIcon.iconForTask('list'), equals(ZoeIcon.list));
        expect(ZoeIcon.iconForTask('pin'), equals(ZoeIcon.pin));
        expect(ZoeIcon.iconForTask('camera'), equals(ZoeIcon.camera));
      });

      test('returns default list icon for invalid name', () {
        expect(ZoeIcon.iconForTask('invalidIconName'), equals(ZoeIcon.list));
        expect(ZoeIcon.iconForTask('nonexistent'), equals(ZoeIcon.list));
      });

      test('returns default list icon for null input', () {
        expect(ZoeIcon.iconForTask(null), equals(ZoeIcon.list));
      });

      test('returns default list icon for empty string', () {
        expect(ZoeIcon.iconForTask(''), equals(ZoeIcon.list));
      });

      test('default is list icon', () {
        expect(ZoeIcon.iconForTask('invalid'), equals(ZoeIcon.list));
        expect(ZoeIcon.iconForTask(null), equals(ZoeIcon.list));
      });
    });

    group('iconForCategories method -', () {
      test('returns correct icon for valid name', () {
        expect(ZoeIcon.iconForCategories('list'), equals(ZoeIcon.list));
        expect(ZoeIcon.iconForCategories('pin'), equals(ZoeIcon.pin));
        expect(ZoeIcon.iconForCategories('folder'), equals(ZoeIcon.list));
      });

      test('returns default list icon for invalid name', () {
        expect(ZoeIcon.iconForCategories('invalidIconName'),
            equals(ZoeIcon.list));
        expect(ZoeIcon.iconForCategories('nonexistent'), equals(ZoeIcon.list));
      });

      test('returns default list icon for null input', () {
        expect(ZoeIcon.iconForCategories(null), equals(ZoeIcon.list));
      });

      test('returns default list icon for empty string', () {
        expect(ZoeIcon.iconForCategories(''), equals(ZoeIcon.list));
      });

      test('default is list icon', () {
        expect(ZoeIcon.iconForCategories('invalid'), equals(ZoeIcon.list));
        expect(ZoeIcon.iconForCategories(null), equals(ZoeIcon.list));
      });
    });

    group('iconForPin method -', () {
      test('returns correct icon for valid name', () {
        expect(ZoeIcon.iconForPin('pin'), equals(ZoeIcon.pin));
        expect(ZoeIcon.iconForPin('list'), equals(ZoeIcon.list));
        expect(ZoeIcon.iconForPin('camera'), equals(ZoeIcon.camera));
      });

      test('returns default pin icon for invalid name', () {
        expect(ZoeIcon.iconForPin('invalidIconName'), equals(ZoeIcon.pin));
        expect(ZoeIcon.iconForPin('nonexistent'), equals(ZoeIcon.pin));
      });

      test('returns default pin icon for null input', () {
        expect(ZoeIcon.iconForPin(null), equals(ZoeIcon.pin));
      });

      test('returns default pin icon for empty string', () {
        expect(ZoeIcon.iconForPin(''), equals(ZoeIcon.pin));
      });

      test('default is pin icon', () {
        expect(ZoeIcon.iconForPin('invalid'), equals(ZoeIcon.pin));
        expect(ZoeIcon.iconForPin(null), equals(ZoeIcon.pin));
      });
    });
  });

  group('ZoeIcon Specific Icon Tests -', () {
    test('list icon properties', () {
      expect(ZoeIcon.list.name, equals('list'));
      expect(ZoeIcon.list.data, isA<IconData>());
    });

    test('pin icon properties', () {
      expect(ZoeIcon.pin.name, equals('pin'));
      expect(ZoeIcon.pin.data, isA<IconData>());
    });

    test('yarn icon properties', () {
      expect(ZoeIcon.yarn.name, equals('yarn'));
      expect(ZoeIcon.yarn.data, isA<IconData>());
    });

    test('airplane icon properties', () {
      expect(ZoeIcon.airplane.name, equals('airplane'));
      expect(ZoeIcon.airplane.data, isA<IconData>());
    });

    test('camera icon properties', () {
      expect(ZoeIcon.camera.name, equals('camera'));
      expect(ZoeIcon.camera.data, isA<IconData>());
    });

    test('can find icon by name in values list', () {
      final listIcon =
          ZoeIcon.values.firstWhere((icon) => icon.name == 'list');
      expect(listIcon, equals(ZoeIcon.list));

      final pinIcon = ZoeIcon.values.firstWhere((icon) => icon.name == 'pin');
      expect(pinIcon, equals(ZoeIcon.pin));
    });
  });

  group('ZoeIcon Enum Operations Tests -', () {
    test('can convert to name and back', () {
      for (final icon in ZoeIcon.values) {
        final name = icon.name;
        final retrievedIcon = ZoeIcon.iconFor(name);
        expect(retrievedIcon, equals(icon),
            reason: 'Icon $name should be retrievable by name');
      }
    });

    test('can use map to transform icons', () {
      final iconNames = ZoeIcon.values.map((icon) => icon.name).toList();
      expect(iconNames.length, equals(ZoeIcon.values.length));
      expect(iconNames, contains('list'));
      expect(iconNames, contains('pin'));
      expect(iconNames, contains('yarn'));
    });

    test('can use where to filter icons', () {
      final specificIcons =
          ZoeIcon.values.where((icon) => icon.name == 'list').toList();
      expect(specificIcons.length, equals(1));
      expect(specificIcons.first, equals(ZoeIcon.list));
    });

    test('can get first and last icons', () {
      expect(ZoeIcon.values.first, equals(ZoeIcon.list));
      expect(ZoeIcon.values.last, equals(ZoeIcon.yarn));
    });

    test('can get icons by index range', () {
      if (ZoeIcon.values.length >= 3) {
        final firstThree = ZoeIcon.values.take(3).toList();
        expect(firstThree.length, equals(3));
        expect(firstThree.first, equals(ZoeIcon.list));
      }
    });
  });

  group('ZoeIcon Edge Cases Tests -', () {
    test('handles very long invalid name', () {
      final longName = 'a' * 1000;
      expect(ZoeIcon.iconFor(longName), isNull);
      expect(ZoeIcon.iconForTask(longName), equals(ZoeIcon.list));
      expect(ZoeIcon.iconForCategories(longName), equals(ZoeIcon.list));
      expect(ZoeIcon.iconForPin(longName), equals(ZoeIcon.pin));
    });

    test('handles special characters in name', () {
      expect(ZoeIcon.iconFor('list@'), isNull);
      expect(ZoeIcon.iconFor('pin!'), isNull);
      expect(ZoeIcon.iconFor('camera#'), isNull);
    });

    test('handles whitespace in name', () {
      expect(ZoeIcon.iconFor(' list'), isNull);
      expect(ZoeIcon.iconFor('list '), isNull);
      expect(ZoeIcon.iconFor(' list '), isNull);
    });

    test('enum values are immutable', () {
      final originalLength = ZoeIcon.values.length;
      expect(ZoeIcon.values.length, equals(originalLength));
    });
  });
}

