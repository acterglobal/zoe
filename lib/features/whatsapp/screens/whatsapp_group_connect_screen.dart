import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/utils/validation_utils.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/styled_content_container_widget.dart';
import 'package:zoe/common/widgets/success_dialog_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/features/whatsapp/utils/image_utils.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/features/whatsapp/providers/whatsapp_group_connect_provider.dart';
import 'package:zoe/features/whatsapp/widgets/guide_step_widget.dart';
import 'package:zoe/features/whatsapp/widgets/important_note_widget.dart';
import 'package:zoe/features/whatsapp/widgets/enable_invites_bottom_sheet.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class WhatsAppGroupConnectScreen extends ConsumerStatefulWidget {
  final String sheetId;
  const WhatsAppGroupConnectScreen({super.key, required this.sheetId});

  @override
  ConsumerState<WhatsAppGroupConnectScreen> createState() =>
      _WhatsAppGroupConnectScreenState();
}

class _WhatsAppGroupConnectScreenState
    extends ConsumerState<WhatsAppGroupConnectScreen> {
  final _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _groupLinkController = TextEditingController();

  @override
  void dispose() {
    _groupLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: ZoeAppBar(title: L10n.of(context).connectWithWhatsAppGroup),
    );
  }

  Widget _buildBody() {
    return Center(
      child: MaxWidthWidget(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(child: _buildGuideStepContent(context)),
            _buildNavigationButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideStepContent(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          GuideStepWidget(
            stepNumber: 1,
            title: L10n.of(context).groupMemberSection,
            description: L10n.of(context).navigateToMembersSectionDescription,
            imagePath: ImageUtils.getInviteMemberImagePath(context),
          ),
          const SizedBox(height: 24),
          GuideStepWidget(
            stepNumber: 2,
            title: L10n.of(context).copyGroupLink,
            description: L10n.of(context).copyGroupLinkDescription,
            imagePath: ImageUtils.getCopyLinkImagePath(context),
          ),
          const SizedBox(height: 24),
          _buildGroupLinkSection(),
          const SizedBox(height: 20),
          ImportantNoteWidget(
            title: L10n.of(context).cannotFindLink,
            message: L10n.of(context).cannotFindLinkDescription,
            icon: Icons.link_rounded,
            onTap: () => showEnableInvitesBottomSheet(context),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildGroupLinkSection() {
    return GlassyContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      borderRadius: BorderRadius.circular(20),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGroupLinkTitle(),
            const SizedBox(height: 10),
            _buildGroupTextField(),
            const SizedBox(height: 10),
            _buildGroupLinkHint(),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupLinkTitle() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        StyledContentContainer(
          size: 40,
          borderRadius: BorderRadius.circular(12),
          child: Text(
            '3',
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          L10n.of(context).groupLink,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildGroupTextField() {
    final colorScheme = Theme.of(context).colorScheme;

    final borderRadius = BorderRadius.circular(12);

    final outlineBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: colorScheme.primary, width: 2),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: colorScheme.error, width: 2),
    );

    return TextFormField(
      controller: _groupLinkController,
      validator: _validateGroupLink,
      decoration: InputDecoration(
        hintText: 'https://chat.whatsapp.com/...',
        border: outlineBorder,
        enabledBorder: outlineBorder,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
      ),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
    );
  }

  String? _validateGroupLink(String? value) {
    if (value == null || value.isEmpty) {
      return L10n.of(context).whatsappGroupLinkRequired;
    }
    if (!ValidationUtils.isValidWhatsAppGroupLink(value)) {
      return L10n.of(context).whatsappGroupLinkInvalid;
    }
    return null;
  }

  Widget _buildGroupLinkHint() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      children: [
        Icon(
          Icons.info_outline,
          size: 16,
          color: colorScheme.primary.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            L10n.of(context).groupLinkHintText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }

  // Scroll to bottom of the screen
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final currentScrollOffset = _scrollController.offset;
      // Check if there's more content to scroll
      if (currentScrollOffset < maxScrollExtent) {
        _scrollController.animateTo(
          maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  Widget _buildNavigationButton() {
    final isConnecting = ref.watch(isConnectingProvider);

    return ZoePrimaryButton(
      icon: isConnecting ? null : Icons.link_rounded,
      text: isConnecting
          ? L10n.of(context).connecting
          : L10n.of(context).connectGroup,
      onPressed: () => isConnecting ? {} : _connectToGroup(),
    );
  }

  Future<void> _connectToGroup() async {
    if (_formKey.currentState?.validate() == false) {
      _scrollToBottom();
      return;
    }

    final l10n = L10n.of(context);

    ref.read(isConnectingProvider.notifier).state = true;
    try {
      // Simulate connection process
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      // First pop to close the current screen
      context.pop();

      ref.read(isConnectingProvider.notifier).state = false;

      // Show success dialog with safer navigation handling
      await showSuccessDialog(
        context: context,
        title: l10n.successfullyConnected,
        message: l10n.whatsappGroupConnectedMessage,
        buttonText: l10n.done,
        customIcon: Icons.link_rounded,
        onButtonPressed: () {
          // Additional actions after success can be added here
          debugPrint(
            "WhatsApp group connected successfully - SheetId: ${widget.sheetId}, GroupLink: ${_groupLinkController.text}",
          );
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      ref.read(isConnectingProvider.notifier).state = false;
      debugPrint("Error connecting to group: $e");
    }
  }
}
