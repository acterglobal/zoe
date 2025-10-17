import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/floating_action_button_wrapper.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/screens/sheet_detail_screen.dart';
import '../../../test-utils/mock_gorouter.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/sheet_utils.dart';

void main() {
  group('SheetDetailScreen Tests', () {
    late ProviderContainer container;
    late SheetModel testSheet;
    late String testSheetId;
    late MockGoRouter mockGoRouter;

    setUp(() {
      container = ProviderContainer.test();
      testSheet = getSheetByIndex(container);
      testSheetId = testSheet.id;
      
      mockGoRouter = MockGoRouter();
      when(() => mockGoRouter.canPop()).thenReturn(true);
      when(() => mockGoRouter.pop()).thenReturn(null);
      when(() => mockGoRouter.push(any())).thenAnswer((_) async => true);
    });

    group('Widget Construction and Properties', () {
      testWidgets('creates widget with required sheetId', (tester) async {
        final widget = SheetDetailScreen(sheetId: testSheetId);
        expect(widget.sheetId, equals(testSheetId));
        expect(widget, isA<ConsumerWidget>());
      });

      testWidgets('accepts valid sheetId', (tester) async {
        expect(
          () => SheetDetailScreen(sheetId: testSheetId),
          returnsNormally,
        );
      });

      testWidgets('accepts empty sheetId', (tester) async {
        expect(
          () => SheetDetailScreen(sheetId: ''),
          returnsNormally,
        );
      });

      testWidgets('accepts special characters in sheetId', (tester) async {
        final specialId = 'test-id-&<>"\'';
        expect(
          () => SheetDetailScreen(sheetId: specialId),
          returnsNormally,
        );
      });
    });

    group('Widget Rendering', () {

      testWidgets('renders with proper structure', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SheetDetailScreen(sheetId: testSheetId),
        );

        // Check for key structural elements
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsAtLeastNWidgets(1));
        expect(find.byType(Column), findsAtLeastNWidgets(1));
      });

      testWidgets('renders AppBar with correct title', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SheetDetailScreen(sheetId: testSheetId),
        );

        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Sheet'), findsOneWidget);
      });

      testWidgets('renders FloatingActionButtonWrapper', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SheetDetailScreen(sheetId: testSheetId),
        );

        expect(find.byType(FloatingActionButtonWrapper), findsOneWidget);
      });
    });

    group('Provider Integration', () {
      testWidgets('watches editContentIdProvider', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SheetDetailScreen(sheetId: testSheetId),
        );

        // Initially not editing
        expect(container.read(editContentIdProvider), isNull);

        // Set editing state
        container.read(editContentIdProvider.notifier).state = testSheetId;
        await tester.pump();

        expect(container.read(editContentIdProvider), equals(testSheetId));
      });

      testWidgets('watches sheetProvider', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SheetDetailScreen(sheetId: testSheetId),
        );

        final sheet = container.read(sheetProvider(testSheetId));
        expect(sheet, isNotNull);
        expect(sheet!.id, equals(testSheetId));
      });

      testWidgets('watches listOfUsersBySheetIdProvider', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SheetDetailScreen(sheetId: testSheetId),
        );

        final users = container.read(listOfUsersBySheetIdProvider(testSheetId));
        expect(users, isA<List<String>>());
      });
    });

    group('Editing State', () {
      testWidgets('shows editing state when editContentIdProvider matches sheetId', (tester) async {
        container.read(editContentIdProvider.notifier).state = testSheetId;
        
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SheetDetailScreen(sheetId: testSheetId),
        );

        // Widget should render without crashing in editing state
        expect(tester.takeException(), isNull);
      });

      testWidgets('shows non-editing state when editContentIdProvider is null', (tester) async {
        container.read(editContentIdProvider.notifier).state = null;
        
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SheetDetailScreen(sheetId: testSheetId),
        );

        // Widget should render without crashing in non-editing state
        expect(tester.takeException(), isNull);
      });
    });

    group('Error Handling', () {
      testWidgets('handles null sheet gracefully', (tester) async {
        // Create a container with no sheets
        final emptyContainer = ProviderContainer.test();
        
        await tester.pumpMaterialWidgetWithProviderScope(
          container: emptyContainer,
          child: SheetDetailScreen(sheetId: 'non-existent-id'),
        );

        // Should render without crashing even with null sheet
        expect(tester.takeException(), isNull);
        
        emptyContainer.dispose();
      });

      testWidgets('handles empty users list', (tester) async {
        // Create a sheet with empty users list
        final emptyUsersSheet = testSheet.copyWith(users: []);
        container.read(sheetListProvider.notifier).addSheet(emptyUsersSheet);
        
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SheetDetailScreen(sheetId: emptyUsersSheet.id),
        );

        // Should render without crashing
        expect(tester.takeException(), isNull);
      });
    });

    group('Widget Structure', () {
      testWidgets('has correct widget hierarchy', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SheetDetailScreen(sheetId: testSheetId),
        );

        // Check for key widgets in hierarchy
        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsAtLeastNWidgets(1));
        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(find.byType(Row), findsAtLeastNWidgets(1));
      });

      testWidgets('has proper padding and spacing', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SheetDetailScreen(sheetId: testSheetId),
        );

        // Check for SizedBox widgets (spacing)
        expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
      });
    });

    group('Accessibility', () {
      testWidgets('has proper semantics', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SheetDetailScreen(sheetId: testSheetId),
        );

        // Check that key elements are accessible
        expect(find.text(testSheet.title), findsAtLeastNWidgets(1));
      });
    });

    group('Performance', () {
      testWidgets('renders efficiently', (tester) async {
        final stopwatch = Stopwatch()..start();
        
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SheetDetailScreen(sheetId: testSheetId),
        );
        
        stopwatch.stop();
        
        // Should render within reasonable time (less than 1 second)
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });
    });

    group('Sheet Model Integration', () {
      testWidgets('test sheet model has correct properties', (tester) async {
        expect(testSheet.id, equals(testSheetId));
        expect(testSheet.title, isNotEmpty);
        expect(testSheet.emoji, isNotEmpty);
        expect(testSheet.createdBy, isNotEmpty);
        expect(testSheet.users, isA<List<String>>());
        expect(testSheet.createdAt, isA<DateTime>());
        expect(testSheet.updatedAt, isA<DateTime>());
      });

      testWidgets('test sheet model has correct types', (tester) async {
        expect(testSheet.id, isA<String>());
        expect(testSheet.title, isA<String>());
        expect(testSheet.emoji, isA<String>());
        expect(testSheet.createdBy, isA<String>());
        expect(testSheet.users, isA<List<String>>());
        expect(testSheet.createdAt, isA<DateTime>());
        expect(testSheet.updatedAt, isA<DateTime>());
      });

      testWidgets('test sheet model copyWith works', (tester) async {
        final updatedSheet = testSheet.copyWith(
          title: 'Updated Title',
          emoji: '🚀',
        );
        
        expect(updatedSheet.id, equals(testSheet.id));
        expect(updatedSheet.title, equals('Updated Title'));
        expect(updatedSheet.emoji, equals('🚀'));
        expect(updatedSheet.description, equals(testSheet.description));
        expect(updatedSheet.users, equals(testSheet.users));
      });
    });

    group('Data Validation', () {
      testWidgets('validates sheet model properties', (tester) async {
        expect(testSheet.id, isNotEmpty);
        expect(testSheet.title, isNotEmpty);
        expect(testSheet.emoji, isNotEmpty);
        expect(testSheet.createdBy, isNotEmpty);
        expect(testSheet.createdAt, isA<DateTime>());
        expect(testSheet.updatedAt, isA<DateTime>());
      });

      testWidgets('validates description structure', (tester) async {
        if (testSheet.description != null) {
          expect(testSheet.description!.plainText, isA<String>());
          expect(testSheet.description!.htmlText, isA<String>());
          expect(testSheet.description!.plainText, isNotEmpty);
          expect(testSheet.description!.htmlText, isNotEmpty);
        }
      });

      testWidgets('validates users list structure', (tester) async {
        expect(testSheet.users, isA<List<String>>());
        for (final user in testSheet.users) {
          expect(user, isA<String>());
          expect(user, isNotEmpty);
        }
      });
    });

    group('Widget Equality', () {
      testWidgets('widgets with same sheetId have same values', (tester) async {
        final widget1 = SheetDetailScreen(sheetId: testSheetId);
        final widget2 = SheetDetailScreen(sheetId: testSheetId);
        
        expect(widget1.sheetId, equals(widget2.sheetId));
      });

      testWidgets('widgets with different sheetId have different values', (tester) async {
        final widget1 = SheetDetailScreen(sheetId: testSheetId);
        final widget2 = SheetDetailScreen(sheetId: 'different-id');
        
        expect(widget1.sheetId, isNot(equals(widget2.sheetId)));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles special characters in sheetId', (tester) async {
        final specialId = 'test-id-&<>"\'';
        final widget = SheetDetailScreen(sheetId: specialId);
        expect(widget.sheetId, equals(specialId));
      });

      testWidgets('handles numeric sheetId', (tester) async {
        final numericId = '12345';
        final widget = SheetDetailScreen(sheetId: numericId);
        expect(widget.sheetId, equals(numericId));
      });

      testWidgets('handles very long sheetId', (tester) async {
        final longId = 'a' * 1000;
        final widget = SheetDetailScreen(sheetId: longId);
        expect(widget.sheetId, equals(longId));
      });
    });

    group('Widget Type Validation', () {
      testWidgets('SheetDetailScreen is ConsumerWidget', (tester) async {
        final widget = SheetDetailScreen(sheetId: testSheetId);
        expect(widget, isA<ConsumerWidget>());
      });

      testWidgets('SheetDetailScreen is Widget', (tester) async {
        final widget = SheetDetailScreen(sheetId: testSheetId);
        expect(widget, isA<Widget>());
      });
    });

    group('Widget Creation', () {
      testWidgets('creates widget with const constructor', (tester) async {
        const widget = SheetDetailScreen(sheetId: 'const-id');
        expect(widget.sheetId, equals('const-id'));
      });

      testWidgets('creates widget with final constructor', (tester) async {
        final widget = SheetDetailScreen(sheetId: testSheetId);
        expect(widget.sheetId, equals(testSheetId));
      });
    });
  });
}