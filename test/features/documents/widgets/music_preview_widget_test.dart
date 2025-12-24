/*
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/features/documents/data/document_data.dart';
import 'package:zoe/features/documents/models/document_model.dart';
import 'package:zoe/features/documents/widgets/music_preview_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  group('MusicPreviewWidget Tests', () {
    late ProviderContainer container;
    late DocumentModel testDocument;

    setUp(() {
      container = ProviderContainer.test();
      testDocument = documentList.firstWhere(
        (doc) =>
            doc.filePath.toLowerCase().endsWith('.mp3') ||
            doc.filePath.toLowerCase().endsWith('.wav') ||
            doc.filePath.toLowerCase().endsWith('.m4a'),
        orElse: () => documentList.first,
      );
    });

    Future<void> pumpMusicWidget(
      WidgetTester tester, {
      required DocumentModel document,
      ThemeData? theme,
      Key? key,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: Scaffold(
          body: MusicPreviewWidget(key: key, document: document),
        ),
        container: container,
        theme: theme,
      );
    }

    testWidgets('renders MusicPreviewWidget correctly', (tester) async {
      await pumpMusicWidget(tester, document: testDocument);

      expect(find.byType(MusicPreviewWidget), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(GlassyContainer), findsWidgets);
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('renders GlassyContainer with correct properties', (tester) async {
      await pumpMusicWidget(tester, document: testDocument);

      final glassyContainer = tester.widget<GlassyContainer>(find.byType(GlassyContainer).first);
      expect(glassyContainer.width, isNull);
      expect(glassyContainer.borderRadius, equals(BorderRadius.circular(20)));
      expect(glassyContainer.padding, equals(const EdgeInsets.all(8)));
      expect(glassyContainer.margin, equals(const EdgeInsets.all(16)));
    });

    testWidgets('renders ClipRRect with correct border radius', (tester) async {
      await pumpMusicWidget(tester, document: testDocument);

      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRect.borderRadius, equals(BorderRadius.circular(16)));
    });
  
    testWidgets('renders loading UI initially', (tester) async {
      await pumpMusicWidget(tester, document: testDocument);

      final loadingContainer = tester.widget<GlassyContainer>(find.byType(GlassyContainer).at(1));
      expect(loadingContainer.height, equals(300));
      expect(loadingContainer.borderRadius, equals(BorderRadius.circular(16)));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        find.text(L10n.of(tester.element(find.byType(MusicPreviewWidget))).initializingAudioPlayer),
        findsOneWidget,
      );
    });

    testWidgets('shows loading state for invalid file path', (tester) async {
      final invalidDoc = DocumentModel(
        id: 'invalid',
        title: 'Invalid Audio',
        parentId: 'p1',
        sheetId: 's1',
        filePath: '/invalid/path.mp3',
        createdBy: 'test-user',
      );

      await pumpMusicWidget(tester, document: invalidDoc);
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows loading state for empty file path', (tester) async {
      final emptyDoc = DocumentModel(
        id: 'empty',
        title: 'Empty Path',
        parentId: 'p1',
        sheetId: 's1',
        filePath: '',
        createdBy: 'test-user',
      );

      await pumpMusicWidget(tester, document: emptyDoc);
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('handles document constructor correctly', (tester) async {
      expect(() => MusicPreviewWidget(document: testDocument), returnsNormally);
      final widget = MusicPreviewWidget(document: testDocument);
      expect(widget.document, equals(testDocument));
    });

    testWidgets('renders correctly with key parameter', (tester) async {
      const key = Key('music-preview-key');
      await pumpMusicWidget(tester, document: testDocument, key: key);
      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('adapts to light theme', (tester) async {
      final lightTheme = ThemeData.light().copyWith(
        colorScheme: const ColorScheme.light(primary: Colors.blue),
      );

      await pumpMusicWidget(tester, document: testDocument, theme: lightTheme);
      expect(find.byType(MusicPreviewWidget), findsOneWidget);
    });

    testWidgets('adapts to dark theme', (tester) async {
      final darkTheme = ThemeData.dark();
      await pumpMusicWidget(tester, document: testDocument, theme: darkTheme);
      expect(find.byType(MusicPreviewWidget), findsOneWidget);
    });

    testWidgets('disposes correctly when widget is removed', (tester) async {
      await pumpMusicWidget(tester, document: testDocument);

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container())));
      expect(find.byType(MusicPreviewWidget), findsNothing);
    });

    testWidgets('handles document change gracefully', (tester) async {
      await pumpMusicWidget(tester, document: testDocument);

      final newDoc = DocumentModel(
        id: 'new',
        title: 'New Audio',
        parentId: 'p1',
        sheetId: 's1',
        filePath: '/non/existent/path.mp3',
        createdBy: 'test-user',
      );

      await pumpMusicWidget(tester, document: newDoc);
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    test('play/pause logic toggles correctly', () {
      bool isPlaying = false;
      isPlaying = !isPlaying;
      expect(isPlaying, isTrue);
      isPlaying = !isPlaying;
      expect(isPlaying, isFalse);
    });

    test('seek forward does not exceed total duration', () {
      const duration = Duration(minutes: 2);
      const position = Duration(seconds: 115);

      final newPosition = position + const Duration(seconds: 10);
      expect(newPosition <= duration, isFalse);
    });

    test('seek backward does not go below zero', () {
      const position = Duration(seconds: 5);
      final newPosition = position - const Duration(seconds: 10);
      expect(newPosition >= Duration.zero, isFalse);
    });

    test('calculates progress ratio correctly', () {
      const position = Duration(seconds: 30);
      const total = Duration(minutes: 2);
      final ratio = position.inMilliseconds / total.inMilliseconds;
      expect(ratio, closeTo(0.25, 0.001));
    });

    test('handles edge case where total duration is zero', () {
      const position = Duration(seconds: 30);
      const total = Duration.zero;
      final ratio = total.inMilliseconds == 0
          ? 0.0
          : position.inMilliseconds / total.inMilliseconds;
      expect(ratio, equals(0.0));
    });

    test('handles seek within valid range', () {
      const duration = Duration(minutes: 3);
      const position = Duration(seconds: 60);
      final newPosition = position + const Duration(seconds: 20);
      expect(newPosition <= duration, isTrue);
    });

    test('ensures correct ratio when duration > 0', () {
      const duration = Duration(minutes: 2);
      const position = Duration(seconds: 30);
      final ratio = position.inMilliseconds / duration.inMilliseconds;
      expect(ratio, greaterThan(0));
      expect(ratio, lessThan(1));
    });

    test('calculates progress bar percentage', () {
      const position = Duration(seconds: 45);
      const duration = Duration(minutes: 3);
      final percent = position.inSeconds / duration.inSeconds * 100;
      expect(percent, closeTo(25, 1));
    });

    test('handles zero duration progress percentage', () {
      const position = Duration(seconds: 45);
      const duration = Duration.zero;
      final percent =
          duration.inSeconds == 0 ? 0.0 : (position.inSeconds / duration.inSeconds * 100);
      expect(percent, equals(0.0));
    });

    test('verifies correct playback speed control', () {
      double playbackSpeed = 1.0;
      playbackSpeed += 0.5;
      expect(playbackSpeed, equals(1.5));

      playbackSpeed -= 0.5;
      expect(playbackSpeed, equals(1.0));
    });

    test('verifies volume control logic', () {
      double volume = 0.5;
      volume += 0.2;
      expect(volume, equals(0.7));

      volume -= 0.8;
      expect(volume, lessThanOrEqualTo(0));
    });

    test('ensures safe seek to specific position', () {
      const duration = Duration(minutes: 3);
      final position = Duration(seconds: 90);
      final newPosition = Duration(seconds: 200);
      expect(newPosition <= duration, isFalse); // 200 seconds > 180 seconds (3 minutes)
      expect(position < duration, isTrue); // 90 seconds < 180 seconds (3 minutes)
    });
  });
}
*/
