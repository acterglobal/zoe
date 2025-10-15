import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/display_sheet_name_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_close_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/events/data/event_list.dart';
import 'package:zoe/features/events/models/events_model.dart';
import 'package:zoe/features/events/providers/event_providers.dart';
import 'package:zoe/features/events/widgets/event_date_widget.dart';
import 'package:zoe/features/events/widgets/event_widget.dart';
import '../../../test-utils/mock_gorouter.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('EventWidget', () {
    late ProviderContainer container;
    late EventModel testEvent;

    setUp(() {
      container = ProviderContainer();
      testEvent = eventList.first;
    });

    Future<void> pumpEventWidget(
      WidgetTester tester, {
      required String eventId,
      GoRouter? router,
      bool showSheetName = true,
      EdgeInsetsGeometry? margin,
      List<EventModel>? overrideEvents,
      String? editId,
    }) async {
      final scopedContainer = (overrideEvents != null || editId != null)
          ? ProviderContainer(
              overrides: [
                if (overrideEvents != null)
                  eventListProvider.overrideWithValue(overrideEvents),
                if (editId != null)
                  editContentIdProvider.overrideWith((ref) => editId),
              ],
            )
          : container;

      await tester.pumpMaterialWidgetWithProviderScope(
        container: scopedContainer,
        router: router,
        child: EventWidget(
          eventId: eventId,
          showSheetName: showSheetName,
          margin: margin,
        ),
      );
      await tester.pump();
    }

    group('Rendering', () {
      testWidgets('renders with event data', (tester) async {
        await pumpEventWidget(tester, eventId: testEvent.id, overrideEvents: [testEvent]);

        expect(find.byType(EventWidget), findsOneWidget);
        expect(find.byType(Card), findsOneWidget);
        expect(find.byType(EventDateWidget), findsOneWidget);
        expect(find.byType(ZoeInlineTextEditWidget), findsOneWidget);
      });

      testWidgets('shows sheet name when flag is true', (tester) async {
        await pumpEventWidget(
          tester,
          eventId: testEvent.id,
          overrideEvents: [testEvent],
          showSheetName: true,
        );
        expect(find.byType(DisplaySheetNameWidget), findsOneWidget);
      });

      testWidgets('hides sheet name when flag is false', (tester) async {
        await pumpEventWidget(
          tester,
          eventId: testEvent.id,
          overrideEvents: [testEvent],
          showSheetName: false,
        );
        expect(find.byType(DisplaySheetNameWidget), findsNothing);
      });
    });

    group('Navigation', () {
      testWidgets('taps card to navigate to event detail', (tester) async {
        final mockRouter = await mockAnyPushGoRouter();

        await pumpEventWidget(
          tester,
          eventId: testEvent.id,
          overrideEvents: [testEvent],
          router: mockRouter,
        );

        await tester.tap(find.byType(Card));
        await tester.pumpAndSettle();

        verify(() => mockRouter.push(AppRoutes.eventDetail.route.replaceAll(':eventId', testEvent.id))).called(1);
      });

      testWidgets('taps title to navigate to event detail', (tester) async {
        final mockRouter = await mockAnyPushGoRouter();

        await pumpEventWidget(
          tester,
          eventId: testEvent.id,
          overrideEvents: [testEvent],
          router: mockRouter,
        );

        final titleEditor = tester.widget<ZoeInlineTextEditWidget>(find.byType(ZoeInlineTextEditWidget));
        titleEditor.onTapText?.call();
        await tester.pumpAndSettle();

        verify(() => mockRouter.push(AppRoutes.eventDetail.route.replaceAll(':eventId', testEvent.id))).called(1);
      });
    });

    group('Edit mode actions', () {
      testWidgets('hides actions when not editing', (tester) async {
        await pumpEventWidget(
          tester,
          eventId: testEvent.id,
          overrideEvents: [testEvent],
          editId: null,
        );
        expect(find.byIcon(Icons.edit), findsNothing);
        expect(find.byType(ZoeCloseButtonWidget), findsNothing);
      });

      testWidgets('shows actions when editing', (tester) async {
        await pumpEventWidget(
          tester,
          eventId: testEvent.id,
          overrideEvents: [testEvent],
          editId: testEvent.id,
        );
        expect(find.byIcon(Icons.edit), findsOneWidget);
        expect(find.byType(ZoeCloseButtonWidget), findsOneWidget);
      });

      testWidgets('edit icon tap navigates to detail', (tester) async {
        final mockRouter = await mockAnyPushGoRouter();

        await pumpEventWidget(
          tester,
          eventId: testEvent.id,
          overrideEvents: [testEvent],
          editId: testEvent.id,
          router: mockRouter,
        );

        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();

        verify(() => mockRouter.push(AppRoutes.eventDetail.route.replaceAll(':eventId', testEvent.id))).called(1);
      });
    });

    group('Mutations', () {
      testWidgets('title change updates provider', (tester) async {
        final eventListNotifier = EventList();
        final scoped = ProviderContainer(overrides: [
          eventListProvider.overrideWith(() => eventListNotifier),
        ]);

        await tester.pumpMaterialWidgetWithProviderScope(
          container: scoped,
          child: EventWidget(eventId: testEvent.id),
        );
        await tester.pump();

        // Initial state
        expect(scoped.read(eventListProvider).firstWhere((e) => e.id == testEvent.id).title, testEvent.title);

        final editor = tester.widget<ZoeInlineTextEditWidget>(find.byType(ZoeInlineTextEditWidget));
        editor.onTextChanged.call('Updated Title');
        await tester.pump();

        expect(scoped.read(eventListProvider).firstWhere((e) => e.id == testEvent.id).title, 'Updated Title');
      });

      testWidgets('delete button removes event from provider', (tester) async {
        // Use real notifier override and enable edit mode so the close button is visible
        final eventListNotifier = EventList();
        final scoped = ProviderContainer(overrides: [
          eventListProvider.overrideWith(() => eventListNotifier),
          editContentIdProvider.overrideWith((ref) => testEvent.id),
        ]);

        await tester.pumpMaterialWidgetWithProviderScope(
          container: scoped,
          child: EventWidget(eventId: testEvent.id),
        );
        await tester.pump();

        // Ensure the event exists before deletion
        expect(
          scoped.read(eventListProvider).any((e) => e.id == testEvent.id),
          isTrue,
        );

        // Tap the close button
        await tester.tap(find.byType(ZoeCloseButtonWidget));
        await tester.pump();

        // Verify deletion
        expect(
          scoped.read(eventListProvider).any((e) => e.id == testEvent.id),
          isFalse,
        );
      });
    });
  });
}


