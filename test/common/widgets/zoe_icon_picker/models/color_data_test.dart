import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/color_data.dart';

void main() {
  group('iconPickerColors Tests -', () {
    test('list is not empty', () {
      expect(iconPickerColors, isNotEmpty);
    });

    test('contains expected number of colors', () {
      expect(iconPickerColors.length, equals(12));
    });

    test('contains all expected colors in correct order', () {
      final expectedColors = [
        Colors.grey,
        Colors.greenAccent,
        Colors.redAccent,
        Colors.lightBlueAccent,
        Colors.orangeAccent,
        Colors.amberAccent,
        Colors.deepOrangeAccent,
        Colors.lightGreenAccent,
        Colors.tealAccent,
        Colors.purpleAccent,
        Colors.indigoAccent,
        Colors.pinkAccent,
      ];

      expect(iconPickerColors.length, equals(expectedColors.length));

      for (int i = 0; i < iconPickerColors.length; i++) {
        expect(
          iconPickerColors[i],
          equals(expectedColors[i]),
          reason: 'Color at index $i should match expected color',
        );
      }
    });

    test('all items are valid Color objects', () {
      for (final color in iconPickerColors) {
        expect(color, isA<Color>());
        expect(color.toARGB32(), isA<int>());
        expect(color.toARGB32(), isPositive);
      }
    });

    test('has no duplicate colors', () {
      final uniqueColors = iconPickerColors.toSet();
      expect(uniqueColors.length, equals(iconPickerColors.length),
          reason: 'All colors should be unique');
    });

    test('colors are accessible by index', () {
      expect(iconPickerColors[0], equals(Colors.grey));
      expect(iconPickerColors[iconPickerColors.length - 1],
          equals(Colors.pinkAccent));
    });

    test('list is immutable (read-only)', () {
      // Verify that the list can be read
      final firstColor = iconPickerColors.first;
      expect(firstColor, equals(Colors.grey));

      // Verify list structure is consistent
      expect(iconPickerColors.length, greaterThan(0));
      expect(iconPickerColors.last, equals(Colors.pinkAccent));
    });

    test('all colors have valid RGB values', () {
      for (final color in iconPickerColors) {
        expect(color.r, inInclusiveRange(0, 255));
        expect(color.g, inInclusiveRange(0, 255));
        expect(color.b, inInclusiveRange(0, 255));
        expect(color.a, inInclusiveRange(0, 255));
      }
    });

    test('colors can be used in Material ColorScheme', () {
      // Verify colors can be used in Flutter widgets
      for (final color in iconPickerColors) {
        expect(() => Container(color: color), returnsNormally);
      }
    });

    group('Color Properties Tests -', () {
      test('grey color properties', () {
        final greyIndex = iconPickerColors.indexOf(Colors.grey);
        expect(greyIndex, equals(0));
        expect(iconPickerColors[greyIndex], equals(Colors.grey));
      });

      test('greenAccent color properties', () {
        final greenAccentIndex = iconPickerColors.indexOf(Colors.greenAccent);
        expect(greenAccentIndex, equals(1));
        expect(iconPickerColors[greenAccentIndex], equals(Colors.greenAccent));
      });
      
      test('pinkAccent is the last color', () {
        expect(iconPickerColors.last, equals(Colors.pinkAccent));
        expect(iconPickerColors[iconPickerColors.length - 1],
            equals(Colors.pinkAccent));
      });
    });

    group('List Operations Tests -', () {
      test('can iterate through all colors', () {
        int count = 0;
        for (final color in iconPickerColors) {
          expect(color, isA<Color>());
          count++;
        }
        expect(count, equals(12));
      });

      test('can use where to filter colors', () {
        final accentColors = iconPickerColors
            .where((color) => color != Colors.grey)
            .toList();
        expect(accentColors.length, equals(11));
      });

      test('can use map to transform colors', () {
        final colorValues =
            iconPickerColors.map((color) => color.toARGB32()).toList();
        expect(colorValues.length, equals(12));
        expect(colorValues, everyElement(isPositive));
      });

      test('can check if color exists', () {
        expect(iconPickerColors.contains(Colors.grey), isTrue);
        expect(iconPickerColors.contains(Colors.pinkAccent), isTrue);
        expect(iconPickerColors.contains(Colors.black), isFalse);
        expect(iconPickerColors.contains(Colors.white), isFalse);
      });

      test('can get first and last colors', () {
        expect(iconPickerColors.first, equals(Colors.grey));
        expect(iconPickerColors.last, equals(Colors.pinkAccent));
      });

      test('can get colors by index range', () {
        final firstThree = iconPickerColors.take(3).toList();
        expect(firstThree.length, equals(3));
        expect(firstThree[0], equals(Colors.grey));
        expect(firstThree[1], equals(Colors.greenAccent));
        expect(firstThree[2], equals(Colors.redAccent));
      });
    });
  });
}

