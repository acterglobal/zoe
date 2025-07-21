import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListBlockDetailScreen extends ConsumerWidget {
  final String? listBlockId;

  const ListBlockDetailScreen({super.key, this.listBlockId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Block Detail')),
      body: const Center(child: Text('List Block ID not provided')),
    );
  }
}
