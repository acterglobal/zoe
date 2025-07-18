import 'package:uuid/uuid.dart';
import 'package:zoey/features/sheet/models/sheet_content_model.dart';

class BulletsContentModel extends SheetContentModel {
  final String parentId;
  final String title;
  final List<BulletItem> bullets;

  BulletsContentModel({
    super.id,
    required this.parentId,
    required this.title,
    required this.bullets,
    super.createdAt,
    super.updatedAt,
  }) : super(type: ContentType.bullet);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentId': parentId,
      'type': type.name,
      'title': title,
      'bullets': bullets,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  BulletsContentModel copyWith({
    String? title,
    List<BulletItem>? bullets,
    DateTime? updatedAt,
  }) {
    return BulletsContentModel(
      id: id,
      parentId: parentId,
      title: title ?? this.title,
      bullets: bullets ?? this.bullets,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class BulletItem {
  final String id;
  final String title;
  final String? description;

  BulletItem({String? id, required this.title, this.description})
    : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'description': description};
  }

  BulletItem copyWith({
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return BulletItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
