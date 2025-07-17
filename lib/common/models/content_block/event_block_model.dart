import 'package:uuid/uuid.dart';
import 'package:zoey/common/models/content_block/content_block.dart';

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
