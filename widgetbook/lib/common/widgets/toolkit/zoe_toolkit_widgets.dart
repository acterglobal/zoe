import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
// Import Zoe widgets
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/common/widgets/toolkit/zoe_secondary_button.dart';
import 'package:zoe/common/widgets/toolkit/zoe_floating_action_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_icon_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_search_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_glassy_tab_widget.dart';

// Primary Button Widgets
@widgetbook.UseCase(name: 'Default', type: ZoePrimaryButton)
Widget buildZoePrimaryButtonUseCase(BuildContext context) {
  return ZoePrimaryButton(
    text: context.knobs.string(
      label: 'Button Text',
      description: 'The text displayed on the button',
      initialValue: 'Primary Action',
    ),
    onPressed: () => print('Primary button pressed'),
  );
}

@widgetbook.UseCase(name: 'Loading', type: ZoePrimaryButton)
Widget buildZoePrimaryButtonLoadingUseCase(BuildContext context) {
  return ZoePrimaryButton(
    text: context.knobs.string(
      label: 'Button Text',
      description: 'The text displayed on the button',
      initialValue: 'Saving...',
    ),
    onPressed: () => print('Loading button pressed'),
  );
}

@widgetbook.UseCase(name: 'Disabled', type: ZoePrimaryButton)
Widget buildZoePrimaryButtonDisabledUseCase(BuildContext context) {
  return ZoePrimaryButton(
    text: context.knobs.string(
      label: 'Button Text',
      description: 'The text displayed on the button',
      initialValue: 'Disabled Action',
    ),
    onPressed: () {},
  );
}

// Secondary Button Widgets
@widgetbook.UseCase(name: 'Default', type: ZoeSecondaryButton)
Widget buildZoeSecondaryButtonUseCase(BuildContext context) {
  return ZoeSecondaryButton(
    text: context.knobs.string(
      label: 'Button Text',
      description: 'The text displayed on the button',
      initialValue: 'Secondary Action',
    ),
    onPressed: () => print('Secondary button pressed'),
  );
}

@widgetbook.UseCase(name: 'Disabled', type: ZoeSecondaryButton)
Widget buildZoeSecondaryButtonDisabledUseCase(BuildContext context) {
  return ZoeSecondaryButton(
    text: context.knobs.string(
      label: 'Button Text',
      description: 'The text displayed on the button',
      initialValue: 'Disabled Secondary',
    ),
    onPressed: () {},
  );
}

// Floating Action Button Widgets
@widgetbook.UseCase(name: 'Default', type: ZoeFloatingActionButton)
Widget buildZoeFloatingActionButtonUseCase(BuildContext context) {
  return ZoeFloatingActionButton(
    onPressed: () => print('FAB pressed'),
    icon: Icons.add,
  );
}

@widgetbook.UseCase(name: 'With Custom Icon', type: ZoeFloatingActionButton)
Widget buildZoeFloatingActionButtonWithCustomIconUseCase(BuildContext context) {
  return ZoeFloatingActionButton(
    onPressed: () => print('Custom FAB pressed'),
    icon: Icons.edit,
  );
}

// Icon Button Widgets
@widgetbook.UseCase(name: 'Default', type: ZoeIconButtonWidget)
Widget buildZoeIconButtonWidgetUseCase(BuildContext context) {
  return ZoeIconButtonWidget(
    icon: Icons.favorite,
    onTap: () => print('Icon button pressed'),
  );
}

@widgetbook.UseCase(name: 'Large', type: ZoeIconButtonWidget)
Widget buildZoeIconButtonWidgetLargeUseCase(BuildContext context) {
  return ZoeIconButtonWidget(
    icon: Icons.star,
    size: 32,
    padding: 16,
    onTap: () => print('Large icon button pressed'),
  );
}

// App Bar Widgets
@widgetbook.UseCase(name: 'Default', type: ZoeAppBar)
Widget buildZoeAppBarUseCase(BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: ZoeAppBar(
      title: context.knobs.string(
        label: 'Title',
        description: 'The title displayed in the app bar',
        initialValue: 'Zoe',
      ),
      showBackButton: context.knobs.boolean(
        label: 'Show Back Button',
        description: 'Whether to show the back button',
        initialValue: false,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'With Actions', type: ZoeAppBar)
Widget buildZoeAppBarWithActionsUseCase(BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: ZoeAppBar(
      title: 'Zoe',
      showBackButton: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => print('Search pressed'),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => print('More pressed'),
        ),
      ],
    ),
  );
}

// Search Bar Widgets
@widgetbook.UseCase(name: 'Default', type: ZoeSearchBarWidget)
Widget buildZoeSearchBarWidgetUseCase(BuildContext context) {
  return ZoeSearchBarWidget(
    controller: TextEditingController(),
    onChanged: (value) => print('Search: $value'),
    hintText: context.knobs.string(
      label: 'Hint Text',
      description: 'The placeholder text for the search bar',
      initialValue: 'Search...',
    ),
  );
}

@widgetbook.UseCase(name: 'With Callback', type: ZoeSearchBarWidget)
Widget buildZoeSearchBarWidgetWithCallbackUseCase(BuildContext context) {
  return ZoeSearchBarWidget(
    controller: TextEditingController(),
    onChanged: (value) => print('Search changed to: $value'),
    hintText: 'Search your content...',
  );
}

// Glassy Tab Widgets
@widgetbook.UseCase(name: 'Default', type: ZoeGlassyTabWidget)
Widget buildZoeGlassyTabWidgetUseCase(BuildContext context) {
  return ZoeGlassyTabWidget(
    tabTexts: ['Tab 1', 'Tab 2', 'Tab 3'],
    selectedIndex: context.knobs.int.slider(
      label: 'Selected Index',
      description: 'The currently selected tab index',
      initialValue: 0,
      min: 0,
      max: 2,
      divisions: 2,
    ),
    onTabChanged: (index) => print('Tab changed to: $index'),
  );
}

@widgetbook.UseCase(name: 'With More Tabs', type: ZoeGlassyTabWidget)
Widget buildZoeGlassyTabWidgetWithMoreTabsUseCase(BuildContext context) {
  return ZoeGlassyTabWidget(
    tabTexts: ['Home', 'Sheets', 'Events', 'Tasks', 'Settings'],
    selectedIndex: context.knobs.int.slider(
      label: 'Selected Index',
      description: 'The currently selected tab index',
      initialValue: 0,
      min: 0,
      max: 4,
      divisions: 4,
    ),
    onTabChanged: (index) => print('Tab changed to: $index'),
  );
}
