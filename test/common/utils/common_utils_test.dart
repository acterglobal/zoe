import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoe/common/utils/common_utils.dart';
import '../../test-utils/test_utils.dart';

void main() {
  group('CommonUtils', () {

    group('generateRandomId', () {
      test('generates unique non-empty IDs', () {
        final id1 = CommonUtils.generateRandomId();
        final id2 = CommonUtils.generateRandomId();

        expect(id1, isNotEmpty);
        expect(id2, isNotEmpty);
        expect(id1, isNot(equals(id2)));
      });

      test('matches UUID v4 format', () {
        final id = CommonUtils.generateRandomId();
        final uuidRegex = RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        );
        expect(uuidRegex.hasMatch(id), isTrue);
      });

      test('produces unique IDs across multiple generations', () {
        final ids = List.generate(10, (_) => CommonUtils.generateRandomId());
        expect(ids.toSet().length, equals(ids.length));
      });
    });

    group('desktopPlatforms', () {
      test('contains macOS, Linux, and Windows', () {
        const expected = [
          TargetPlatform.macOS,
          TargetPlatform.linux,
          TargetPlatform.windows,
        ];
        expect(CommonUtils.desktopPlatforms, equals(expected));
      });

      test('is a constant list of three platforms', () {
        expect(CommonUtils.desktopPlatforms, isA<List<TargetPlatform>>());
        expect(CommonUtils.desktopPlatforms.length, equals(3));
      });
    });

    group('isDesktop', () {
      testWidgets('returns true for desktop platforms', (tester) async {
        for (final platform in CommonUtils.desktopPlatforms) {
          await tester.pumpMaterialWidget(
            child: Builder(
              builder: (context) {
                expect(CommonUtils.isDesktop(context), isTrue);
                return Container();
              },
            ),
            theme: ThemeData(platform: platform),
          );
        }
      });

      testWidgets('returns false for mobile platforms', (tester) async {
        const mobile = [TargetPlatform.android, TargetPlatform.iOS];
        for (final platform in mobile) {
          await tester.pumpMaterialWidget(
            child: Builder(
              builder: (context) {
                expect(CommonUtils.isDesktop(context), isFalse);
                return Container();
              },
            ),
            theme: ThemeData(platform: platform),
          );
        }
      });
    });
    group('getUrlWithProtocol', () {
      test('adds https:// to URLs missing protocol', () {
        expect(CommonUtils.getUrlWithProtocol('example.com'),
            equals('https://example.com'));
        expect(CommonUtils.getUrlWithProtocol('google.com'),
            equals('https://google.com'));
      });

      test('preserves http:// and https:// URLs', () {
        expect(CommonUtils.getUrlWithProtocol('http://example.com'),
            equals('http://example.com'));
        expect(CommonUtils.getUrlWithProtocol('https://secure.com'),
            equals('https://secure.com'));
      });

      test('handles URLs with paths, params, and ports', () {
        expect(CommonUtils.getUrlWithProtocol('example.com:8080'),
            equals('https://example.com:8080'));
        expect(CommonUtils.getUrlWithProtocol('api.example.com/v1?id=123'),
            equals('https://api.example.com/v1?id=123'));
      });

      test('handles empty string gracefully', () {
        expect(CommonUtils.getUrlWithProtocol(''), equals('https://'));
      });
    });

    group('getRandomColorFromName', () {
      late CommonUtils utils;

      setUp(() => utils = CommonUtils());

      test('returns valid color from list', () {
        final colors = [
          Colors.pink,
          Colors.purple,
          Colors.deepPurple,
          Colors.indigo,
          Colors.blue,
          Colors.lightBlue,
          Colors.cyan,
          Colors.teal,
          Colors.green,
          Colors.lightGreen,
          Colors.deepOrange,
          Colors.brown,
        ];
        final color = utils.getRandomColorFromName('test');
        expect(colors.contains(color), isTrue);
      });

      test('returns consistent color for same name', () {
        expect(utils.getRandomColorFromName('Alice'),
            equals(utils.getRandomColorFromName('Alice')));
      });

      test('handles empty, special, unicode, and long names', () {
        expect(utils.getRandomColorFromName(''), isA<Color>());
        expect(utils.getRandomColorFromName('User@123!'), isA<Color>());
        expect(utils.getRandomColorFromName('用户🎉'), isA<Color>());
        expect(utils.getRandomColorFromName('A' * 1000), isA<Color>());
      });
    });

    group('showSnackBar', () {
      testWidgets('displays message correctly', (tester) async {
        const message = 'Snack message';
        await tester.pumpMaterialWidget(
          child: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                CommonUtils.showSnackBar(context, message);
              });
              return Container();
            },
          ),
        );
        await tester.pump();
        expect(find.text(message), findsOneWidget);
        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('handles empty message gracefully', (tester) async {
        await tester.pumpMaterialWidget(
          child: Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                CommonUtils.showSnackBar(context, '');
              });
              return Container();
            },
          ),
        );
        await tester.pump();
        expect(find.byType(SnackBar), findsOneWidget);
      });
    });

    group('shareText', () {
      test('exists and callable', () {
        expect(CommonUtils.shareText, isA<Function>());
      });
    });

    group('findAncestorWidgetOfExactType', () {
      testWidgets('finds Scaffold ancestor', (tester) async {
        await tester.pumpMaterialWidget(
          child: Builder(
            builder: (context) {
              final ancestor =
                  CommonUtils.findAncestorWidgetOfExactType<Scaffold>(context);
              expect(ancestor, isA<Scaffold>());
              return Container();
            },
          ),
        );
      });

      testWidgets('finds correct ancestor type (Column)', (tester) async {
        await tester.pumpMaterialWidget(
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  Builder(builder: (context) {
                    final col =
                        CommonUtils.findAncestorWidgetOfExactType<Column>(context);
                    expect(col, isA<Column>());
                    return Container();
                  }),
                ],
              );
            },
          ),
        );
      });
    });

    group('isKeyboardOpen', () {
      testWidgets('returns false when closed', (tester) async {
        await tester.pumpMaterialWidget(
          child: Builder(
            builder: (context) {
              expect(CommonUtils.isKeyboardOpen(context), isFalse);
              return Container();
            },
          ),
        );
      });

      testWidgets('returns true when open', (tester) async {
        await tester.pumpMaterialWidget(
          child: Builder(
            builder: (context) {
              final mq = MediaQuery.of(context).copyWith(
                viewInsets: const EdgeInsets.only(bottom: 300),
              );
              return MediaQuery(
                data: mq,
                child: Builder(builder: (context) {
                  expect(CommonUtils.isKeyboardOpen(context), isTrue);
                  return Container();
                }),
              );
            },
          ),
        );
      });

      testWidgets('handles multiple keyboard heights', (tester) async {
        for (final h in [100, 200, 300, 400, 500]) {
          await tester.pumpMaterialWidget(
            child: Builder(
              builder: (context) {
                final mq = MediaQuery.of(context).copyWith(
                  viewInsets: EdgeInsets.only(bottom: h.toDouble()),
                );
                return MediaQuery(
                  data: mq,
                  child: Builder(builder: (context) {
                    expect(CommonUtils.isKeyboardOpen(context), isTrue);
                    return Container();
                  }),
                );
              },
            ),
          );
        }
      });
    });

    group('openUrl', () {
      testWidgets('returns false for invalid and empty URLs', (tester) async {
        await tester.pumpMaterialWidget(
          child: Builder(
            builder: (context) {
              CommonUtils.openUrl('invalid', context).then((v) => expect(v, isFalse));
              CommonUtils.openUrl('', context).then((v) => expect(v, isFalse));
              return Container();
            },
          ),
        );
      });

      testWidgets('handles valid URLs safely', (tester) async {
        await tester.pumpMaterialWidget(
          child: Builder(
            builder: (context) {
              CommonUtils.openUrl('https://example.com', context)
                  .then((v) => expect(v, isA<bool>()));
              return Container();
            },
          ),
        );
      });

      testWidgets('handles different launch modes', (tester) async {
        await tester.pumpMaterialWidget(
          child: Builder(
            builder: (context) {
              CommonUtils.openUrl('https://example.com', context,
                      mode: LaunchMode.externalApplication)
                  .then((v) => expect(v, isA<bool>()));

              CommonUtils.openUrl('https://example.com', context,
                      mode: LaunchMode.platformDefault)
                  .then((v) => expect(v, isA<bool>()));
              return Container();
            },
          ),
        );
      });
    });

    group('Edge Cases & Integration', () {
      test('handles null-like and long inputs', () {
        final longStr = 'A' * 10000;
        final utils = CommonUtils();

        expect(() => CommonUtils.generateRandomId(), returnsNormally);
        expect(() => CommonUtils.getUrlWithProtocol(' '), returnsNormally);
        expect(() => utils.getRandomColorFromName(longStr), returnsNormally);
      });

      test('handles special chars & unicode', () {
        final utils = CommonUtils();
        for (final n in ['用户', '🎉🚀✨', 'User@123!', 'नमस्ते', 'مرحبا']) {
          expect(() => utils.getRandomColorFromName(n), returnsNormally);
        }
      });

      testWidgets('integration of all methods in widget', (tester) async {
        await tester.pumpMaterialWidget(
          child: Builder(
            builder: (context) {
              final id = CommonUtils.generateRandomId();
              expect(id, isNotEmpty);

              expect(CommonUtils.isDesktop(context), isA<bool>());
              expect(CommonUtils.getUrlWithProtocol('example.com'),
                  equals('https://example.com'));

              final color =
                  CommonUtils().getRandomColorFromName('Integration User');
              expect(color, isA<Color>());

              expect(CommonUtils.isKeyboardOpen(context), isA<bool>());
              return Container();
            },
          ),
        );
      });

      test('consistent color across instances', () {
        final c1 = CommonUtils().getRandomColorFromName('Alice');
        final c2 = CommonUtils().getRandomColorFromName('Alice');
        expect(c1, equals(c2));
      });
    });
  });
}
