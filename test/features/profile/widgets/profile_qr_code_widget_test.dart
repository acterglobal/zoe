import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/features/profile/widgets/profile_qr_code_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  const testUserName = 'John Doe';

  // Helper to set standard testing view size
  void setTestViewSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;

    // Always reset in a tearDown to prevent state leaking to other tests
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Future<void> pumpWidget(WidgetTester tester) async {
    setTestViewSize(tester); // Apply size configuration
    await tester.pumpMaterialWidget(
      child: SingleChildScrollView(
        child: const ProfileQrCodeWidget(userName: testUserName),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('displays header with icon and text', (tester) async {
    await pumpWidget(tester);

    expect(find.byIcon(Icons.qr_code_scanner_rounded), findsOneWidget);
    expect(
      find.text(
        L10n.of(tester.element(find.byType(ProfileQrCodeWidget))).scanToConnect,
      ),
      findsOneWidget,
    );
  });

  testWidgets('displays QR code view', (tester) async {
    await pumpWidget(tester);

    expect(find.byType(PrettyQrView), findsOneWidget);
    expect(find.byType(GlassyContainer), findsOneWidget);
  });

  testWidgets('shows bottom sheet when triggered', (tester) async {
    setTestViewSize(tester);
    await tester.pumpMaterialWidget(
      child: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () =>
                showProfileQrCodeBottomSheet(context, testUserName),
            child: const Text('Show QR'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Show QR'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileQrCodeWidget), findsOneWidget);
  });

  group('getAppIconImagePath', () {
    testWidgets('returns light icon in dark mode', (tester) async {
      setTestViewSize(tester);
      await tester.pumpMaterialWidget(
        child: Theme(
          data: ThemeData.dark(),
          child: Builder(
            builder: (context) {
              final widget = ProfileQrCodeWidget(userName: testUserName);
              final assetImage = widget.getAppIconImagePath(context);
              expect(
                assetImage.assetName,
                equals('assets/icon/app_icon_light.png'),
              );
              return widget;
            },
          ),
        ),
      );
    });

    testWidgets('returns dark icon in light mode', (tester) async {
      setTestViewSize(tester);
      await tester.pumpMaterialWidget(
        child: Theme(
          data: ThemeData.light(),
          child: Builder(
            builder: (context) {
              final widget = ProfileQrCodeWidget(userName: testUserName);
              final assetImage = widget.getAppIconImagePath(context);
              expect(
                assetImage.assetName,
                equals('assets/icon/app_icon_dark.png'),
              );
              return widget;
            },
          ),
        ),
      );
    });
  });
}
