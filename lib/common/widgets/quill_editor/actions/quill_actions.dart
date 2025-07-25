import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/quill_editor/providers/quill_toolbar_providers.dart';

/// Clear any active quill toolbar state
void clearActiveEditorState(WidgetRef ref) {
  FocusManager.instance.primaryFocus?.unfocus();

  final toolbarState = ref.read(quillToolbarProvider);
  ref.read(quillToolbarProvider.notifier).clearActiveEditorState(toolbarState.activeEditorId ?? '');
}

/// Check if a specific attribute is currently active
bool isAttributeActive(QuillController controller, Attribute attribute) {
  try {
    final selection = controller.selection;
    final docLength = controller.document.length;

    // Handle invalid selection or empty document
    if (!selection.isValid || docLength == 0) {
      return isBlockAttributeActive(controller, attribute);
    }

    // Get current selection attributes
    final attrs = controller.getSelectionStyle().attributes;

    // For other attributes, check if the key exists
    return attrs.containsKey(attribute.key);
  } catch (e) {
    return false;
  }
}

/// Check if a block-level attribute is active
bool isBlockAttributeActive(QuillController controller, Attribute attribute) {
  if (attribute.scope == AttributeScope.block) {
    final docLength = controller.document.length;
    if (docLength > 0) {
      final currentStyle = controller.getSelectionStyle();
      return currentStyle.attributes.containsKey(attribute.key);
    }
  }
  return false;
}

/// Toggle an attribute on/off
void toggleAttribute(
  QuillController controller,
  Attribute attribute, {
  VoidCallback? onButtonPressed,
}) {
  final selection = controller.selection;
  final docLength = controller.document.length;

  // Handle invalid selection
  if (!selection.isValid || docLength == 0) {
    handleInvalidSelection(controller, attribute);
  } else {
    // Check current state and apply attribute accordingly
    final wasActive = isAttributeActive(controller, attribute);

    if (wasActive) {
      controller.formatSelection(Attribute.clone(attribute, null));
    } else {
      controller.formatSelection(attribute);
    }
  }

  // Return focus to editor after button interaction
  onButtonPressed?.call();
}

/// Handle attribute toggle when selection is invalid
void handleInvalidSelection(QuillController controller, Attribute attribute) {
  final currentSelection = controller.selection;
  if (currentSelection.isValid) {
    controller.formatSelection(attribute);
  } else {
    final endPosition = controller.document.length;
    controller.updateSelection(
      TextSelection.collapsed(offset: endPosition),
      ChangeSource.local,
    );
    controller.formatSelection(attribute);
  }
}
