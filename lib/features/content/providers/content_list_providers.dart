import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/content/models/base_content_model.dart';
import 'package:zoey/features/content/providers/notifiers/content_notifier.dart';

final contentNotifierProvider =
    StateNotifierProvider<ContentNotifier, List<BaseContentModel>>((ref) {
      return ContentNotifier();
    });
