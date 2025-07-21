import 'package:uuid/uuid.dart';

class BulletItem {
  final String id;
  final String sectionBlockId;
  final String title;
  final String? description;
  final List<String> contentList;

  BulletItem({
    String? id,
    required this.sectionBlockId,
    required this.title,
    this.description,
    this.contentList = const [],
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sectionBlockId': sectionBlockId,
      'title': title,
      'description': description,
      'contentList': contentList,
    };
  }

  BulletItem copyWith({
    String? title,
    String? description,
    List<String>? contentList,
  }) {
    return BulletItem(
      id: id,
      sectionBlockId: sectionBlockId,
      title: title ?? this.title,
      description: description ?? this.description,
      contentList: contentList ?? this.contentList,
    );
  }
}
