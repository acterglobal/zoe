import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BulletDetailScreen extends ConsumerWidget {
  final String? bulletId;

  const BulletDetailScreen({super.key, this.bulletId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bullet Item Detail')),
      body: const Center(child: Text('Bullet ID not provided')),
    );
  }
}
