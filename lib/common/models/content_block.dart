import 'package:uuid/uuid.dart';

enum ContentBlockType { todo, event, list, text }

abstract class ContentBlock {
  final String id;
  final ContentBlockType type;
  final DateTime createdAt;
  final DateTime updatedAt;

  ContentBlock({
    String? id,
    required this.type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson();
  ContentBlock copyWith({DateTime? updatedAt});
}

class TodoBlock extends ContentBlock {
  final String title;
  final List<TodoItem> items;

  TodoBlock({
    super.id,
    required this.title,
    required this.items,
    super.createdAt,
    super.updatedAt,
  }) : super(type: ContentBlockType.todo);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  TodoBlock copyWith({
    String? title,
    List<TodoItem>? items,
    DateTime? updatedAt,
  }) {
    return TodoBlock(
      id: id,
      title: title ?? this.title,
      items: items ?? this.items,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class EventBlock extends ContentBlock {
  final String title;
  final List<EventItem> events;

  EventBlock({
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
  EventBlock copyWith({
    String? title,
    List<EventItem>? events,
    DateTime? updatedAt,
  }) {
    return EventBlock(
      id: id,
      title: title ?? this.title,
      events: events ?? this.events,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class ListBlock extends ContentBlock {
  final String title;
  final List<String> items;

  ListBlock({
    super.id,
    required this.title,
    required this.items,
    super.createdAt,
    super.updatedAt,
  }) : super(type: ContentBlockType.list);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'items': items,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  ListBlock copyWith({
    String? title,
    List<String>? items,
    DateTime? updatedAt,
  }) {
    return ListBlock(
      id: id,
      title: title ?? this.title,
      items: items ?? this.items,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class TextBlock extends ContentBlock {
  final String content;

  TextBlock({super.id, required this.content, super.createdAt, super.updatedAt})
    : super(type: ContentBlockType.text);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  TextBlock copyWith({String? content, DateTime? updatedAt}) {
    return TextBlock(
      id: id,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class TodoItem {
  final String id;
  final String text;
  final bool isCompleted;
  final DateTime? dueDate;

  TodoItem({
    String? id,
    required this.text,
    this.isCompleted = false,
    this.dueDate,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  TodoItem copyWith({String? text, bool? isCompleted, DateTime? dueDate}) {
    return TodoItem(
      id: id,
      text: text ?? this.text,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}

class EventItem {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isAllDay;

  EventItem({
    String? id,
    required this.title,
    this.description,
    required this.startTime,
    this.endTime,
    this.isAllDay = false,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'isAllDay': isAllDay,
    };
  }

  EventItem copyWith({
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAllDay,
  }) {
    return EventItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAllDay: isAllDay ?? this.isAllDay,
    );
  }
}
