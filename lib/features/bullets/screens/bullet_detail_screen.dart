import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoey/common/widgets/edit_view_toggle_button.dart';
import 'package:zoey/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoey/features/bullets/model/bullet_model.dart';
import 'package:zoey/features/bullets/providers/bullet_providers.dart';
import 'package:zoey/features/content/providers/content_menu_providers.dart';
import 'package:zoey/features/content/widgets/content_widget.dart';

class BulletDetailScreen extends ConsumerWidget {
  final String bulletId;

  const BulletDetailScreen({super.key, required this.bulletId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bullet = ref.watch(bulletProvider(bulletId));
    if (bullet == null) return const Center(child: Text('Bullet not found'));
    return Scaffold(
      appBar: AppBar(
        actions: [EditViewToggleButton(), const SizedBox(width: 12)],
      ),
      body: _buildBody(context, ref, bullet),
    );
  }

  /// Builds the main body
  Widget _buildBody(BuildContext context, WidgetRef ref, BulletModel bullet) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBulletHeader(context, ref, bullet),
          const SizedBox(height: 16),
          ContentWidget(parentId: bulletId, sheetId: bullet.sheetId),
        ],
      ),
    );
  }

  /// Builds the header
  Widget _buildBulletHeader(
    BuildContext context,
    WidgetRef ref,
    BulletModel bullet,
  ) {
    final isEditing = ref.watch(isEditValueProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ZoeInlineTextEditWidget(
                hintText: 'Title',
                isEditing: isEditing,
                text: bullet.title,
                textStyle: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.2,
                ),
                onTextChanged: (value) {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ZoeInlineTextEditWidget(
          hintText: 'Add a description',
          isEditing: isEditing,
          text: bullet.description?.plainText,
          textStyle: Theme.of(context).textTheme.bodyLarge,
          onTextChanged: (value) {},
        ),
      ],
    );
  }
}
