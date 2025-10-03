import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/app_icon_widget.dart';
import 'package:zoe/common/widgets/shimmer_overlay_widget.dart';

import '../../test-utils/test_utils.dart';

/// Test utilities for AppIconWidget tests
class AppIconWidgetTestUtils {
  /// Creates a test wrapper for the AppIconWidget
  static AppIconWidget createTestWidget({double size = 100}) {
    return AppIconWidget(size: size);
  }
}

void main() {
  group('AppIconWidget Tests -', () {
    testWidgets('renders with default size', (tester) async {
      await tester.pumpMaterialWidget(
        child: AppIconWidgetTestUtils.createTestWidget(),
      );

      // Verify widget is rendered
      expect(find.byType(AppIconWidget), findsOneWidget);
      expect(find.byType(ShimmerOverlay), findsOneWidget);
      expect(find.byType(ClipRRect), findsAtLeastNWidgets(1));
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders with custom size', (tester) async {
      const customSize = 150.0;

      await tester.pumpMaterialWidget(
        child: AppIconWidgetTestUtils.createTestWidget(size: customSize),
      );

      // Verify widget is rendered
      expect(find.byType(AppIconWidget), findsOneWidget);
      expect(find.byType(ShimmerOverlay), findsOneWidget);
      expect(find.byType(ClipRRect), findsAtLeastNWidgets(1));
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('configures ShimmerOverlay correctly', (tester) async {
      const size = 120.0;

      await tester.pumpMaterialWidget(
        child: AppIconWidgetTestUtils.createTestWidget(size: size),
      );

      // Verify ShimmerOverlay configuration
      final shimmerOverlay = tester.widget<ShimmerOverlay>(
        find.byType(ShimmerOverlay),
      );
      expect(shimmerOverlay.duration, const Duration(seconds: 2));
      expect(shimmerOverlay.shimmerColors, isNotNull);
      expect(shimmerOverlay.borderRadius, isNotNull);

      // Verify shimmer colors
      final expectedColors = [
        Colors.transparent,
        Colors.white.withValues(alpha: 0.08),
        Colors.white.withValues(alpha: 0.2),
        Colors.white.withValues(alpha: 0.08),
        Colors.transparent,
      ];
      expect(shimmerOverlay.shimmerColors, expectedColors);
    });

    testWidgets('renders Image.asset with correct properties', (tester) async {
      const size = 100.0;

      await tester.pumpMaterialWidget(
        child: AppIconWidgetTestUtils.createTestWidget(size: size),
      );

      // Verify Image.asset configuration
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<AssetImage>());
      expect(image.width, size);
      expect(image.height, size);

      // Verify asset path
      final assetImage = image.image as AssetImage;
      expect(assetImage.assetName, 'assets/icon/app_icon.png');
    });

    testWidgets('applies ClipRRect with correct border radius', (tester) async {
      const size = 60.0;
      const expectedBorderRadius = 15.0; // size * 0.25

      await tester.pumpMaterialWidget(
        child: AppIconWidgetTestUtils.createTestWidget(size: size),
      );

      // Verify ClipRRect configuration
      final clipRRects = tester.widgetList<ClipRRect>(find.byType(ClipRRect));
      final clipRRect = clipRRects.firstWhere(
        (clip) => clip.borderRadius is BorderRadius,
      );
      final borderRadius = clipRRect.borderRadius as BorderRadius;
      expect(borderRadius.topLeft.x, expectedBorderRadius);
      expect(borderRadius.topRight.x, expectedBorderRadius);
      expect(borderRadius.bottomLeft.x, expectedBorderRadius);
      expect(borderRadius.bottomRight.x, expectedBorderRadius);
    });

    testWidgets('handles zero size', (tester) async {
      await tester.pumpMaterialWidget(
        child: AppIconWidgetTestUtils.createTestWidget(size: 0),
      );

      // Verify widget renders without errors
      expect(find.byType(AppIconWidget), findsOneWidget);
      expect(find.byType(ShimmerOverlay), findsOneWidget);
      expect(find.byType(ClipRRect), findsAtLeastNWidgets(1));
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('shimmer colors are correctly configured', (tester) async {
      await tester.pumpMaterialWidget(
        child: AppIconWidgetTestUtils.createTestWidget(),
      );

      // Verify shimmer colors
      final shimmerOverlay = tester.widget<ShimmerOverlay>(
        find.byType(ShimmerOverlay),
      );
      final shimmerColors = shimmerOverlay.shimmerColors!;

      expect(shimmerColors.length, 5);
      expect(shimmerColors[0], Colors.transparent);
      expect(shimmerColors[1], Colors.white.withValues(alpha: 0.08));
      expect(shimmerColors[2], Colors.white.withValues(alpha: 0.2));
      expect(shimmerColors[3], Colors.white.withValues(alpha: 0.08));
      expect(shimmerColors[4], Colors.transparent);
    });

    testWidgets('shimmer duration is correctly configured', (tester) async {
      await tester.pumpMaterialWidget(
        child: AppIconWidgetTestUtils.createTestWidget(),
      );

      // Verify shimmer duration
      final shimmerOverlay = tester.widget<ShimmerOverlay>(
        find.byType(ShimmerOverlay),
      );
      expect(shimmerOverlay.duration, const Duration(seconds: 2));
    });
  });
}
