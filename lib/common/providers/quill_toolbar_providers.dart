import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/notifiers/quill_toolbar_notifier.dart';

/// Provider for Quill toolbar state
final quillToolbarProvider = StateNotifierProvider<QuillToolbarNotifier, QuillToolbarState>(
  (ref) => QuillToolbarNotifier(),
); 