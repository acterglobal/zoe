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
  final String title;
  final String content;

  TextBlock({
    super.id,
    required this.title,
    required this.content,
    super.createdAt,
    super.updatedAt,
  }) : super(type: ContentBlockType.text);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  TextBlock copyWith({String? title, String? content, DateTime? updatedAt}) {
    return TextBlock(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

enum TodoPriority { low, medium, high, urgent }

class TodoItem {
  final String id;
  final String text;
  final bool isCompleted;
  final DateTime? dueDate;
  final List<String> assignees;
  final TodoPriority priority;
  final String? description;
  final List<String> tags;

  TodoItem({
    String? id,
    required this.text,
    this.isCompleted = false,
    this.dueDate,
    this.assignees = const [],
    this.priority = TodoPriority.medium,
    this.description,
    this.tags = const [],
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(),
      'assignees': assignees,
      'priority': priority.name,
      'description': description,
      'tags': tags,
    };
  }

  TodoItem copyWith({
    String? text,
    bool? isCompleted,
    DateTime? dueDate,
    List<String>? assignees,
    TodoPriority? priority,
    String? description,
    List<String>? tags,
  }) {
    return TodoItem(
      id: id,
      text: text ?? this.text,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      assignees: assignees ?? this.assignees,
      priority: priority ?? this.priority,
      description: description ?? this.description,
      tags: tags ?? this.tags,
    );
  }
}

enum RSVPStatus { pending, yes, no, maybe }

class EventLocation {
  final String? physical;
  final String? virtual;

  EventLocation({this.physical, this.virtual});

  Map<String, dynamic> toJson() {
    return {'physical': physical, 'virtual': virtual};
  }

  EventLocation copyWith({String? physical, String? virtual}) {
    return EventLocation(
      physical: physical ?? this.physical,
      virtual: virtual ?? this.virtual,
    );
  }
}

class RSVPResponse {
  final String userId;
  final String userName;
  final RSVPStatus status;
  final DateTime respondedAt;

  RSVPResponse({
    required this.userId,
    required this.userName,
    required this.status,
    DateTime? respondedAt,
  }) : respondedAt = respondedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'status': status.name,
      'respondedAt': respondedAt.toIso8601String(),
    };
  }
}

class EventItem {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isAllDay;
  final EventLocation? location;
  final List<RSVPResponse> rsvpResponses;
  final bool requiresRSVP;

  EventItem({
    String? id,
    required this.title,
    this.description,
    required this.startTime,
    this.endTime,
    this.isAllDay = false,
    this.location,
    this.rsvpResponses = const [],
    this.requiresRSVP = false,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'isAllDay': isAllDay,
      'location': location?.toJson(),
      'rsvpResponses': rsvpResponses.map((r) => r.toJson()).toList(),
      'requiresRSVP': requiresRSVP,
    };
  }

  EventItem copyWith({
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAllDay,
    EventLocation? location,
    List<RSVPResponse>? rsvpResponses,
    bool? requiresRSVP,
  }) {
    return EventItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAllDay: isAllDay ?? this.isAllDay,
      location: location ?? this.location,
      rsvpResponses: rsvpResponses ?? this.rsvpResponses,
      requiresRSVP: requiresRSVP ?? this.requiresRSVP,
    );
  }
}
