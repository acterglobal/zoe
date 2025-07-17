import 'package:uuid/uuid.dart';

enum ContentBlockType { todo, event, list, text }

abstract class ContentBlockModel {
  final String id;
  final ContentBlockType type;
  final DateTime createdAt;
  final DateTime updatedAt;

  ContentBlockModel({
    String? id,
    required this.type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson();
  ContentBlockModel copyWith({DateTime? updatedAt});
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
