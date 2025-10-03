import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/media_controller_widget.dart';
import 'package:zoe/features/documents/utils/document_media_utils.dart';
import '../../test-utils/test_utils.dart';

/// Test utilities for MediaControllerWidget tests
class MediaControllerWidgetTestUtils {
  /// Creates a test wrapper for the MediaControllerWidget
  static Widget createTestWidget({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    VoidCallback? onPlayPause,
    VoidCallback? onSeekBackward,
    VoidCallback? onSeekForward,
    ValueChanged<Duration>? onSeekTo,
  }) {
    return MediaControllerWidget(
      isPlaying: isPlaying ?? false,
      position: position ?? Duration.zero,
      duration: duration ?? const Duration(minutes: 5),
      onPlayPause: onPlayPause ?? () {},
      onSeekBackward: onSeekBackward ?? () {},
      onSeekForward: onSeekForward ?? () {},
      onSeekTo: onSeekTo ?? (duration) {},
    );
  }
}

void main() {
  group('MediaControllerWidget Tests -', () {
    testWidgets('renders with required properties', (tester) async {
      await tester.pumpMaterialWidget(
        child: MediaControllerWidgetTestUtils.createTestWidget(),
      );

      // Verify widget is rendered
      expect(find.byType(MediaControllerWidget), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.byType(Row), findsAtLeastNWidgets(2));
    });

    testWidgets('displays play icon when not playing', (tester) async {
      await tester.pumpMaterialWidget(
        child: MediaControllerWidgetTestUtils.createTestWidget(
          isPlaying: false,
        ),
      );

      // Verify play icon is displayed
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      expect(find.byIcon(Icons.pause_rounded), findsNothing);
    });

    testWidgets('displays pause icon when playing', (tester) async {
      await tester.pumpMaterialWidget(
        child: MediaControllerWidgetTestUtils.createTestWidget(isPlaying: true),
      );

      // Verify pause icon is displayed
      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsNothing);
    });

    testWidgets('displays seek backward button', (tester) async {
      await tester.pumpMaterialWidget(
        child: MediaControllerWidgetTestUtils.createTestWidget(),
      );

      // Verify seek backward button is displayed
      expect(find.byIcon(Icons.replay_10_rounded), findsOneWidget);
    });

    testWidgets('displays seek forward button', (tester) async {
      await tester.pumpMaterialWidget(
        child: MediaControllerWidgetTestUtils.createTestWidget(),
      );

      // Verify seek forward button is displayed
      expect(find.byIcon(Icons.forward_10_rounded), findsOneWidget);
    });

    testWidgets('displays position and duration text', (tester) async {
      const position = Duration(minutes: 2, seconds: 30);
      const duration = Duration(minutes: 5, seconds: 45);

      await tester.pumpMaterialWidget(
        child: MediaControllerWidgetTestUtils.createTestWidget(
          position: position,
          duration: duration,
        ),
      );

      // Verify time text is displayed
      expect(
        find.text(DocumentMediaUtils.formatDuration(position)),
        findsOneWidget,
      );
      expect(
        find.text(DocumentMediaUtils.formatDuration(duration)),
        findsOneWidget,
      );
    });

    testWidgets('displays progress slider', (tester) async {
      await tester.pumpMaterialWidget(
        child: MediaControllerWidgetTestUtils.createTestWidget(),
      );

      // Verify slider is displayed
      expect(find.byType(Slider), findsOneWidget);
      expect(find.byType(SliderTheme), findsOneWidget);
    });

    testWidgets('hides progress slider when duration is zero', (tester) async {
      await tester.pumpMaterialWidget(
        child: MediaControllerWidgetTestUtils.createTestWidget(
          duration: Duration.zero,
        ),
      );

      // Verify slider is hidden
      expect(find.byType(Slider), findsNothing);
      expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
    });

    testWidgets('calls onPlayPause when play/pause button is tapped', (
      tester,
    ) async {
      bool playPauseCalled = false;

      await tester.pumpMaterialWidget(
        child: MediaControllerWidgetTestUtils.createTestWidget(
          onPlayPause: () => playPauseCalled = true,
        ),
      );

      // Tap the play/pause button
      await tester.tap(find.byIcon(Icons.play_arrow_rounded));
      await tester.pump();

      // Verify callback is called
      expect(playPauseCalled, isTrue);
    });

    testWidgets('calls onSeekBackward when seek backward button is tapped', (
      tester,
    ) async {
      bool seekBackwardCalled = false;

      await tester.pumpMaterialWidget(
        child: MediaControllerWidgetTestUtils.createTestWidget(
          onSeekBackward: () => seekBackwardCalled = true,
        ),
      );

      // Tap the seek backward button
      await tester.tap(find.byIcon(Icons.replay_10_rounded));
      await tester.pump();

      // Verify callback is called
      expect(seekBackwardCalled, isTrue);
    });

    testWidgets('calls onSeekForward when seek forward button is tapped', (
      tester,
    ) async {
      bool seekForwardCalled = false;

      await tester.pumpMaterialWidget(
        child: MediaControllerWidgetTestUtils.createTestWidget(
          onSeekForward: () => seekForwardCalled = true,
        ),
      );

      // Tap the seek forward button
      await tester.tap(find.byIcon(Icons.forward_10_rounded));
      await tester.pump();

      // Verify callback is called
      expect(seekForwardCalled, isTrue);
    });

    testWidgets('calls onSeekTo when slider value changes', (tester) async {
      Duration? seekedDuration;

      await tester.pumpMaterialWidget(
        child: MediaControllerWidgetTestUtils.createTestWidget(
          onSeekTo: (duration) => seekedDuration = duration,
        ),
      );

      // Find and interact with the slider
      final slider = find.byType(Slider);
      expect(slider, findsOneWidget);

      // Simulate slider value change
      await tester.drag(slider, const Offset(50, 0));
      await tester.pump();

      // Verify callback is called
      expect(seekedDuration, isNotNull);
    });

    testWidgets('handles different position values', (tester) async {
      const positions = [
        Duration.zero,
        Duration(seconds: 30),
        Duration(minutes: 1, seconds: 30),
        Duration(minutes: 2), // Less than default duration of 5 minutes
      ];

      for (final position in positions) {
        await tester.pumpMaterialWidget(
          child: MediaControllerWidgetTestUtils.createTestWidget(
            position: position,
          ),
        );

        // Verify position text is displayed (may appear twice - position and duration)
        expect(
          find.text(DocumentMediaUtils.formatDuration(position)),
          findsAtLeastNWidgets(1),
        );
      }
    });

    testWidgets('handles different duration values', (tester) async {
      const durations = [
        Duration(seconds: 30),
        Duration(minutes: 1),
        Duration(minutes: 5, seconds: 30),
        Duration(hours: 1, minutes: 30),
      ];

      for (final duration in durations) {
        await tester.pumpMaterialWidget(
          child: MediaControllerWidgetTestUtils.createTestWidget(
            duration: duration,
          ),
        );

        // Verify duration text is displayed
        expect(
          find.text(DocumentMediaUtils.formatDuration(duration)),
          findsOneWidget,
        );
      }
    });

    testWidgets('handles rapid slider changes', (tester) async {
      final List<Duration> seekedDurations = [];

      await tester.pumpMaterialWidget(
        child: MediaControllerWidgetTestUtils.createTestWidget(
          onSeekTo: (duration) => seekedDurations.add(duration),
        ),
      );

      // Simulate rapid slider changes
      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(10, 0));
      await tester.drag(slider, const Offset(20, 0));
      await tester.drag(slider, const Offset(30, 0));
      await tester.pump();

      // Verify multiple callbacks are called
      expect(seekedDurations.length, greaterThan(0));
    });

    testWidgets('handles slider theme customization', (tester) async {
      await tester.pumpMaterialWidget(
        child: MediaControllerWidgetTestUtils.createTestWidget(),
      );

      // Verify slider theme is applied
      final sliderTheme = tester.widget<SliderTheme>(find.byType(SliderTheme));
      expect(sliderTheme, isNotNull);
      expect(sliderTheme.data, isNotNull);
    });
  });
}
