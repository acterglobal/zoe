import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/notifiers/quill_toolbar_notifier.dart';

// Export the state type and notifier for consumers
export 'package:zoey/common/notifiers/quill_toolbar_notifier.dart' show QuillToolbarState, QuillToolbarNotifier;

/// Provider for Quill toolbar state
final quillToolbarProvider = StateNotifierProvider<QuillToolbarNotifier, QuillToolbarState>(
  (ref) => QuillToolbarNotifier(),
); 