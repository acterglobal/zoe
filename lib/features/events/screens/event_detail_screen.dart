import 'package:flutter/material.dart';

class EventDetailScreen extends StatelessWidget {
  final String? eventId;

  const EventDetailScreen({super.key, this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Detail')),
      body: const Center(child: Text('Event Detail')),
    );
  }
}
