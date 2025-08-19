import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/drawer/drawer_header_widget.dart';
import 'package:zoe/common/widgets/drawer/drawer_sheet_list_widget.dart';
import 'package:zoe/common/widgets/drawer/drawer_settings_widget.dart';

class HamburgerDrawerWidget extends ConsumerWidget {
  const HamburgerDrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const DrawerHeaderWidget(),
            const Divider(),
            Expanded(child: DrawerSheetListWidget()),
            const Divider(),
            const DrawerSettingsWidget(),
          ],
        ),
      ),
    );
  }
}
