import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart' as sheet_model;
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_list_widget.dart';

import '../utils/sheet_utils.dart';

void main() {
  group('SheetListWidget Tests', () {
    late ProviderContainer container;
    late SheetModel testSheet;

    setUp(() {
      container = ProviderContainer.test();
      testSheet = getSheetByIndex(container);
    });

    group('Widget Properties', () {
      testWidgets('creates widget with default properties', (tester) async {
        const widget = SheetListWidget(sheetsProvider: sheetListProvider);
        
        expect(widget.shrinkWrap, isFalse);
        expect(widget.isCompact, isFalse);
        expect(widget.maxItems, isNull);
        expect(widget.showSectionHeader, isFalse);
        expect(widget.emptyState, isA<SizedBox>());
      });

      testWidgets('creates widget with custom properties', (tester) async {
        const customEmptyState = Text('Custom empty state');
        const widget = SheetListWidget(
          sheetsProvider: sheetListProvider,
          shrinkWrap: true,
          isCompact: true,
          maxItems: 5,
          showSectionHeader: true,
          emptyState: customEmptyState,
        );
        
        expect(widget.shrinkWrap, isTrue);
        expect(widget.isCompact, isTrue);
        expect(widget.maxItems, equals(5));
        expect(widget.showSectionHeader, isTrue);
        expect(widget.emptyState, equals(customEmptyState));
      });
    });

    group('Provider Integration', () {
      testWidgets('uses correct provider', (tester) async {
        const widget = SheetListWidget(sheetsProvider: sheetListProvider);
        expect(widget.sheetsProvider, equals(sheetListProvider));   
      });

      testWidgets('handles different providers', (tester) async {
        final customProvider = Provider<List<sheet_model.SheetModel>>((ref) => [testSheet]);
        final widget = SheetListWidget(sheetsProvider: customProvider);
        expect(widget.sheetsProvider, equals(customProvider));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles null maxItems', (tester) async {
        const widget = SheetListWidget(
          sheetsProvider: sheetListProvider,
          maxItems: null,
        );
        expect(widget.maxItems, isNull);
      });

      testWidgets('handles zero maxItems', (tester) async {
        const widget = SheetListWidget(
          sheetsProvider: sheetListProvider,
          maxItems: 0,
        );
        expect(widget.maxItems, equals(0));
      });

      testWidgets('handles large maxItems', (tester) async {
        const widget = SheetListWidget(
          sheetsProvider: sheetListProvider,
          maxItems: 1000,
        );
        expect(widget.maxItems, equals(1000));
      });
    });

    group('Widget Properties Comparison', () {
      testWidgets('widgets with same properties have same values', (tester) async {
        const widget1 = SheetListWidget(sheetsProvider: sheetListProvider);
        const widget2 = SheetListWidget(sheetsProvider: sheetListProvider);
        
        expect(widget1.shrinkWrap, equals(widget2.shrinkWrap));
        expect(widget1.isCompact, equals(widget2.isCompact));
        expect(widget1.maxItems, equals(widget2.maxItems));
        expect(widget1.showSectionHeader, equals(widget2.showSectionHeader));
      });

      testWidgets('widgets with different properties have different values', (tester) async {
        const widget1 = SheetListWidget(sheetsProvider: sheetListProvider);
        const widget2 = SheetListWidget(
          sheetsProvider: sheetListProvider,
          shrinkWrap: true,
        );
        
        expect(widget1.shrinkWrap, isNot(equals(widget2.shrinkWrap)));
        expect(widget1.isCompact, equals(widget2.isCompact));
        expect(widget1.maxItems, equals(widget2.maxItems));
        expect(widget1.showSectionHeader, equals(widget2.showSectionHeader));
      });
    });

    group('Widget Type', () {
      testWidgets('is a ConsumerWidget', (tester) async {
        const widget = SheetListWidget(sheetsProvider: sheetListProvider);
        expect(widget, isA<ConsumerWidget>());
      });
    });

    group('Constructor Validation', () {
      testWidgets('accepts valid sheetsProvider', (tester) async {
        expect(
          () => const SheetListWidget(sheetsProvider: sheetListProvider),
          returnsNormally,
        );
      });
    });

    group('Property Validation', () {
      testWidgets('validates shrinkWrap property', (tester) async {
        const widgetTrue = SheetListWidget(
          sheetsProvider: sheetListProvider,
          shrinkWrap: true,
        );
        const widgetFalse = SheetListWidget(
          sheetsProvider: sheetListProvider,
          shrinkWrap: false,
        );
        
        expect(widgetTrue.shrinkWrap, isTrue);
        expect(widgetFalse.shrinkWrap, isFalse);
      });

      testWidgets('validates isCompact property', (tester) async {
        const widgetTrue = SheetListWidget(
          sheetsProvider: sheetListProvider,
          isCompact: true,
        );
        const widgetFalse = SheetListWidget(
          sheetsProvider: sheetListProvider,
          isCompact: false,
        );
        
        expect(widgetTrue.isCompact, isTrue);
        expect(widgetFalse.isCompact, isFalse);
      });

      testWidgets('validates showSectionHeader property', (tester) async {
        const widgetTrue = SheetListWidget(
          sheetsProvider: sheetListProvider,
          showSectionHeader: true,
        );
        const widgetFalse = SheetListWidget(
          sheetsProvider: sheetListProvider,
          showSectionHeader: false,
        );
        
        expect(widgetTrue.showSectionHeader, isTrue);
        expect(widgetFalse.showSectionHeader, isFalse);
      });

      testWidgets('validates maxItems property', (tester) async {
        const widgetNull = SheetListWidget(
          sheetsProvider: sheetListProvider,
          maxItems: null,
        );
        const widgetZero = SheetListWidget(
          sheetsProvider: sheetListProvider,
          maxItems: 0,
        );
        const widgetPositive = SheetListWidget(
          sheetsProvider: sheetListProvider,
          maxItems: 10,
        );
        
        expect(widgetNull.maxItems, isNull);
        expect(widgetZero.maxItems, equals(0));
        expect(widgetPositive.maxItems, equals(10));
      });

      testWidgets('validates emptyState property', (tester) async {
        const defaultEmptyState = SheetListWidget(sheetsProvider: sheetListProvider);
        const customEmptyState = SheetListWidget(
          sheetsProvider: sheetListProvider,
          emptyState: Text('Custom empty'),
        );
        
        expect(defaultEmptyState.emptyState, isA<SizedBox>());
        expect(customEmptyState.emptyState, isA<Text>());
      });
    });

    group('Provider Data Access', () {
      testWidgets('can access provider data', (tester) async {
        final providerData = container.read(sheetListProvider);
        expect(providerData, isA<List<sheet_model.SheetModel>>());
        expect(providerData.length, greaterThan(0));
      });

      testWidgets('provider contains expected sheet models', (tester) async {
        final providerData = container.read(sheetListProvider);
        expect(providerData.first, isA<sheet_model.SheetModel>());
        expect(providerData.first.id, isNotEmpty);
        expect(providerData.first.title, isNotEmpty);
      });
    });
  });
}