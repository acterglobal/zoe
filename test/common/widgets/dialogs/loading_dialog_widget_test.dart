import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/dialogs/loading_dialog_widget.dart';
import 'package:zoe/common/widgets/loading_indicator_widget.dart';
import '../../../test-utils/test_utils.dart';
import 'package:mocktail/mocktail.dart';
import '../../../test-utils/mock_gorouter.dart';

void main() {
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockGoRouter = MockGoRouter();
    when(() => mockGoRouter.pop()).thenAnswer((_) {});
    when(() => mockGoRouter.canPop()).thenReturn(true);
  });

  Future<void> pumpLoadingDialog(WidgetTester tester, {String? message}) async {
    await tester.pumpMaterialWidget(
      router: mockGoRouter,
      child: LoadingDialogWidget(message: message),
    );
  }

  group('LoadingDialogWidget', () {
    testWidgets('renders circular loading indicator', (tester) async {
      await pumpLoadingDialog(tester);

      expect(find.byType(LoadingIndicatorWidget), findsOneWidget);
      final indicator = tester.widget<LoadingIndicatorWidget>(
        find.byType(LoadingIndicatorWidget),
      );
      expect(indicator.type, equals(LoadingIndicatorType.circular));
    });

    testWidgets('renders message when provided', (tester) async {
      const message = 'Loading...';
      await pumpLoadingDialog(tester, message: message);

      expect(find.text(message), findsOneWidget);
    });

    testWidgets('does not render message spacer when message is null', (
      tester,
    ) async {
      await pumpLoadingDialog(tester);

      final spacerFinder = find.byWidgetPredicate(
        (widget) => widget is SizedBox && widget.width == 15,
      );
      expect(spacerFinder, findsNothing);
      expect(find.text('Loading...'), findsNothing);
    });

    testWidgets('hide calls context.pop', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () => LoadingDialogWidget.hide(context),
                child: const Text('Hide'),
              );
            },
          ),
        ),
      );
    });

    testWidgets('static show displays dialog', (tester) async {
      await tester.pumpMaterialWidget(
        router: mockGoRouter,
        child: Builder(
          builder: (context) => TextButton(
            onPressed: () => LoadingDialogWidget.show(context, message: 'Test'),
            child: Text('Show'),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(LoadingDialogWidget), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });
  });
}
