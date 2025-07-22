import 'package:zoey/features/content/models/base_content_model.dart';

class TextModel extends ContentModel {
  @override
  String get plainTextDescription => super.plainTextDescription!;

  @override
  String get htmlDescription => super.htmlDescription!;

  TextModel({
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
  TextModel copyWith({
    String? id,
    String? parentId,
    String? sheetId,
    String? title,
    String? plainTextDescription,
    String? htmlDescription,
    DateTime? updatedAt,
  }) {
    return TextModel(
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
