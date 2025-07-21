import 'package:zoey/features/block/model/block_model.dart';

class TextBlockModel extends BlockModel {
  @override
  String get plainTextDescription => super.plainTextDescription!;

  @override
  String get htmlDescription => super.htmlDescription!;

  TextBlockModel({
    super.id,
    required super.parentId,
    required super.title,
    required String plainTextDescription,
    required String htmlDescription,
    super.emoji,
    super.createdAt,
    super.updatedAt,
  }) : super(
         type: BlockType.text,
         plainTextDescription: plainTextDescription,
         htmlDescription: htmlDescription,
       );

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'plainTextDescription': plainTextDescription,
      'htmlDescription': htmlDescription,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  TextBlockModel copyWith({
    String? title,
    String? plainTextDescription,
    String? htmlDescription,
    DateTime? updatedAt,
  }) {
    return TextBlockModel(
      id: id,
      parentId: parentId,
      title: title ?? this.title,
      plainTextDescription: plainTextDescription ?? this.plainTextDescription,
      htmlDescription: htmlDescription ?? this.htmlDescription,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
