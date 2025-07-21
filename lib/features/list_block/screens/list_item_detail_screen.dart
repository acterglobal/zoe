import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListItemDetailScreen extends ConsumerWidget {
  final String? listItemId;

  const ListItemDetailScreen({super.key, this.listItemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Block Detail')),
      body: const Center(child: Text('List Block ID not provided')),
    );
  }
}
