import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/core/theme/colors/app_colors.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart'
    show isEditValueProvider;
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/state_widgets/error_state_widget.dart';
import 'package:zoe/common/widgets/state_widgets/loading_state_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_avatar_widget.dart';
import 'package:zoe/common/actions/select_files_actions.dart';
import 'package:zoe/features/profile/actions/edit_profile_action.dart';
import 'package:zoe/features/profile/widgets/profile_qr_code_widget.dart';
import 'package:zoe/features/profile/widgets/profile_user_bio_widget.dart';
import 'package:zoe/features/profile/widgets/profile_user_name_widget.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class ProfileDetailsScreen extends ConsumerStatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  ConsumerState<ProfileDetailsScreen> createState() =>
      _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends ConsumerState<ProfileDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool isEditing = false;
  String? selectedImagePath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider).value;
      if (user != null) {
        _nameController.text = user.name;
        _bioController.text = user.bio ?? '';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final l10n = L10n.of(context);
    return currentUserAsync.when(
      data: (user) {
        if (user == null) {
          return Center(child: Text(l10n.userNotFound));
        }
        isEditing = ref.watch(isEditValueProvider(user.id));
        return Scaffold(
          appBar: _buildAppbar(context, user),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(child: _buildBody(context, user)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: _buildNavigationButton(user),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const LoadingStateWidget(),
      error: (error, stackTrace) => ErrorStateWidget(message: error.toString()),
    );
  }

  AppBar _buildAppbar(BuildContext context, UserModel user) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: ZoeAppBar(
        title: L10n.of(context).profile,
        actions: [
          StyledIconContainer(
            icon: Icons.qr_code_scanner,
            size: 40,
            primaryColor: Theme.of(context).colorScheme.onSurface,
            iconSize: 20,
            backgroundOpacity: 0.08,
            borderOpacity: 0.15,
            shadowOpacity: 0.1,
            onTap: () => showProfileQrCodeBottomSheet(context, user),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, UserModel user) {
    return MaxWidthWidget(
      isScrollable: true,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildAvatarUI(context, user),
          const SizedBox(height: 32),
          _buildPersonalInformationWidget(context),
        ],
      ),
    );
  }

  Widget _buildAvatarUI(BuildContext context, UserModel user) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ZoeUserAvatarWidget(
          user: user,
          size: 100,
          fontSize: 30,
          selectedImagePath: selectedImagePath,
        ),

        if (isEditing)
          Positioned(
            right: -4,
            bottom: -4,
            child: StyledIconContainer(
              icon: Icons.camera_alt,
              size: 32,
              iconSize: 16,
              borderRadius: BorderRadius.circular(16),
              primaryColor: colorScheme.onSurface,
              secondaryColor: colorScheme.primary,
              onTap: () => onChangeAvatar(user),
            ),
          ),
      ],
    );
  }

  Widget _buildPersonalInformationWidget(BuildContext context) {
    final theme = Theme.of(context);
    final color = AppColors.brightMagentaColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            StyledIconContainer(
              icon: Icons.edit_note_rounded,
              size: 30,
              iconSize: 20,
              primaryColor: color,
              backgroundOpacity: 0.1,
              borderOpacity: 0.2,
              shadowOpacity: 0.1,
            ),
            const SizedBox(width: 12),
            Text(
              L10n.of(context).personalInformation,
              style: theme.textTheme.titleMedium?.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ProfileUserNameWidget(
          isEditing: isEditing,
          controller: _nameController,
        ),
        const SizedBox(height: 24),
        ProfileUserBioWidget(isEditing: isEditing, controller: _bioController),
      ],
    );
  }

  Widget _buildNavigationButton(UserModel user) {
    return ZoePrimaryButton(
      icon: isEditing ? Icons.save_rounded : Icons.person_rounded,
      text: isEditing
          ? L10n.of(context).saveChanges
          : L10n.of(context).editProfile,
      onPressed: () {
        if (isEditing) {
          final updatedUser = user.copyWith(
            id: user.id,
            name: _nameController.text.trim(),
            bio: _bioController.text.trim(),
          );
          saveProfileAction(ref, updatedUser);
          editProfileValueAction(ref, updatedUser, isEditing);
        } else {
          editProfileValueAction(ref, user, isEditing);
        }
      },
    );
  }

  void onChangeAvatar(UserModel user) {
    selectFileSource(
      context,
      ref,
      user.id,
      user.id,
      isProfile: true,
      onImageSelected: (path) {
        setState(() {
          selectedImagePath = path;
        });
        final updatedUser = user.copyWith(
          id: user.id,
          name: _nameController.text.trim(),
          bio: _bioController.text.trim(),
          avatar: path,
        );
        saveProfileAction(ref, updatedUser);
      },
    );
  }
}
