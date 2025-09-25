import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe_native/providers.dart';
import 'package:zoe_native/zoe_native.dart';

class ConnectionStatusWidget extends ConsumerWidget {
  const ConnectionStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionStatus = ref.watch(connectionStatusProvider);
    if (connectionStatus.isLoading) {
      return SizedBox(
        width: 10,
        height: 10,
        child: const CircularProgressIndicator(),
      );
    }
    if (connectionStatus.hasError) {
      final message = connectionStatus.error.toString();
      return Tooltip(
        message: message,
        child: const Icon(Icons.error_outline_outlined, color: Colors.red),
      );
    }
    return _IconWidget(connectionStatus: connectionStatus.requireValue);
  }
}

class _IconWidget extends StatelessWidget {
  const _IconWidget({required this.connectionStatus});

  final OverallConnectionStatus connectionStatus;

  @override
  Widget build(BuildContext context) {
    final message =
        "connected to ${connectionStatus.totalCount} / ${connectionStatus.totalCount}";

    if (connectionStatus.isConnected) {
      return Tooltip(
        message: message,
        child: const Icon(Icons.check_circle, color: Colors.green),
      );
    }
    if (!connectionStatus.isConnected &&
        connectionStatus.totalCount.compareTo(BigInt.zero) == 0) {
      return Tooltip(
        message: message,
        child: const Icon(Icons.error_outline_outlined, color: Colors.red),
      );
    }
    return Tooltip(
      message: message,
      child: Icon(Icons.warning_amber_outlined, color: Colors.yellow),
    );
  }
}
