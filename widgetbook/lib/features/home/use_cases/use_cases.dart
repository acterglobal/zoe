import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/features/home/zoe_preview_widget.dart';
import 'package:zoe/features/home/widgets/stats_section/stats_section_widget.dart';
import 'package:zoe/features/home/widgets/today_focus/todays_focus_widget.dart';
import 'package:zoe/features/home/widgets/welcome_section/welcome_section_widget.dart';
import 'package:zoe/features/sheet/widgets/sheet_list_widget.dart';

@widgetbook.UseCase(name: 'Welcome Section', type: WelcomeSectionWidget)
Widget buildWelcomeSectionUseCase(BuildContext context) {
  return const ZoePreview(
    child: WelcomeSectionWidget(),
  );
}

@widgetbook.UseCase(name: 'Stats Section', type: StatsSectionWidget)
Widget buildStatsSectionUseCase(BuildContext context) {
  return const ZoePreview(
    child: StatsSectionWidget(),
  );
}

@widgetbook.UseCase(name: 'Today\'s Focus', type: TodaysFocusWidget)
Widget buildTodaysFocusUseCase(BuildContext context) {
  return const ZoePreview(
    child: TodaysFocusWidget(),
  );
}

@widgetbook.UseCase(name: 'Sheet List', type: SheetListWidget)
Widget buildSheetListUseCase(BuildContext context) {
  final shrinkWrap = context.knobs.boolean(
    label: 'Shrink Wrap',
    initialValue: true,
  );

  final isCompact = context.knobs.boolean(
    label: 'Is Compact',
    initialValue: false,
  );

  final maxItems = context.knobs.int.slider(
    label: 'Max Items',
    initialValue: 3,
    min: 1,
    max: 10,
  );

  return ZoePreview(
    child: SheetListWidget(
      shrinkWrap: shrinkWrap,
      isCompact: isCompact,
      maxItems: maxItems,
    ),
  );
}
