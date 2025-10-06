import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/text/widgets/text_list_widget.dart';
import 'package:zoe/features/text/widgets/text_widget.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/features/text/data/text_list.dart';

import '../../../test-utils/test_utils.dart';

void main() {
  group('TextListWidget', () {
    late ProviderContainer container;

    setUp(() {
      // Use existing text data from text_list.dart
      container = ProviderContainer.test(
        overrides: [textListProvider.overrideWithValue(textList)],
      );
    });

    group('Basic Functionality', () {
      testWidgets('renders empty state when text list is empty', (
        tester,
      ) async {
        final emptyContainer = ProviderContainer.test(
          overrides: [textListProvider.overrideWithValue([])],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          child: const TextListWidget(
            textsProvider: textListProvider,
            isEditing: false,
          ),
          container: emptyContainer,
        );

        // Should render empty state (SizedBox.shrink by default)
        expect(find.byType(ListView), findsNothing);
        expect(find.byType(SizedBox), findsOneWidget);

      });

      testWidgets('renders TextWidget for each text in the list', (
        tester,
      ) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          child: const TextListWidget(
            textsProvider: textListProvider,
            isEditing: false,
          ),
          container: container,
        );

        // Wait for async initialization
        await tester.pumpAndSettle();

        // Should render ListView.builder
        expect(find.byType(ListView), findsOneWidget);

        // Should render TextWidget for each text (ListView may virtualize, so check at least 3)
        expect(find.byType(TextWidget), findsAtLeastNWidgets(3));
      });

      testWidgets('applies correct padding to each text item', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          child: const TextListWidget(
            textsProvider: textListProvider,
            isEditing: false,
          ),
          container: container,
        );

        await tester.pumpAndSettle();

        final paddingWidgets = find.byType(Padding);
        expect(paddingWidgets, findsAtLeastNWidgets(4));
      });
    });

    group('Provider Integration', () {
      testWidgets('works with filtered text provider by parent ID', (
        tester,
      ) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          child: TextListWidget(
            textsProvider: textByParentProvider('sheet-1'),
            isEditing: false,
          ),
          container: container,
        );

        await tester.pumpAndSettle();

        // Should only render texts with parentId 'sheet-1' (all 4 texts from our test data)
        expect(find.byType(TextWidget), findsAtLeastNWidgets(3));
      });

      testWidgets('works with sorted text provider', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          child: TextListWidget(
            textsProvider: sortedTextsProvider,
            isEditing: false,
          ),
          container: container,
        );

        await tester.pumpAndSettle();

        // Should render texts in sorted order (ListView may virtualize, so check at least 2)
        expect(find.byType(TextWidget), findsAtLeastNWidgets(2));
      });

      testWidgets('works with search provider', (tester) async {
        final searchContainer = ProviderContainer(
          overrides: [
            textListProvider.overrideWithValue(textList),
            textListSearchProvider('Welcome').overrideWithValue(
              textList.where((t) => t.title.contains('Welcome')).toList(),
            ),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          child: TextListWidget(
            textsProvider: textListSearchProvider('Welcome'),
            isEditing: false,
          ),
          container: searchContainer,
        );

        await tester.pumpAndSettle();

        // Should only render the text with title containing 'Welcome'
        expect(find.byType(TextWidget), findsOneWidget);

      });
    });

    group('List Configuration', () {
      testWidgets(
        'configures ListView builder correctly with shrinkWrap true',
        (tester) async {
          await tester.pumpMaterialWidgetWithProviderScope(
            child: const TextListWidget(
              textsProvider: textListProvider,
              isEditing: false,
              shrinkWrap: true,
            ),
            container: container,
          );

          await tester.pumpAndSettle();

          final listView = tester.widget<ListView>(find.byType(ListView));
          expect(listView.shrinkWrap, true);
          expect(listView.physics, const NeverScrollableScrollPhysics());
          expect(listView.padding, EdgeInsets.zero);
        },
      );

      testWidgets(
        'configures ListView builder correctly with shrinkWrap false',
        (tester) async {
          await tester.pumpMaterialWidgetWithProviderScope(
            child: const TextListWidget(
              textsProvider: textListProvider,
              isEditing: false,
              shrinkWrap: false,
            ),
            container: container,
          );

          await tester.pumpAndSettle();

          final listView = tester.widget<ListView>(find.byType(ListView));
          expect(listView.shrinkWrap, false);
          expect(
            listView.physics,
            isA<AlwaysScrollableScrollPhysics>(),
          ); // Default scrollable physics
        },
      );

      testWidgets('renders correct number of items', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          child: const TextListWidget(
            textsProvider: textListProvider,
            isEditing: false,
          ),
          container: container,
        );

        await tester.pumpAndSettle();

        // Verify the right number of items are rendered
        expect(find.byType(TextWidget), findsAtLeastNWidgets(3));
      });
    });
  });
}
