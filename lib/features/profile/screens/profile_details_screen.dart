import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/state_widgets/error_state_widget.dart';
import 'package:zoe/common/widgets/state_widgets/loading_state_widget.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_user_avatar_widget.dart';
import 'package:zoe/features/profile/widgets/profile_qr_code_widget.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class ProfileDetailsScreen extends ConsumerWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final l10n = L10n.of(context);
    return currentUserAsync.when(
      data: (user) {
        if (user == null) {
          return Center(child: Text(l10n.userNotFound));
        }
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
          GestureDetector(
            onTap: () => showProfileQrCodeBottomSheet(context, user),
            child: StyledIconContainer(
              icon: Icons.qr_code_scanner,
              size: 40,
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
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: MaxWidthWidget(
        isScrollable: true,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAvatarUI(context, user),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarUI(BuildContext context, UserModel user) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ZoeUserAvatarWidget(user: user, size: 80, fontSize: 30),
        Positioned.fill(
          bottom: 4,
          child: Align(
            alignment: Alignment.bottomRight,
            child: StyledIconContainer(
              icon: Icons.edit,
              size: 25,
              iconSize: 15,
              borderRadius: BorderRadius.circular(12),
              primaryColor: colorScheme.onSurface,
              secondaryColor: colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
