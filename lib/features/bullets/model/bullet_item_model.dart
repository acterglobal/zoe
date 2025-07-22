import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class BulletItem {
  final String id;
  final String sheetId;
  final String listId;
  final String title;
  final Description? description;
  final int orderIndex; // Order within list

  BulletItem({
    String? id,
    required this.sheetId,
    required this.listId,
    required this.title,
    this.description,
    int? orderIndex,
  }) : id = id ?? CommonUtils.generateRandomId(),
       orderIndex = orderIndex ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sheetId': sheetId,
      'listId': listId,
      'title': title,
      'description': description,
      'orderIndex': orderIndex,
    };
  }

  BulletItem copyWith({
    String? id,
    String? sheetId,
    String? listId,
    String? title,
    Description? description,
    int? orderIndex,
  }) {
    return BulletItem(
      id: id ?? this.id,
      sheetId: sheetId ?? this.sheetId,
      listId: listId ?? this.listId,
      title: title ?? this.title,
      description: description ?? this.description,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}
