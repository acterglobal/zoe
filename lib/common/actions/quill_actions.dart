import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

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
void toggleAttribute(QuillController controller, Attribute attribute, {VoidCallback? onButtonPressed}) {
  final selection = controller.selection;
  final docLength = controller.document.length;

  // Handle invalid selection
  if (!selection.isValid || docLength == 0) {
    handleInvalidSelection(controller, attribute);
  } else {
    // Check current state and toggle accordingly
    final wasActive = isAttributeActive(controller, attribute);

    toggleStandardAttribute(controller, attribute, wasActive);
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

/// Toggle standard attributes
void toggleStandardAttribute(QuillController controller, Attribute attribute, bool wasActive) {
  if (wasActive) {
    // Remove attribute
    controller.formatSelection(Attribute.clone(attribute, null));
  } else {
    // Apply attribute
    controller.formatSelection(attribute);
  }
} 