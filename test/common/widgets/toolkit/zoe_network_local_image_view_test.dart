import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/toolkit/zoe_network_local_image_view.dart';

import '../../../test-utils/test_utils.dart';

void main() {
  group('Zoe Network Local ImageView', () {
    const testNetworkImageUrl = 'https://example.com/image.jpg';
    const testLocalImagePath = '/test/images/local_image.jpg';
    const defaultBorderRadius = 15.0;
    const defaultPadding = 12.0;
    const defaultIconSize = 28.0;

    /// Test utilities for ZoeNetworkLocalImageView tests
    Future<void> pumpZoeNetworkLocalImageView(
      WidgetTester tester, {
      required String imageUrl,
      double? width,
      double? height,
      BoxFit fit = BoxFit.cover,
      double borderRadius = 15,
    }) async {
      await tester.pumpMaterialWidget(
        child: ZoeNetworkLocalImageView(
          imageUrl: imageUrl,
          width: width,
          height: height,
          fit: fit,
          borderRadius: borderRadius,
        ),
      );
    }

    group('Basic Rendering Tests -', () {
      testWidgets('renders with network image URL', (tester) async {
        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testNetworkImageUrl,
        );

        // Verify widget is rendered
        expect(find.byType(ZoeNetworkLocalImageView), findsOneWidget);
        expect(find.byType(ClipRRect), findsOneWidget);
        expect(find.byType(CachedNetworkImage), findsOneWidget);
      });

      testWidgets('renders with local image path', (tester) async {
        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testLocalImagePath,
        );

        // Verify widget is rendered
        expect(find.byType(ZoeNetworkLocalImageView), findsOneWidget);
        expect(find.byType(ClipRRect), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);

        // Verify Image.file is used for local images
        final image = tester.widget<Image>(find.byType(Image));
        expect(image.image, isA<FileImage>());
      });

      testWidgets('correctly identifies network images', (tester) async {
        final networkUrls = [
          'http://example.com/image.jpg',
          'https://example.com/image.png',
          'http://www.example.com/image.gif',
          'https://cdn.example.com/image.jpg',
        ];

        for (final url in networkUrls) {
          await pumpZoeNetworkLocalImageView(tester, imageUrl: url);

          // Verify CachedNetworkImage is used for network URLs
          expect(find.byType(CachedNetworkImage), findsOneWidget);

          // Verify Image.file is not used for network URLs
          // Note: CachedNetworkImage internally uses Image, so we check image type instead
          final cachedImage = tester.widget<CachedNetworkImage>(
            find.byType(CachedNetworkImage),
          );
          expect(cachedImage.imageUrl, equals(url));
        }
      });

      testWidgets('correctly identifies local images', (tester) async {
        final localPaths = [
          '/path/to/image.jpg',
          './relative/path/image.png',
          'assets/images/image.gif',
          '/Users/test/image.jpg',
        ];

        for (final path in localPaths) {
          await pumpZoeNetworkLocalImageView(tester, imageUrl: path);

          // Verify Image.file is used for local paths (CachedNetworkImage should not be used)
          expect(find.byType(CachedNetworkImage), findsNothing);
          expect(find.byType(Image), findsOneWidget);

          // Verify Image.file is used
          final image = tester.widget<Image>(find.byType(Image));
          expect(image.image, isA<FileImage>());
        }
      });
    });

    group('Properties Tests -', () {
      testWidgets('applies default borderRadius when dimensions not provided', (
        tester,
      ) async {
        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testNetworkImageUrl,
        );

        // Verify ClipRRect uses default borderRadius
        final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
        expect(
          clipRRect.borderRadius,
          equals(BorderRadius.circular(defaultBorderRadius)),
        );
      });

      testWidgets('applies custom borderRadius', (tester) async {
        const customBorderRadius = 25.0;

        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testNetworkImageUrl,
          borderRadius: customBorderRadius,
        );

        // Verify ClipRRect uses custom borderRadius
        final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
        expect(
          clipRRect.borderRadius,
          equals(BorderRadius.circular(customBorderRadius)),
        );
      });

      testWidgets('calculates dynamic borderRadius from dimensions', (
        tester,
      ) async {
        const width = 100.0;
        const height = 150.0;
        // minDimension = 100, so borderRadius = 100 * 0.2 = 20

        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testNetworkImageUrl,
          width: width,
          height: height,
        );

        // Verify dynamic borderRadius is calculated
        final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
        final expectedRadius = width * 0.2; // minDimension is width (100)
        expect(
          clipRRect.borderRadius,
          equals(BorderRadius.circular(expectedRadius)),
        );
      });

      testWidgets('uses height for borderRadius when height is smaller', (
        tester,
      ) async {
        const width = 200.0;
        const height = 100.0;
        // minDimension = 100 (height), so borderRadius = 100 * 0.2 = 20

        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testNetworkImageUrl,
          width: width,
          height: height,
        );

        // Verify dynamic borderRadius uses height (smaller dimension)
        final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
        final expectedRadius = height * 0.2; // minDimension is height (100)
        expect(
          clipRRect.borderRadius,
          equals(BorderRadius.circular(expectedRadius)),
        );
      });

      testWidgets('applies width and height to network image', (tester) async {
        const width = 200.0;
        const height = 150.0;

        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testNetworkImageUrl,
          width: width,
          height: height,
        );

        // Verify CachedNetworkImage receives dimensions
        final cachedImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );
        expect(cachedImage.width, equals(width));
        expect(cachedImage.height, equals(height));
      });

      testWidgets('applies width and height to local image', (tester) async {
        const width = 200.0;
        const height = 150.0;

        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testLocalImagePath,
          width: width,
          height: height,
        );

        // Verify Image.file receives dimensions
        final image = tester.widget<Image>(find.byType(Image));
        expect(image.width, equals(width));
        expect(image.height, equals(height));
      });

      testWidgets('applies default BoxFit.cover', (tester) async {
        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testNetworkImageUrl,
        );

        // Verify default fit is BoxFit.cover
        final cachedImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );
        expect(cachedImage.fit, equals(BoxFit.cover));
      });

      testWidgets('applies custom BoxFit', (tester) async {
        const customFit = BoxFit.contain;

        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testNetworkImageUrl,
          fit: customFit,
        );

        // Verify custom fit is applied
        final cachedImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );
        expect(cachedImage.fit, equals(customFit));
      });

      testWidgets('applies BoxFit to local image', (tester) async {
        const customFit = BoxFit.fill;

        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testLocalImagePath,
          fit: customFit,
        );

        // Verify fit is applied to local image
        final image = tester.widget<Image>(find.byType(Image));
        expect(image.fit, equals(customFit));
      });
    });

    group('Placeholder Tests -', () {
      testWidgets('shows placeholder for network images', (tester) async {
        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testNetworkImageUrl,
        );

        // Placeholder should be present in CachedNetworkImage
        final cachedImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );
        expect(cachedImage.placeholder, isNotNull);

        // Verify placeholder is CircularProgressIndicator
        final placeholderBuilder = cachedImage.placeholder;
        final placeholderWidget = placeholderBuilder!(
          tester.element(find.byType(CachedNetworkImage)),
          testNetworkImageUrl,
        );

        // Pump placeholder to verify structure
        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: placeholderWidget)),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets(
        'uses default padding for placeholder when dimensions not provided',
        (tester) async {
          await pumpZoeNetworkLocalImageView(
            tester,
            imageUrl: testNetworkImageUrl,
          );

          final cachedImage = tester.widget<CachedNetworkImage>(
            find.byType(CachedNetworkImage),
          );
          final placeholderBuilder = cachedImage.placeholder;
          final placeholderWidget = placeholderBuilder!(
            tester.element(find.byType(CachedNetworkImage)),
            testNetworkImageUrl,
          );

          await tester.pumpWidget(
            MaterialApp(home: Scaffold(body: placeholderWidget)),
          );

          // Verify CircularProgressIndicator has default padding
          final progressIndicator = tester.widget<CircularProgressIndicator>(
            find.byType(CircularProgressIndicator),
          );
          expect(
            progressIndicator.padding,
            equals(EdgeInsets.all(defaultPadding)),
          );
        },
      );

      testWidgets('calculates dynamic padding for placeholder', (tester) async {
        const width = 100.0;
        const height = 80.0;
        // minDimension = 80, so padding = 80 * 0.3 = 24

        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testNetworkImageUrl,
          width: width,
          height: height,
        );

        final cachedImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );
        final placeholderBuilder = cachedImage.placeholder;
        final placeholderWidget = placeholderBuilder!(
          tester.element(find.byType(CachedNetworkImage)),
          testNetworkImageUrl,
        );

        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: placeholderWidget)),
        );

        // Verify dynamic padding is calculated
        final progressIndicator = tester.widget<CircularProgressIndicator>(
          find.byType(CircularProgressIndicator),
        );
        final expectedPadding = height * 0.3; // minDimension is height (80)
        expect(
          progressIndicator.padding,
          equals(EdgeInsets.all(expectedPadding)),
        );
      });

      testWidgets('placeholder has correct strokeWidth', (tester) async {
        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testNetworkImageUrl,
        );

        final cachedImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );
        final placeholderBuilder = cachedImage.placeholder;
        final placeholderWidget = placeholderBuilder!(
          tester.element(find.byType(CachedNetworkImage)),
          testNetworkImageUrl,
        );

        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: placeholderWidget)),
        );

        // Verify strokeWidth
        final progressIndicator = tester.widget<CircularProgressIndicator>(
          find.byType(CircularProgressIndicator),
        );
        expect(progressIndicator.strokeWidth, equals(2.5));
      });
    });

    group('Error Widget Tests -', () {
      testWidgets('shows error widget for network images', (tester) async {
        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testNetworkImageUrl,
        );

        // Error widget should be present in CachedNetworkImage
        final cachedImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );
        expect(cachedImage.errorWidget, isNotNull);

        // Verify error widget is Icon with broken_image_outlined
        final errorBuilder = cachedImage.errorWidget;
        final errorWidget = errorBuilder!(
          tester.element(find.byType(CachedNetworkImage)),
          testNetworkImageUrl,
          Object(),
        );

        // Pump error widget to verify structure
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: errorWidget)));

        expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
      });

      testWidgets('shows error widget for local images', (tester) async {
        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testLocalImagePath,
        );

        // Error widget should be present in Image.file
        final image = tester.widget<Image>(find.byType(Image));
        expect(image.errorBuilder, isNotNull);

        // Verify error widget is Icon with broken_image_outlined
        final errorBuilder = image.errorBuilder;
        final errorWidget = errorBuilder!(
          tester.element(find.byType(Image)),
          Object(),
          StackTrace.empty,
        );

        // Pump error widget to verify structure
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: errorWidget)));

        expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
      });

      testWidgets('error icon has correct color', (tester) async {
        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testNetworkImageUrl,
        );

        final cachedImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );
        final errorBuilder = cachedImage.errorWidget;
        final errorWidget = errorBuilder!(
          tester.element(find.byType(CachedNetworkImage)),
          testNetworkImageUrl,
          Object(),
        );

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: errorWidget)));

        // Verify error icon color
        final icon = tester.widget<Icon>(
          find.byIcon(Icons.broken_image_outlined),
        );
        expect(icon.color, equals(Colors.red));
      });

      testWidgets('uses default icon size when dimensions not provided', (
        tester,
      ) async {
        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testNetworkImageUrl,
        );

        final cachedImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );
        final errorBuilder = cachedImage.errorWidget;
        final errorWidget = errorBuilder!(
          tester.element(find.byType(CachedNetworkImage)),
          testNetworkImageUrl,
          Object(),
        );

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: errorWidget)));

        // Verify default icon size
        final icon = tester.widget<Icon>(
          find.byIcon(Icons.broken_image_outlined),
        );
        expect(icon.size, equals(defaultIconSize));
      });

      testWidgets('uses width for icon size when width is smaller', (
        tester,
      ) async {
        const width = 100.0;
        const height = 150.0;
        // minDimension = 100 (width), so iconSize = 100

        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testNetworkImageUrl,
          width: width,
          height: height,
        );

        final cachedImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );
        final errorBuilder = cachedImage.errorWidget;
        final errorWidget = errorBuilder!(
          tester.element(find.byType(CachedNetworkImage)),
          testNetworkImageUrl,
          Object(),
        );

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: errorWidget)));

        // Verify dynamic icon size
        final icon = tester.widget<Icon>(
          find.byIcon(Icons.broken_image_outlined),
        );
        expect(icon.size, equals(width));
      });

      testWidgets('uses height for icon size when height is smaller', (
        tester,
      ) async {
        const width = 200.0;
        const height = 80.0;
        // minDimension = 80 (height), so iconSize = 80

        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testNetworkImageUrl,
          width: width,
          height: height,
        );

        final cachedImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );
        final errorBuilder = cachedImage.errorWidget;
        final errorWidget = errorBuilder!(
          tester.element(find.byType(CachedNetworkImage)),
          testNetworkImageUrl,
          Object(),
        );

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: errorWidget)));

        // Verify dynamic icon size uses height (smaller dimension)
        final icon = tester.widget<Icon>(
          find.byIcon(Icons.broken_image_outlined),
        );
        expect(icon.size, equals(height));
      });
    });

    group('Edge Cases Tests -', () {
      testWidgets('handles empty URL gracefully', (tester) async {
        await pumpZoeNetworkLocalImageView(tester, imageUrl: '');

        // Widget should render (treats empty as local path)
        expect(find.byType(ZoeNetworkLocalImageView), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('handles very long network URLs', (tester) async {
        final longUrl =
            'https://example.com/very/long/path/to/image/with/many/directories/image.jpg';

        await pumpZoeNetworkLocalImageView(tester, imageUrl: longUrl);

        // Widget should render correctly
        expect(find.byType(ZoeNetworkLocalImageView), findsOneWidget);
        expect(find.byType(CachedNetworkImage), findsOneWidget);

        // Verify URL is passed correctly
        final cachedImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );
        expect(cachedImage.imageUrl, equals(longUrl));
      });

      testWidgets('handles very long local paths', (tester) async {
        final longPath = '/users/directories/image.jpg';

        await pumpZoeNetworkLocalImageView(tester, imageUrl: longPath);

        // Widget should render correctly
        expect(find.byType(ZoeNetworkLocalImageView), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('handles zero dimensions', (tester) async {
        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testNetworkImageUrl,
          width: 0,
          height: 0,
        );

        // Widget should render (uses default borderRadius)
        expect(find.byType(ZoeNetworkLocalImageView), findsOneWidget);
        final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
        // When dimensions are 0, minDimension is 0, so borderRadius = 0 * 0.2 = 0
        expect(clipRRect.borderRadius, equals(BorderRadius.circular(0)));
      });

      testWidgets('handles very large dimensions', (tester) async {
        const largeWidth = 5000.0;
        const largeHeight = 3000.0;

        await pumpZoeNetworkLocalImageView(
          tester,
          imageUrl: testNetworkImageUrl,
          width: largeWidth,
          height: largeHeight,
        );

        // Widget should render correctly
        expect(find.byType(ZoeNetworkLocalImageView), findsOneWidget);
        final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
        // minDimension is height (3000)
        final expectedRadius = largeHeight * 0.2;
        expect(
          clipRRect.borderRadius,
          equals(BorderRadius.circular(expectedRadius)),
        );
      });
    });

    group('BoxFit Variations Tests -', () {
      final fitOptions = [BoxFit.cover, BoxFit.contain, BoxFit.fill];

      testWidgets('handles different BoxFit options for network images', (
        tester,
      ) async {
        for (final fit in fitOptions) {
          await pumpZoeNetworkLocalImageView(
            tester,
            imageUrl: testNetworkImageUrl,
            fit: fit,
          );

          final cachedImage = tester.widget<CachedNetworkImage>(
            find.byType(CachedNetworkImage),
          );
          expect(cachedImage.fit, equals(fit));

          await tester.pumpWidget(const SizedBox());
        }
      });

      testWidgets('handles different BoxFit options for local images', (
        tester,
      ) async {
        for (final fit in fitOptions) {
          await pumpZoeNetworkLocalImageView(
            tester,
            imageUrl: testLocalImagePath,
            fit: fit,
          );

          final image = tester.widget<Image>(find.byType(Image));
          expect(image.fit, equals(fit));

          await tester.pumpWidget(const SizedBox());
        }
      });
    });
  });
}
