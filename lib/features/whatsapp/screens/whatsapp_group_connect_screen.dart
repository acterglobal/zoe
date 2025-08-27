import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/features/whatsapp/widgets/group_link_widget.dart';
import 'package:zoe/features/whatsapp/widgets/group_permission_widget.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/features/whatsapp/providers/whatsapp_group_connect_provider.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class WhatsAppGroupConnectScreen extends ConsumerWidget {
  final String sheetId;
  const WhatsAppGroupConnectScreen({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(ref));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: ZoeAppBar(
        title: L10n.of(context).connectWithWhatsAppGroup,
        onBackPressed: () => context.pop(),
      ),
    );
  }

  Widget _buildBody(WidgetRef ref) {
    final state = ref.watch(whatsappGroupConnectProvider);

    return Center(
      child: MaxWidthWidget(
        padding: const EdgeInsets.all(20),
        child: state.currentStep == 1
            ? const GroupLinkWidget()
            : GroupPermissionWidget(sheetId: sheetId),
      ),
    );
  }
}
