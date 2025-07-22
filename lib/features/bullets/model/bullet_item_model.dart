import 'package:zoey/common/utils/common_utils.dart';
import 'package:zoey/features/sheet/models/sheet_model.dart';

class BulletItem {
  final String id;
  final String listId;
  final String title;
  final Description? description;

  BulletItem({
    String? id,
    required this.listId,
    required this.title,
    this.description,
  }) : id = id ?? CommonUtils.generateRandomId();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listId': listId,
      'title': title,
      'description': description,
    };
  }

  BulletItem copyWith({
    String? id,
    String? listId,
    String? title,
    Description? description,
  }) {
    return BulletItem(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
