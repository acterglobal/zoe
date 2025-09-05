import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/features/home/zoe_preview_widget.dart';
import 'package:zoe/features/home/screens/home_screen.dart';
import 'package:zoe/features/quick-search/screens/quick_search_screen.dart';
import 'package:zoe/features/quick-search/widgets/quick_search_tab_section_header_widget.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/users/widgets/user_list_widget.dart';
import 'package:zoe/features/sheet/screens/sheet_detail_screen.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/widgets/user_widget.dart';


@widgetbook.UseCase(name: 'Zoe Home Screen', type: HomeScreen)
Widget buildZoeHomeScreenUseCase(BuildContext context) {
  return ZoePreview(child: HomeScreen());
}


@widgetbook.UseCase(name: 'Sheet Detail Screen', type: SheetDetailScreen)
Widget buildSheetDetailScreenUseCase(BuildContext context) {
  final sheetId = context.knobs.string(
    label: 'Sheet ID',
    initialValue: 'sheet-1',
  );

  return ZoePreview(child: SheetDetailScreen(sheetId: sheetId));
}


// Quick Search
@widgetbook.UseCase(
  name: 'Quick Search Tab Section Header Widget',
  type: QuickSearchTabSectionHeaderWidget,
)
Widget buildQuickSearchTabSectionHeaderWidgetUseCase(BuildContext context) {
  return ZoePreview(
    child: QuickSearchTabSectionHeaderWidget(
      title: 'Quick Search',
      icon: Icons.search,
      onTap: () {},
      color: Colors.blueAccent,
    ),
  );
}

@widgetbook.UseCase(name: 'Quick Search Screen', type: QuickSearchScreen)
Widget buildQuickSearchScreenUseCase(BuildContext context) {
  return ZoePreview(child: QuickSearchScreen());
}

// User
@widgetbook.UseCase(name: 'User Widget', type: UserWidget)
Widget buildUserWidgetUseCase(BuildContext context) {
  final userId = context.knobs.string(label: 'User ID', initialValue: 'user_1');

  return ZoePreview(child: UserWidget(userId: userId));
}

@widgetbook.UseCase(name: 'User List Widget', type: UserListWidget)
Widget buildUserListWidgetUseCase(BuildContext context) {
  final userIds = context.knobs.object.dropdown(
    label: 'User IDs',
    options: [
      UserModel(id: 'user_1', name: 'User 1'),
      UserModel(id: 'user_2', name: 'User 2'),
    ],
    labelBuilder: (user) => user.name,
  );
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Users',
    description: 'Title of the user list',
  );

  return Consumer(
    builder: (context, ref, _) {
      return ProviderScope(
        overrides: [
          // Create a provider that returns the list of user IDs
          listOfUsersBySheetIdProvider.overrideWith(
            (ref, sheetId) => [userIds.id],
          ),
        ],
        child: ZoePreview(
          child: UserListWidget(
            userIdList: Provider<List<String>>((ref) => [userIds.id]),
            title: title,
          ),
        ),
      );
    },
  );
}
