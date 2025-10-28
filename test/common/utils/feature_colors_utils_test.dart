import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/utils/feature_colors_utils.dart';
import '../../test-utils/test_utils.dart';

void main() {
  group('FeatureColorsUtils', () {
    // Test data
    const List<String> knownFeatures = [
      'organize',
      'plan', 
      'create',
      'settings',
      'profile',
    ];

    // Helper functions
    Future<void> pumpWithTheme(
      WidgetTester tester,
      Widget Function(BuildContext) builder, {
      ThemeData? theme,
    }) async {
      await tester.pumpMaterialWidget(
        child: Builder(builder: builder),
        theme: theme,
      );
    }

    void validateColorMap(Map<String, Color> colors) {
      expect(colors, isA<Map<String, Color>>());
      expect(colors.containsKey('primary'), isTrue);
      expect(colors.containsKey('secondary'), isTrue);
      expect(colors['primary'], isA<Color>());
      expect(colors['secondary'], isA<Color>());
    }

    group('getFeatureColors', () {
      group('Known Features', () {
        for (final feature in knownFeatures) {
          group(feature, () {
            testWidgets('returns colors for light theme', (tester) async {
              await pumpWithTheme(
                tester,
                (context) {
                  final colors = FeatureColorsUtils.getFeatureColors(feature, context);
                  validateColorMap(colors);
                  return Container();
                },
              );
            });

            testWidgets('returns colors for dark theme', (tester) async {
              await pumpWithTheme(
                tester,
                (context) {
                  final colors = FeatureColorsUtils.getFeatureColors(feature, context);
                  validateColorMap(colors);
                  return Container();
                },
                theme: ThemeData.dark(),
              );
            });
          });
        }
      });

      group('Unknown Features', () {
        testWidgets('returns default colors for unknown feature', (tester) async {
          await pumpWithTheme(
            tester,
            (context) {
              final colors = FeatureColorsUtils.getFeatureColors('unknown', context);
              validateColorMap(colors);
              return Container();
            },
          );
        });

        testWidgets('returns default colors for empty feature name', (tester) async {
          await pumpWithTheme(
            tester,
            (context) {
              final colors = FeatureColorsUtils.getFeatureColors('', context);
              validateColorMap(colors);
              return Container();
            },
          );
        });
      });

      group('Case Sensitivity', () {
        testWidgets('handles case insensitive feature names', (tester) async {
          await pumpWithTheme(
            tester,
            (context) {
              for (final name in ['ORGANIZE', 'Organize', 'organize']) {
                final colors = FeatureColorsUtils.getFeatureColors(name, context);
                validateColorMap(colors);
              }
              return Container();
            },
          );
        });
      });

      group('Color Differentiation', () {
        testWidgets('returns different colors for different features', (tester) async {
          await pumpWithTheme(
            tester,
            (context) {
              final organizeColors = FeatureColorsUtils.getFeatureColors('organize', context);
              final planColors = FeatureColorsUtils.getFeatureColors('plan', context);
              final createColors = FeatureColorsUtils.getFeatureColors('create', context);
              
              expect(organizeColors['primary'], isNot(equals(planColors['primary'])));
              expect(planColors['primary'], isNot(equals(createColors['primary'])));
              expect(organizeColors['primary'], isNot(equals(createColors['primary'])));
              
              return Container();
            },
          );
        });
      });
    });

    group('getFeaturePrimaryColor', () {
      group('Known Features', () {
        for (final feature in knownFeatures) {
          testWidgets('returns primary color for $feature', (tester) async {
            await pumpWithTheme(
              tester,
              (context) {
                final primaryColor = FeatureColorsUtils.getFeaturePrimaryColor(feature, context);
                expect(primaryColor, isA<Color>());
                return Container();
              },
            );
          });
        }
      });

      group('Unknown Features', () {
        testWidgets('returns primary color for unknown feature', (tester) async {
          await pumpWithTheme(
            tester,
            (context) {
              final primaryColor = FeatureColorsUtils.getFeaturePrimaryColor('unknown', context);
              expect(primaryColor, isA<Color>());
              return Container();
            },
          );
        });
      });

      group('Case Sensitivity', () {
        testWidgets('handles case insensitive feature names', (tester) async {
          await pumpWithTheme(
            tester,
            (context) {
              for (final name in ['ORGANIZE', 'Organize', 'organize']) {
                final color = FeatureColorsUtils.getFeaturePrimaryColor(name, context);
                expect(color, isA<Color>());
              }
              return Container();
            },
          );
        });
      });
    });

    group('getFeatureSecondaryColor', () {
      testWidgets('returns secondary color for organize feature', (tester) async {
        await pumpWithTheme(
          tester,
          (context) {
            final secondaryColor = FeatureColorsUtils.getFeatureSecondaryColor('organize', context);
            expect(secondaryColor, isA<Color>());
            return Container();
          },
        );
      });

      testWidgets('returns secondary color for plan feature', (tester) async {
        await pumpWithTheme(
          tester,
          (context) {
            final secondaryColor = FeatureColorsUtils.getFeatureSecondaryColor('plan', context);
            expect(secondaryColor, isA<Color>());
            return Container();
          },
        );
      });

      testWidgets('returns secondary color for create feature', (tester) async {
        await pumpWithTheme(
          tester,
            (context) {
            final secondaryColor = FeatureColorsUtils.getFeatureSecondaryColor('create', context);
            expect(secondaryColor, isA<Color>());
            return Container();
          },
        );
      });

      testWidgets('returns secondary color for settings feature', (tester) async {
        await pumpWithTheme(
          tester,
          (context) {
            final secondaryColor = FeatureColorsUtils.getFeatureSecondaryColor('settings', context);
            expect(secondaryColor, isA<Color>());
            return Container();
          },
        );
      });

      testWidgets('returns secondary color for profile feature', (tester) async {
        await pumpWithTheme(
          tester,
          (context) {
            final secondaryColor = FeatureColorsUtils.getFeatureSecondaryColor('profile', context);
            expect(secondaryColor, isA<Color>());
            return Container();
          },
        );
      });

      testWidgets('returns secondary color for unknown feature', (tester) async {
        await pumpWithTheme(
          tester,
          (context) {
            final secondaryColor = FeatureColorsUtils.getFeatureSecondaryColor('unknown', context);
            expect(secondaryColor, isA<Color>());
            return Container();
          },
        );
      });

      testWidgets('handles case insensitive feature names', (tester) async {
        await pumpWithTheme(
          tester,
          (context) {
            final color1 = FeatureColorsUtils.getFeatureSecondaryColor('ORGANIZE', context);
            final color2 = FeatureColorsUtils.getFeatureSecondaryColor('Organize', context);
            final color3 = FeatureColorsUtils.getFeatureSecondaryColor('organize', context);
            
            expect(color1, isA<Color>());
            expect(color2, isA<Color>());
            expect(color3, isA<Color>());
            return Container();
          },
        );
      });
    });

    group('Theme Integration', () {
      testWidgets('uses theme colors for default case', (tester) async {
        await pumpWithTheme(
          tester,
          (context) {
            final colors = FeatureColorsUtils.getFeatureColors('unknown', context);
            validateColorMap(colors);
            return Container();
          },
        );
      });

      testWidgets('adapts to light theme', (tester) async {
        await pumpWithTheme(
          tester,
          (context) {
            final colors = FeatureColorsUtils.getFeatureColors('organize', context);
            validateColorMap(colors);
            return Container();
          },
          theme: ThemeData.light(),
        );
      });

      testWidgets('adapts to dark theme', (tester) async {
        await pumpWithTheme(
          tester,
          (context) {
            final colors = FeatureColorsUtils.getFeatureColors('organize', context);
            validateColorMap(colors);
            return Container();
          },
          theme: ThemeData.dark(),
        );
      });

      testWidgets('handles custom theme', (tester) async {
        final customTheme = ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        );
        
        await pumpWithTheme(
          tester,
          (context) {
            final colors = FeatureColorsUtils.getFeatureColors('unknown', context);
            validateColorMap(colors);
            return Container();
          },
          theme: customTheme,
        );
      });
    });

    group('Edge Cases & Integration', () {
      group('Special Feature Names', () {
        testWidgets('handles empty feature name', (tester) async {
          await pumpWithTheme(
            tester,
            (context) {
              final colors = FeatureColorsUtils.getFeatureColors('', context);
              validateColorMap(colors);
              return Container();
            },
          );
        });

        testWidgets('handles special characters in feature name', (tester) async {
          await pumpWithTheme(
            tester,
            (context) {
              final colors = FeatureColorsUtils.getFeatureColors('organize@123!', context);
              validateColorMap(colors);
              return Container();
            },
          );
        });

        testWidgets('handles unicode characters in feature name', (tester) async {
          await pumpWithTheme(
            tester,
            (context) {
              final colors = FeatureColorsUtils.getFeatureColors('组织', context);
              validateColorMap(colors);
              return Container();
            },
          );
        });

        testWidgets('handles very long feature names', (tester) async {
          await pumpWithTheme(
            tester,
            (context) {
              final longName = 'organize' * 100;
              final colors = FeatureColorsUtils.getFeatureColors(longName, context);
              validateColorMap(colors);
              return Container();
            },
          );
        });
      });

      group('Method Integration', () {
        testWidgets('integration of all methods in widget', (tester) async {
          await pumpWithTheme(
            tester,
            (context) {
              // Test all feature names
              final features = [...knownFeatures, 'unknown'];
              
              for (final feature in features) {
                // Test getFeatureColors
                final colors = FeatureColorsUtils.getFeatureColors(feature, context);
                validateColorMap(colors);
                
                // Test getFeaturePrimaryColor
                final primaryColor = FeatureColorsUtils.getFeaturePrimaryColor(feature, context);
                expect(primaryColor, isA<Color>());
                
                // Test getFeatureSecondaryColor
                final secondaryColor = FeatureColorsUtils.getFeatureSecondaryColor(feature, context);
                expect(secondaryColor, isA<Color>());
                
                // Verify consistency
                expect(primaryColor, equals(colors['primary']));
                expect(secondaryColor, equals(colors['secondary']));
              }
              
              return Container();
            },
          );
        });

        testWidgets('consistency across different themes', (tester) async {
          // Test light theme
          await pumpWithTheme(
            tester,
            (context) {
              final lightColors = FeatureColorsUtils.getFeatureColors('organize', context);
              validateColorMap(lightColors);
              return Container();
            },
            theme: ThemeData.light(),
          );
          
          // Test dark theme
          await pumpWithTheme(
            tester,
            (context) {
              final darkColors = FeatureColorsUtils.getFeatureColors('organize', context);
              validateColorMap(darkColors);
              return Container();
            },
            theme: ThemeData.dark(),
          );
        });
      });
    });
  });
}
