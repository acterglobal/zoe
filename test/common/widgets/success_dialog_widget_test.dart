import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/success_dialog_widget.dart';
import '../../test-utils/test_utils.dart';

void main() {
  testWidgets('widget exists when created', (tester) async {
    await tester.pumpMaterialWidget(
      child: SuccessDialogWidget(
        title: 'Test Title',
        message: 'Test Message',
      ),
    );

    // Pump enough frames for the animations to complete (300ms + buffer)
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(SuccessDialogWidget), findsOneWidget);
  });

  testWidgets('displays title text', (tester) async {
    const testTitle = 'Success!';
    await tester.pumpMaterialWidget(
      child: createSuccessDialogWidget(
        title: testTitle,
        message: 'Test Message',
      ),
    );

    // Pump enough frames for the animations to complete (300ms + buffer)
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text(testTitle), findsOneWidget);
  });

  testWidgets('displays message text', (tester) async {
    const testMessage = 'Operation completed';
    await tester.pumpMaterialWidget(
      child: createSuccessDialogWidget(
        title: 'Test Title',
        message: testMessage,
      ),
    );

    // Pump enough frames for the animations to complete (300ms + buffer)
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text(testMessage), findsOneWidget);
  });

  testWidgets('uses default icon when customIcon is null', (tester) async {
    await tester.pumpMaterialWidget(
      child: createSuccessDialogWidget(
        title: 'Test Title',
        message: 'Test Message',
        customIcon: null,
      ),
    );

    // Pump enough frames for the animations to complete (300ms + buffer)
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  });

  testWidgets('uses provided custom icon', (tester) async {
    await tester.pumpMaterialWidget(
      child: createSuccessDialogWidget(
        title: 'Test Title',
        message: 'Test Message',
        customIcon: Icons.star,
      ),
    );

    // Pump enough frames for the animations to complete (300ms + buffer)
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('handles empty title', (tester) async {
    await tester.pumpMaterialWidget(
      child: createSuccessDialogWidget(
        title: '',
        message: 'Test Message',
      ),
    );

    // Pump enough frames for the animations to complete (300ms + buffer)
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text(''), findsOneWidget);
  });

  testWidgets('handles empty message', (tester) async {
    await tester.pumpMaterialWidget(
      child: createSuccessDialogWidget(
        title: 'Test Title',
        message: '',
      ),
    );

    // Pump enough frames for the animations to complete (300ms + buffer)
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text(''), findsOneWidget);
  });

  testWidgets('handles null button text', (tester) async {
    await tester.pumpMaterialWidget(
      child: createSuccessDialogWidget(
        title: 'Test Title',
        message: 'Test Message',
        buttonText: null,
      ),
    );

    // Pump enough frames for the animations to complete (300ms + buffer)
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Done'), findsOneWidget);
  });


  testWidgets('holds widget properties', (tester) async {
    const testKey = Key('test_key');

    await tester.pumpMaterialWidget(
      child: createSuccessDialogWidget(
        key: testKey,
        title: 'Test Title',
        message: 'Test Message',
      ),
    );

    // Pump enough frames for the animations to complete (300ms + buffer)
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byKey(testKey), findsOneWidget);
  });

  testWidgets('accepts various icon types', (tester) async {
    final icons = [
      Icons.check,
      Icons.done,
      Icons.star,
    ];

    for (final icon in icons) {
      await tester.pumpMaterialWidget(
        child: createSuccessDialogWidget(
          title: 'Test Title',
          message: 'Test Message',
          customIcon: icon,
        ),
      );

      // Pump enough frames for the animations to complete (300ms + buffer)
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byIcon(icon), findsOneWidget);
    }
  });
}

/// Helper function to create test widget
Widget createSuccessDialogWidget({
  Key? key,
  required String title,
  required String message,
  String? buttonText,
  VoidCallback? onButtonPressed,
  IconData? customIcon,
}) {
  return SuccessDialogWidget(
    key: key,
    title: title,
    message: message,
    buttonText: buttonText,
    onButtonPressed: onButtonPressed,
    customIcon: customIcon,
  );
}