import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/animated_background_widget.dart';
import 'package:zoe/common/widgets/drawer/hamburger_drawer_widget.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/qr_scan_bottom_sheet.dart';
import 'package:zoe/common/widgets/toolkit/zoe_floating_action_button_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_icon_button_widget.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/home/widgets/section_header/section_header_widget.dart';
import 'package:zoe/features/home/widgets/stats_section/stats_section_widget.dart';
import 'package:zoe/features/home/widgets/today_focus/todays_focus_widget.dart';
import 'package:zoe/features/home/widgets/welcome_section/welcome_section_widget.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_list_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedBackgroundWidget(
      backgroundOpacity: 0.2,
      child: Scaffold(
        appBar: _buildAppBar(context),
        drawer: const HamburgerDrawerWidget(),
        floatingActionButton: _buildFloatingActionButton(context, ref),
        body: _buildBody(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leadingWidth: 100,
      actionsPadding: const EdgeInsets.only(right: 16),
      leading: Builder(
        builder: (context) => Center(
          child: Row(
            children: [
              const SizedBox(width: 16),
              ZoeIconButtonWidget(
                icon: Icons.menu_rounded,
                onTap: () => Scaffold.of(context).openDrawer(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        // const ConnectionStatusWidget(),
        if (Platform.isAndroid || Platform.isIOS) _buildQrScanButton(context),
        _buildSearchButton(context),
      ],
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return ZoeIconButtonWidget(
      icon: Icons.search_outlined,
      onTap: () {
        context.push(AppRoutes.quickSearch.route);
      },
    );
  }

  Widget _buildQrScanButton(BuildContext context) {
    return Row(
      children: [
        ZoeIconButtonWidget(
          icon: Icons.qr_code_rounded,
          onTap: () => showQrScanBottomSheet(
            context: context,
            onDetect: (barcodes) {
              final rawValue = barcodes.barcodes.first.rawValue;
              if (rawValue == null) return;
              CommonUtils.showSnackBar(context, rawValue);
              context.pop();
            },
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Center(
        child: MaxWidthWidget(
          isScrollable: true,
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              const WelcomeSectionWidget(),
              const SizedBox(height: 16),
              const StatsSectionWidget(),
              const TodaysFocusWidget(),
              const SizedBox(height: 32),
              _buildSheetsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    return ZoeFloatingActionButton(
      icon: Icons.add_rounded,
      onPressed: () async {
        final sheet = SheetModel();
        ref.read(sheetListProvider.notifier).addSheet(sheet);
        ref.read(editContentIdProvider.notifier).state = sheet.id;
        context.push(AppRoutes.sheet.route.replaceAll(':sheetId', sheet.id));
      },
    );
  }

  Widget _buildSheetsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: L10n.of(context).recentSheets,
          icon: Icons.description,
        ),
        const SizedBox(height: 16),
        SheetListWidget(
          sheetsProvider: sheetListProvider,
          shrinkWrap: true,
          maxItems: 3,
        ),
        const SizedBox(height: 100), // Space for FAB
      ],
    );
  }
}
