import 'package:uuid/uuid.dart';
import 'package:zoey/features/sheet/models/content_block/content_block.dart';

class EventBlockModel extends ContentBlockModel {
  final String title;
  final List<EventItem> events;

  EventBlockModel({
    super.id,
    required this.title,
    required this.events,
    super.createdAt,
    super.updatedAt,
  }) : super(type: ContentBlockType.event);

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
  EventBlockModel copyWith({
    String? title,
    List<EventItem>? events,
    DateTime? updatedAt,
  }) {
    return EventBlockModel(
      id: id,
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

  EventItem({
    String? id,
    required this.title,
    this.description,
    this.startDate,
    this.endDate,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  EventItem copyWith({
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return EventItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
