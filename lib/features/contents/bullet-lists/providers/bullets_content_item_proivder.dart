import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/contents/bullet-lists/data/bullets_content_list.dart';
import 'package:zoey/features/contents/bullet-lists/models/bullets_content_model.dart';

final bulletsContentItemProvider = Provider.family<BulletsContentModel, String>(
  (ref, String id) =>
      bulletsContentList.firstWhere((element) => element.id == id),
);
