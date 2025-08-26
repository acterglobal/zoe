import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/features/content/utils/content_utils.dart';
import 'package:zoe/features/content/widgets/content_menu_options.dart';
import 'package:zoe/l10n/generated/l10n.dart';

void showAddContentBottomSheet(
  BuildContext context, {
  required String sheetId,
}) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (context) => AddContentBottomSheet(sheetId: sheetId),
  );
}

class AddContentBottomSheet extends ConsumerWidget {
  final String sheetId;

  const AddContentBottomSheet({super.key, required this.sheetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          L10n.of(context).addContent,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ContentMenuOptions(
            onTapText: () {
              context.pop();
              addNewTextContent(
                ref: ref,
                parentId: sheetId,
                sheetId: sheetId,
                addAtTop: true,
              );
            },
            onTapEvent: () {
              context.pop();
              addNewEventContent(
                ref: ref,
                parentId: sheetId,
                sheetId: sheetId,
                addAtTop: true,
              );
            },
            onTapBulletedList: () {
              context.pop();
              addNewBulletedListContent(
                ref: ref,
                parentId: sheetId,
                sheetId: sheetId,
                addAtTop: true,
              );
            },
            onTapToDoList: () {
              context.pop();
              addNewTaskListContent(
                ref: ref,
                parentId: sheetId,
                sheetId: sheetId,
                addAtTop: true,
              );
            },
            onTapLink: () {
              context.pop();
              addNewLinkContent(
                ref: ref,
                parentId: sheetId,
                sheetId: sheetId,
                addAtTop: true,
              );
            },
            onTapDocument: () {
              context.pop();
              addNewDocumentContent(
                ref: ref,
                parentId: sheetId,
                sheetId: sheetId,
                addAtTop: true,
              );
            },
            onTapPoll: () {
              context.pop();
              addNewPollContent(
                ref: ref,
                parentId: sheetId,
                sheetId: sheetId,
                addAtTop: true,
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
