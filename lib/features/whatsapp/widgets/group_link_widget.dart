import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/common/utils/common_utils.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/common/widgets/step_indicator_widget.dart';
import 'package:zoe/common/widgets/styled_content_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/features/whatsapp/providers/whatsapp_group_connect_provider.dart';
import 'package:zoe/features/whatsapp/utils/image_utils.dart';
import 'package:zoe/features/whatsapp/widgets/info_header_widget.dart';
import 'package:zoe/features/whatsapp/widgets/guide_step_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';

class GroupLinkWidget extends ConsumerStatefulWidget {
  const GroupLinkWidget({super.key});

  @override
  ConsumerState<GroupLinkWidget> createState() => _GroupLinkWidgetState();
}

class _GroupLinkWidgetState extends ConsumerState<GroupLinkWidget> {
  final _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _groupLinkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _groupLinkController.text = ref
          .read(whatsappGroupConnectProvider)
          .groupLink;
    });
  }

  @override
  void dispose() {
    _groupLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(whatsappGroupConnectProvider);

    return Column(
      children: [
        InfoHeaderWidget(
          title: L10n.of(context).groupLink,
          subtitle: L10n.of(context).connectWhatsAppDescription,
          icon: Icons.link,
        ),
        const SizedBox(height: 10),
        StepIndicatorWidget(
          currentStep: state.currentStep,
          totalSteps: state.totalSteps,
        ),
        Expanded(child: _buildGuideStepContent(context)),
        _buildNavigationButton(),
      ],
    );
  }

  Widget _buildGuideStepContent(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          const SizedBox(height: 20),
          GuideStepWidget(
            stepNumber: 1,
            title: L10n.of(context).navigateToMembersSection,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
    if (!CommonUtils.isValidWhatsAppGroupLink(value)) {
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
    return ZoePrimaryButton(
      text: L10n.of(context).nextEnableInvites,
      icon: Icons.arrow_forward_rounded,
      onPressed: () {
        if (_formKey.currentState?.validate() == false) {
          _scrollToBottom();
          return;
        }
        ref
            .read(whatsappGroupConnectProvider.notifier)
            .updateGroupLink(_groupLinkController.text);
        ref.read(whatsappGroupConnectProvider.notifier).nextStep();
      },
    );
  }
}
