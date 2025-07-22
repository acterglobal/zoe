import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final String? taskId;

  const TaskDetailScreen({super.key, this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Item Detail')),
      body: const Center(child: Text('Task Item Detail')),
    );
  }
}
