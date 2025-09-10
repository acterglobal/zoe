import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/quill_editor/actions/quill_actions.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

void saveProfileAction(WidgetRef ref, UserModel user) {
  ref.read(userListProvider.notifier).updateUser(user.id, user);
}

void editProfileValueAction(WidgetRef ref, UserModel user, bool isEditing) {
  clearActiveEditorState(ref);
  ref.read(isEditValueProvider(user.id).notifier).state = !isEditing;
}
