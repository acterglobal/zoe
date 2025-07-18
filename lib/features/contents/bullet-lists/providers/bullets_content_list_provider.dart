import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/features/contents/bullet-lists/data/bullets_content_list.dart';
import 'package:zoey/features/contents/bullet-lists/model/bullets_content_model.dart';

final bulletsContentListProvider = Provider<List<BulletsContentModel>>(
  (ref) => bulletsContentList,
);
