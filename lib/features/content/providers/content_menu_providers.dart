import 'package:flutter_riverpod/flutter_riverpod.dart';

final toogleContentMenuProvider = StateProvider<bool>((ref) => false);

final isEditValueProvider = StateProvider.family<bool, String>((ref, parentId) => false);
