import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/whatsapp/model/whatsapp_group_connect_state.dart';

final whatsappGroupConnectProvider =
    StateNotifierProvider.autoDispose<
      WhatsAppGroupConnectNotifier,
      WhatsAppGroupConnectState
    >((ref) => WhatsAppGroupConnectNotifier());

class WhatsAppGroupConnectNotifier
    extends StateNotifier<WhatsAppGroupConnectState> {
  WhatsAppGroupConnectNotifier() : super(const WhatsAppGroupConnectState());

  void updateGroupLink(String link) {
    state = state.copyWith(groupLink: link);
  }

  void setConnecting(bool connecting) {
    state = state.copyWith(isConnecting: connecting);
  }

  void nextStep() {
    if (state.currentStep < state.totalSteps) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }
}
