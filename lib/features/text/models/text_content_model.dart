import 'package:zoey/features/content/models/base_content_model.dart';

class TextContentModel extends BaseContentModel {
  @override
  String get plainTextDescription => super.plainTextDescription!;

  @override
  String get htmlDescription => super.htmlDescription!;

  TextContentModel({
    super.id,
    required super.parentId,
    required super.sheetId,
    required super.title,
    required String plainTextDescription,
    required String htmlDescription,
    super.emoji,
    super.createdAt,
    super.updatedAt,
  }) : super(
         type: ContentType.text,
         plainTextDescription: plainTextDescription,
         htmlDescription: htmlDescription,
       );

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentId': parentId,
      'type': type.name,
      'title': title,
      'plainTextDescription': plainTextDescription,
      'htmlDescription': htmlDescription,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  TextContentModel copyWith({
    String? id,
    String? parentId,
    String? sheetId,
    String? title,
    String? plainTextDescription,
    String? htmlDescription,
    DateTime? updatedAt,
  }) {
    return TextContentModel(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      sheetId: sheetId ?? this.sheetId,
      title: title ?? this.title,
      plainTextDescription: plainTextDescription ?? this.plainTextDescription,
      htmlDescription: htmlDescription ?? this.htmlDescription,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
