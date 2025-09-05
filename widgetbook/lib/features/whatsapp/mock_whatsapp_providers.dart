import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/whatsapp/model/whatsapp_group_connect_state.dart';
import 'package:zoe/features/whatsapp/providers/whatsapp_group_connect_provider.dart';

class MockWhatsAppGroupConnectNotifier extends WhatsAppGroupConnectNotifier {
  MockWhatsAppGroupConnectNotifier() : super();

  void setState(WhatsAppGroupConnectState state) {
    this.state = state;
  }
}

final mockWhatsappGroupConnectProvider = StateNotifierProvider.autoDispose<
    WhatsAppGroupConnectNotifier, WhatsAppGroupConnectState>(
  (ref) => MockWhatsAppGroupConnectNotifier(),
);
