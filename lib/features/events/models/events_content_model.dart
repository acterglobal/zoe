import 'package:uuid/uuid.dart';
import 'package:zoey/features/block/model/block_model.dart';

class EventsContentModel extends BlockModel {
  final List<EventItem> events;

  EventsContentModel({
    super.id,
    required super.parentId,
    required super.title,
    required this.events,
    super.createdAt,
    super.updatedAt,
  }) : super(type: BlockType.event);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'events': events.map((event) => event.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  EventsContentModel copyWith({
    String? title,
    List<EventItem>? events,
    DateTime? updatedAt,
  }) {
    return EventsContentModel(
      id: id,
      parentId: parentId,
      title: title ?? this.title,
      events: events ?? this.events,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class EventItem {
  final String id;
  final String title;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> contentList;

  EventItem({
    String? id,
    required this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.contentList = const [],
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'contentList': contentList,
    };
  }

  EventItem copyWith({
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? contentList,
  }) {
    return EventItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      contentList: contentList ?? this.contentList,
    );
  }
}
