import 'package:zoey/features/sheet/models/sheet_content_model.dart';

class BulletsContentModel extends SheetContentModel {
  final String parentId;
  final String title;
  final List<String> bullets;

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
    List<String>? bullets,
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
