class WhatsAppGroupConnectState {
  final String groupLink;
  final bool isConnecting;
  final int currentStep;
  final int totalSteps;

  const WhatsAppGroupConnectState({
    this.groupLink = '',
    this.isConnecting = false,
    this.currentStep = 1,
    this.totalSteps = 2,
  });

  WhatsAppGroupConnectState copyWith({
    String? groupLink,
    bool? isConnecting,
    int? currentStep,
    int? totalSteps,
  }) {
    return WhatsAppGroupConnectState(
      groupLink: groupLink ?? this.groupLink,
      isConnecting: isConnecting ?? this.isConnecting,
      currentStep: currentStep ?? this.currentStep,
      totalSteps: totalSteps ?? this.totalSteps,
    );
  }
}