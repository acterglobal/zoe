import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/toolkit/zoe_popup_menu_widget.dart';

import '../../../test-utils/test_utils.dart';

/// Test utilities for ZoePopupMenu widget tests
class ZoePopupMenuTestUtils {
  /// Creates a test menu item
  static ZoePopupMenuItem createTestMenuItem({
    String id = 'test_item',
    IconData icon = Icons.close,
    String title = 'Test Title',
    String subtitle = 'Test Subtitle',
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return ZoePopupMenuItem(
      id: id,
      icon: icon,
      title: title,
      subtitle: subtitle,
      isDestructive: isDestructive,
      onTap: onTap,
    );
  }

  /// Creates a list of test menu items
  static List<ZoePopupMenuItem> createTestMenuItems({
    int count = 3,
    bool includeCallbacks = true,
  }) {
    return List.generate(count, (index) {
      return createTestMenuItem(
        id: 'item_$index',
        title: 'Item $index',
        subtitle: 'Subtitle $index',
        onTap: includeCallbacks ? () {} : null,
      );
    });
  }
}

void main() {
  group('ZoePopupMenuItem Tests -', () {
    test('creates with required properties', () {
      final item = ZoePopupMenuTestUtils.createTestMenuItem();

      expect(item.id, equals('test_item'));
      expect(item.icon, equals(Icons.close));
      expect(item.title, equals('Test Title'));
      expect(item.subtitle, equals('Test Subtitle'));
      expect(item.isDestructive, isFalse);
      expect(item.onTap, isNull);
    });

    test('creates with custom properties', () {
      bool wasTapped = false;
      final item = ZoePopupMenuTestUtils.createTestMenuItem(
        id: 'custom_id',
        icon: Icons.add,
        title: 'Custom Title',
        subtitle: 'Custom Subtitle',
        isDestructive: true,
        onTap: () => wasTapped = true,
      );

      expect(item.id, equals('custom_id'));
      expect(item.icon, equals(Icons.add));
      expect(item.title, equals('Custom Title'));
      expect(item.subtitle, equals('Custom Subtitle'));
      expect(item.isDestructive, isTrue);

      item.onTap?.call();
      expect(wasTapped, isTrue);
    });
  });

  group('ZoeCommonMenuItems Tests -', () {
    test('creates connect menu item correctly', () {
      bool wasTapped = false;
      final item = ZoeCommonMenuItems.connect(
        onTapConnect: () => wasTapped = true,
        title: 'Custom Connect',
        subtitle: 'Custom Connect Subtitle',
      );

      expect(item.id, equals('connect'));
      expect(item.icon, equals(Icons.link_rounded));
      expect(item.title, equals('Custom Connect'));
      expect(item.subtitle, equals('Custom Connect Subtitle'));
      expect(item.isDestructive, isFalse);

      item.onTap?.call();
      expect(wasTapped, isTrue);
    });

    test('creates copy menu item correctly', () {
      final item = ZoeCommonMenuItems.copy();

      expect(item.id, equals('copy'));
      expect(item.icon, equals(Icons.copy_rounded));
      expect(item.title, equals('Copy'));
      expect(item.subtitle, equals('Copy content to clipboard'));
      expect(item.isDestructive, isFalse);
    });

    test('creates share menu item correctly', () {
      final item = ZoeCommonMenuItems.share();

      expect(item.id, equals('share'));
      expect(item.icon, equals(Icons.share_rounded));
      expect(item.title, equals('Share'));
      expect(item.subtitle, equals('Share this content'));
      expect(item.isDestructive, isFalse);
    });

    test('creates edit menu item correctly', () {
      final item = ZoeCommonMenuItems.edit();

      expect(item.id, equals('edit'));
      expect(item.icon, equals(Icons.edit_rounded));
      expect(item.title, equals('Edit'));
      expect(item.subtitle, equals('Edit this content'));
      expect(item.isDestructive, isFalse);
    });

    test('creates delete menu item correctly', () {
      final item = ZoeCommonMenuItems.delete();

      expect(item.id, equals('delete'));
      expect(item.icon, equals(Icons.delete_rounded));
      expect(item.title, equals('Delete'));
      expect(item.subtitle, equals('Delete this content'));
      expect(item.isDestructive, isTrue);
    });

    test('creates chooseTheme menu item correctly', () {
      bool wasTapped = false;
      final item = ZoeCommonMenuItems.chooseTheme(
        onTapChooseTheme: () => wasTapped = true,
        title: 'Choose theme',
        subtitle: 'Choose a theme for this sheet',
      );

      expect(item.id, equals('choose_theme'));
      expect(item.icon, equals(Icons.color_lens));
      expect(item.title, equals('Choose theme'));
      expect(item.subtitle, equals('Choose a theme for this sheet'));
      expect(item.isDestructive, isFalse);

      item.onTap?.call();
      expect(wasTapped, isTrue);
    });
  });

  group('ZoePopupMenuWidget Tests -', () {
    testWidgets('renders menu items correctly', (tester) async {
      final items = ZoePopupMenuTestUtils.createTestMenuItems();

      await tester.pumpMaterialWidget(
        child: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () {
                ZoePopupMenuWidget.show(context: context, items: items);
              },
              child: const Text('Show Menu'),
            );
          },
        ),
      );

      // Tap the button to show the menu
      await tester.tap(find.text('Show Menu'));
      await tester.pumpAndSettle();

      // Verify menu items are rendered
      for (var i = 0; i < items.length; i++) {
        expect(find.text('Item $i'), findsOneWidget);
        expect(find.text('Subtitle $i'), findsOneWidget);
      }
    });

    testWidgets('handles item tap correctly', (tester) async {
      bool wasTapped = false;
      final items = [
        ZoePopupMenuTestUtils.createTestMenuItem(onTap: () => wasTapped = true),
      ];

      await tester.pumpMaterialWidget(
        child: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () {
                ZoePopupMenuWidget.show(context: context, items: items);
              },
              child: const Text('Show Menu'),
            );
          },
        ),
      );

      // Tap the button to show the menu
      await tester.tap(find.text('Show Menu'));
      await tester.pumpAndSettle();

      // Tap the menu item
      await tester.tap(find.text('Test Title'));
      await tester.pumpAndSettle();

      expect(wasTapped, isTrue);
    });

    testWidgets('applies custom style correctly', (tester) async {
      final items = ZoePopupMenuTestUtils.createTestMenuItems();

      await tester.pumpMaterialWidget(
        child: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () {
                ZoePopupMenuWidget.show(
                  context: context,
                  items: items,
                  elevation: 20,
                  shadowColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                );
              },
              child: const Text('Show Menu'),
            );
          },
        ),
      );

      // Tap the button to show the menu
      await tester.tap(find.text('Show Menu'));
      await tester.pumpAndSettle();

      // Verify menu items are rendered (which means the menu was shown with the custom style)
      for (var i = 0; i < items.length; i++) {
        expect(find.text('Item $i'), findsOneWidget);
        expect(find.text('Subtitle $i'), findsOneWidget);
      }
    });
    testWidgets('applies menuIconColor correctly for non-destructive items', (
      tester,
    ) async {
      const customMenuIconColor = Colors.purple;

      final items = [
        ZoePopupMenuItem(
          id: 'theme',
          icon: Icons.color_lens,
          title: 'Choose Theme',
          subtitle: 'Pick a theme',
          isDestructive: false,
          onTap: () {},
        ),
      ];

      await tester.pumpMaterialWidget(
        child: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () {
                ZoePopupMenuWidget.show(
                  context: context,
                  items: items,
                  menuIconColor: customMenuIconColor,
                );
              },
              child: const Text('Show Menu'),
            );
          },
        ),
      );

      // Tap to show menu
      await tester.tap(find.text('Show Menu'));
      await tester.pumpAndSettle();

      // Find the icon
      final icon = tester.widget<Icon>(find.byIcon(Icons.color_lens));

      // Verify color applied correctly
      expect(icon.color, equals(customMenuIconColor));
    });

    testWidgets(
      'destructive items override menuIconColor and use error color',
      (tester) async {
        const customMenuIconColor = Colors.green;

        final items = [
          ZoePopupMenuItem(
            id: 'delete',
            icon: Icons.delete,
            title: 'Delete',
            subtitle: 'Remove item',
            isDestructive: true,
            onTap: () {},
          ),
        ];

        await tester.pumpMaterialWidget(
          child: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  ZoePopupMenuWidget.show(
                    context: context,
                    items: items,
                    menuIconColor: customMenuIconColor,
                  );
                },
                child: const Text('Show Menu'),
              );
            },
          ),
        );

        // Tap to show menu
        await tester.tap(find.text('Show Menu'));
        await tester.pumpAndSettle();

        final context = tester.element(find.byIcon(Icons.delete));
        final errorColor = Theme.of(context).colorScheme.error;

        final icon = tester.widget<Icon>(find.byIcon(Icons.delete));

        expect(
          icon.color,
          equals(errorColor),
        ); // MUST NOT equal customMenuIconColor
        expect(icon.color == customMenuIconColor, isFalse);
      },
    );
  });
}
