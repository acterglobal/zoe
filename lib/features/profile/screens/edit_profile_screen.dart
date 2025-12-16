import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/validation_utils.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_avatar_widget.dart';
import 'package:zoe/features/profile/actions/select_profile_actions.dart';
import 'package:zoe/features/profile/widgets/profile_qr_code_widget.dart';
import 'package:zoe/features/profile/widgets/profile_user_bio_widget.dart';
import 'package:zoe/features/profile/widgets/profile_user_name_widget.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  String? _selectedAvatarPath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider);
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
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: _buildAppBar(context, user),
      body: SafeArea(
        child: user == null
            ? Center(child: Text(L10n.of(context).userNotFound))
            : _buildBody(user),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, UserModel? user) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: ZoeAppBar(
        title: L10n.of(context).profile,
        actions: [
          if (user != null)
            StyledIconContainer(
              icon: Icons.qr_code_scanner,
              size: 40,
              primaryColor: Theme.of(context).colorScheme.onSurface,
              iconSize: 20,
              backgroundOpacity: 0.08,
              borderOpacity: 0.15,
              shadowOpacity: 0.1,
              onTap: () => showProfileQrCodeBottomSheet(context, user.name),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(UserModel user) {
    return MaxWidthWidget(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(child: _buildProfileContent(context, user)),
          _buildActionButton(user),
        ],
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserModel user) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildAvatarSection(context, user),
            const SizedBox(height: 32),
            _buildProfileInfoSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context, UserModel user) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ZoeUserAvatarWidget(
          user: user,
          size: 100,
          fontSize: 30,
          selectedImagePath: _selectedAvatarPath,
        ),
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
            onTap: () => _onAvatarChange(user),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileUserNameWidget(controller: _nameController),
        const SizedBox(height: 24),
        ProfileUserBioWidget(controller: _bioController),
      ],
    );
  }

  Widget _buildActionButton(UserModel user) {
    final l10n = L10n.of(context);

    return ZoePrimaryButton(
      icon: Icons.save_rounded,
      text: l10n.saveChanges,
      onPressed: () {
        final name = _nameController.text.trim();
        if (!ValidationUtils.isValidName(name)) {
          // Force validation by updating the text
          setState(() => _nameController.text = name);
          return;
        }
        final updatedUser = user.copyWith(
          id: user.id,
          name: name,
          bio: _bioController.text.trim(),
        );
        ref.read(userListProvider.notifier).updateUser(user.id, updatedUser);
        Navigator.pop(context);
      },
    );
  }

  void _onAvatarChange(UserModel user) {
    selectProfileFileSource(
      context,
      user.id,
      ref,
      hasAvatar: user.avatar != null,
      onImageSelected: (path) {
        setState(() {
          _selectedAvatarPath = path;
        });

        final updatedUser = user.copyWith(id: user.id, avatar: path);
        ref.read(userListProvider.notifier).updateUser(user.id, updatedUser);
      },
    );
  }
}
