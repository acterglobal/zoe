import 'package:flutter_riverpod/flutter_riverpod.dart';

final toogleContentMenuProvider = StateProvider<bool>((ref) => false);

final editContentIdProvider = StateProvider<String?>((ref) => null);
