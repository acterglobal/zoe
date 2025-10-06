import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:zoe/common/widgets/qr_scan_bottom_sheet.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import '../../test-utils/test_utils.dart';

/// Test utilities for QrScanBottomSheet tests
class QrScanBottomSheetTestUtils {
  /// Creates a test wrapper for the QrScanBottomSheet
  static Widget createTestWidget({
    void Function(BarcodeCapture barcodes)? onDetect,
  }) {
    return QrScanBottomSheet(onDetect: onDetect);
  }

  /// Creates a test wrapper for the showQrScanBottomSheet function
  static Widget createTestBottomSheet({
    void Function(BarcodeCapture barcodes)? onDetect,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showQrScanBottomSheet(context: context, onDetect: onDetect);
              },
              child: const Text('Show QR Scanner'),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  group('QrScanBottomSheet Tests -', () {
    testWidgets('renders with required properties', (tester) async {
      await tester.pumpMaterialWidget(
        child: QrScanBottomSheetTestUtils.createTestWidget(),
      );

      // Verify widget is rendered
      expect(find.byType(QrScanBottomSheet), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(MaxWidthWidget), findsOneWidget);
    });

    testWidgets('displays title text', (tester) async {
      await tester.pumpMaterialWidget(
        child: QrScanBottomSheetTestUtils.createTestWidget(),
      );

      // Verify title is displayed
      expect(find.byType(Text), findsAtLeastNWidgets(1));
    });

    testWidgets('displays mobile scanner', (tester) async {
      await tester.pumpMaterialWidget(
        child: QrScanBottomSheetTestUtils.createTestWidget(),
      );

      // Verify MobileScanner is displayed (may not render in test environment)
      expect(find.byType(MobileScanner), findsAtLeastNWidgets(1));
    });

    testWidgets('displays circular progress indicator as placeholder', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        child: QrScanBottomSheetTestUtils.createTestWidget(),
      );

      // Verify CircularProgressIndicator is displayed as placeholder
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('handles onDetect callback', (tester) async {
      await tester.pumpMaterialWidget(
        child: QrScanBottomSheetTestUtils.createTestWidget(
          onDetect: (barcodes) {
            // Callback is set up correctly
          },
        ),
      );

      // Verify MobileScanner is configured with onDetect callback
      final mobileScannerWidgets = tester.widgetList<MobileScanner>(
        find.byType(MobileScanner),
      );
      if (mobileScannerWidgets.isNotEmpty) {
        final mobileScanner = mobileScannerWidgets.first;
        expect(mobileScanner.onDetect, isNotNull);
      }
    });

    testWidgets('handles null onDetect callback', (tester) async {
      await tester.pumpMaterialWidget(
        child: QrScanBottomSheetTestUtils.createTestWidget(onDetect: null),
      );

      // Verify MobileScanner is configured with null onDetect callback
      final mobileScannerWidgets = tester.widgetList<MobileScanner>(
        find.byType(MobileScanner),
      );
      if (mobileScannerWidgets.isNotEmpty) {
        final mobileScanner = mobileScannerWidgets.first;
        expect(mobileScanner.onDetect, isNull);
      }
    });
  });
}
