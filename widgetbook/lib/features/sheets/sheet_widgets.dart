import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/features/mock/mock_preview.dart';
import 'package:widgetbook_workspace/features/mock/mock_providers.dart';
// Import Zoe widgets
import 'package:zoe/common/widgets/styled_content_container_widget.dart';
import 'package:zoe/features/sheet/screens/sheet_detail_screen.dart';
import 'package:zoe/features/sheet/screens/sheet_list_screen.dart';
import 'package:zoe/features/sheet/widgets/sheet_list_item_widget.dart';


final sheetWidgets = WidgetbookComponent(
  name: 'Sheets',
  useCases: [
    WidgetbookUseCase(
      name: 'Sheet List',
      builder: (context) {
        return MockPreview(
          child: ProviderScope(
            overrides: [
              MockProviders.mockSheetListProvider.overrideWith(
                (ref) => MockSheetNotifier(),
              ),
            ],
            child: const SheetListScreen(),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Sheet Detail',
      builder: (context) {
        return MockPreview(
          child: ProviderScope(
            overrides: [
              MockProviders.mockSheetListProvider.overrideWith(
                (ref) => MockSheetNotifier(),
              ),
            ],
            child: const SheetDetailScreen(sheetId: 'mock-sheet-1'),
          ),
        );
      },
    ),
  ],
);

// Sheet List Item Widgets
@widgetbook.UseCase(name: 'Sheet List Item', type: SheetListItemWidget)
Widget buildSheetListItemUseCase(BuildContext context) {
  final sheetId = context.knobs.string(
    label: 'Sheet ID',
    description: 'The ID of the sheet to display',
    initialValue: 'sheet-1',
  );
  
  final isCompact = context.knobs.boolean(
    label: 'Is Compact',
    description: 'Whether to show compact design',
    initialValue: false,
  );

  return SheetListItemWidget(
    sheetId: sheetId,
    isCompact: isCompact,
  );
}

@widgetbook.UseCase(name: 'Compact Sheet Item', type: SheetListItemWidget)
Widget buildCompactSheetListItemUseCase(BuildContext context) {
  return SheetListItemWidget(
    sheetId: 'sheet-2',
    isCompact: true,
  );
}

// Styled Content Container Widgets
@widgetbook.UseCase(name: 'Default', type: StyledContentContainer)
Widget buildStyledContentContainerUseCase(BuildContext context) {
  final size = context.knobs.string(
    label: 'Size',
    description: 'The size of the container (24-100)',
    initialValue: '56',
  );
  
  final primaryColor = context.knobs.color(
    label: 'Primary Color',
    description: 'The primary color of the container',
    initialValue: const Color(0xFF8B5CF6),
  );

  return StyledContentContainer(
    size: double.tryParse(size) ?? 56,
    primaryColor: primaryColor,
    backgroundOpacity: 0.1,
    borderOpacity: 0.10,
    shadowOpacity: 0.06,
    child: const Text('📝', style: TextStyle(fontSize: 24)),
  );
}

@widgetbook.UseCase(name: 'Small Container', type: StyledContentContainer)
Widget buildSmallStyledContentContainerUseCase(BuildContext context) {
  return StyledContentContainer(
    size: 34,
    primaryColor: const Color(0xFFEC4899),
    backgroundOpacity: 0.1,
    borderOpacity: 0.10,
    shadowOpacity: 0.06,
    child: const Text('📝', style: TextStyle(fontSize: 18)),
  );
}

@widgetbook.UseCase(name: 'Large Container', type: StyledContentContainer)
Widget buildLargeStyledContentContainerUseCase(BuildContext context) {
  return StyledContentContainer(
    size: 80,
    primaryColor: const Color(0xFF10B981),
    backgroundOpacity: 0.1,
    borderOpacity: 0.10,
    shadowOpacity: 0.06,
    child: const Text('📝', style: TextStyle(fontSize: 32)),
  );
}
