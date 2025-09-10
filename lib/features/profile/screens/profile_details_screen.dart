import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/animated_textfield_widget.dart';
import 'package:zoe/common/widgets/edit_view_toggle_button.dart'
    show EditViewToggleButton;

import 'package:zoe/features/content/providers/content_menu_providers.dart'
    show isEditValueProvider;
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/state_widgets/error_state_widget.dart';
import 'package:zoe/common/widgets/state_widgets/loading_state_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_avatar_widget.dart';
import 'package:zoe/common/actions/select_files_actions.dart';
import 'package:zoe/features/profile/widgets/profile_qr_code_widget.dart';
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
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String? _errorText;
  String? _bioErrorText;
  bool isEditing = false;
  String? selectedImagePath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider).value;
      if (user != null) {
        _urlController.text = user.name;
        _bioController.text = user.bio ?? '';
      }
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
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
          body: _buildBody(context, user),
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
          EditViewToggleButton(parentId: user.id),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => showProfileQrCodeBottomSheet(context, user),
            child: StyledIconContainer(
              icon: Icons.qr_code_scanner,
              size: 40,
              primaryColor: Theme.of(context).colorScheme.onSurface,
              iconSize: 20,
              backgroundOpacity: 0.08,
              borderOpacity: 0.15,
              shadowOpacity: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, UserModel user) {
    return Center(
      child: MaxWidthWidget(
        isScrollable: true,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAvatarUI(context, user),
            const SizedBox(height: 16),
            _buildUserNameUI(context),
            const SizedBox(height: 24),
            _buildUserBioInputUI(context),
          ],
        ),
      ),
    );
  }

  void _validateName() {
    final name = _urlController.text.trim();
    if (CommonUtils.isValidName(name)) {
      setState(() {
        _errorText = null;
      });
    } else {
      setState(() {
        _errorText = CommonUtils.getNameErrorMessage(context, name);
      });
    }
  }

  Widget _buildUserNameUI(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10n.of(context).userName,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        AnimatedTextField(
          controller: _urlController,
          errorText: _errorText,
          hintText: L10n.of(context).pleaseEnterAValidName,
          onErrorChanged: (error) => setState(() => _errorText = error),
          onSubmitted: _validateName,
          enabled: isEditing,
          readOnly: !isEditing,
          autofocus: isEditing,
        ),
      ],
    );
  }

  Widget _buildUserBioInputUI(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10n.of(context).userBio,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        AnimatedTextField(
          controller: _bioController,
          errorText: _bioErrorText,
          hintText: L10n.of(context).writeSomethingAboutYourself,
          onErrorChanged: (error) => setState(() => _bioErrorText = error),
          onSubmitted: () {},
          enabled: isEditing,
          readOnly: !isEditing,
          autofocus: isEditing,
        ),
      ],
    );
  }

  Widget _buildAvatarUI(BuildContext context, UserModel user) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        selectedImagePath != null
            ? Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: FileImage(File(selectedImagePath!)),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : ZoeUserAvatarWidget(user: user, size: 100, fontSize: 30),

        if (isEditing)
          Positioned(
            right: -4,
            bottom: -4,
            child: GestureDetector(
              onTap: () {
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
                  },
                );
              },
              child: StyledIconContainer(
                icon: Icons.camera_alt,
                size: 32,
                iconSize: 16,
                borderRadius: BorderRadius.circular(16),
                primaryColor: colorScheme.onSurface,
                secondaryColor: colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}
