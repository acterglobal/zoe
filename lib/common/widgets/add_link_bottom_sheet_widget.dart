import 'package:flutter/material.dart';
import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/common/widgets/animated_textfield_widget.dart';
import 'package:zoey/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoey/common/widgets/toolkit/zoe_secondary_button.dart';
import 'package:zoey/common/widgets/toolkit/zoe_icon_container_widget.dart';
import 'package:zoey/l10n/generated/l10n.dart';

/// Shows a bottom sheet for inserting a link
Future<String?> showAddLinkBottomSheet(
  BuildContext context, {
  String? selectedText,
}) async {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    enableDrag: true,
    showDragHandle: true,
    elevation: 6,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => AddLinkBottomSheetWidget(selectedText: selectedText),
  );
}

class AddLinkBottomSheetWidget extends StatefulWidget {
  final String? selectedText;

  const AddLinkBottomSheetWidget({super.key, this.selectedText});

  @override
  State<AddLinkBottomSheetWidget> createState() =>
      _AddLinkBottomSheetWidgetState();
}

class _AddLinkBottomSheetWidgetState extends State<AddLinkBottomSheetWidget> {
  final TextEditingController _urlController = TextEditingController();
  String? _errorText;

  void _validateAndSubmit() {
    final url = _urlController.text.trim();
    if (CommonUtils.isValidUrl(url)) {
      Navigator.of(context).pop(url);
    } else {
      setState(() {
        _errorText = CommonUtils.getUrlErrorMessage(context, url);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: ZoeIconContainer(icon: Icons.link_outlined, size: 72)),
          const SizedBox(height: 24),
          buildInsertLinkText(),
          const SizedBox(height: 16),
          AnimatedTextField(
            controller: _urlController,
            errorText: _errorText,
            onErrorChanged: (error) => setState(() => _errorText = error),
            onSubmitted: _validateAndSubmit,
          ),
          const SizedBox(height: 24),
          buildActionButtons(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget buildInsertLinkText() {
    return Column(
      children: [
        Text(
          L10n.of(context).insertLinkIn,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          "'${widget.selectedText}'",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }

  Widget buildActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: double.infinity,
          child: ZoePrimaryButton(
            onPressed: _validateAndSubmit,
            text: L10n.of(context).insertLink,
            showShimmer: false,
            icon: Icons.link_outlined,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ZoeSecondaryButton(
            onPressed: () => Navigator.of(context).pop(),
            text: L10n.of(context).cancel,
            showShimmer: false,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}
