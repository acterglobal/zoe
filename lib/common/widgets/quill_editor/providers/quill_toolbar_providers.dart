import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/quill_editor/notifiers/quill_toolbar_notifier.dart';

/// Provider for Quill toolbar state
final quillToolbarProvider =
    StateNotifierProvider<QuillToolbarNotifier, QuillToolbarState>(
      (ref) => QuillToolbarNotifier(),
    );
