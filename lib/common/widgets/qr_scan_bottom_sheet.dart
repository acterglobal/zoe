import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

void showQrScanBottomSheet({
  required BuildContext context,
  required Function(BarcodeCapture barcodes)? onDetect,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => QrScanBottomSheet(onDetect: onDetect),
  );
}

class QrScanBottomSheet extends StatefulWidget {
  final void Function(BarcodeCapture barcodes)? onDetect;
  const QrScanBottomSheet({super.key, this.onDetect});

  @override
  State<QrScanBottomSheet> createState() => _QrScanBottomSheetState();
}

class _QrScanBottomSheetState extends State<QrScanBottomSheet> {
  late final MobileScannerController controller;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(formats: [BarcodeFormat.qrCode]);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.5;
    final width = MediaQuery.sizeOf(context).width;
    final borderRadius = BorderRadius.circular(16);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          L10n.of(context).scanQr,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        MaxWidthWidget(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: height,
            width: width,
            child: ClipRRect(
              borderRadius: borderRadius,
              child: MobileScanner(
                controller: controller,
                onDetect: widget.onDetect,
                placeholderBuilder: (context) => Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
