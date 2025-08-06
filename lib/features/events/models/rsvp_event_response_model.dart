import 'package:zoey/features/users/models/user_model.dart';

/// RSVP status enum for event responses
enum RsvpStatus {
  yes('Yes', '✅'),
  no('No', '❌'),
  maybe('Maybe', '🤔'),
  pending('Pending', '⏳');

  const RsvpStatus(this.label, this.emoji);
  final String label;
  final String emoji;
}

class RsvpResponse extends UserModel {
  final RsvpStatus status;

  RsvpResponse({
    required super.id,
    required super.name,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status.name,
    };
  }
}
