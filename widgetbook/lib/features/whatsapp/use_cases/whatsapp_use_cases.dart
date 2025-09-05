import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/features/home/zoe_preview_widget.dart';
import 'package:zoe/features/whatsapp/model/whatsapp_group_connect_state.dart';
import 'package:zoe/features/whatsapp/screens/whatsapp_group_connect_screen.dart';
import '../mock_whatsapp_providers.dart';

@widgetbook.UseCase(name: 'WhatsApp Group Connect Screen', type: WhatsAppGroupConnectScreen)
Widget buildWhatsAppGroupConnectScreenUseCase(BuildContext context) {
  final sheetId = context.knobs.string(
    label: 'Sheet ID',
    initialValue: 'sheet-1',
  );

  final groupLink = context.knobs.string(
    label: 'Group Link',
    initialValue: 'https://chat.whatsapp.com/example',
  );

  final isConnecting = context.knobs.boolean(
    label: 'Is Connecting',
    initialValue: false,
  );

  final currentStep = context.knobs.int.slider(
    label: 'Current Step',
    min: 1,
    max: 2,
    initialValue: 1,
  );

  return ProviderScope(
    overrides: [
      mockWhatsappGroupConnectProvider.overrideWith((ref) {
        return MockWhatsAppGroupConnectNotifier()
          ..setState(WhatsAppGroupConnectState(
            groupLink: groupLink,
            isConnecting: isConnecting,
            currentStep: currentStep,
          ));
      }),
    ],
    child: ZoePreview(
      child: WhatsAppGroupConnectScreen(sheetId: sheetId),
    ),
  );
}
