import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BulletItemDetailScreen extends ConsumerWidget {
  final String? bulletItemId;

  const BulletItemDetailScreen({super.key, this.bulletItemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bullet Item Detail')),
      body: const Center(child: Text('Bullet Item ID not provided')),
    );
  }
}
