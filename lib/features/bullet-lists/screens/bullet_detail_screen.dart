import 'package:flutter/material.dart';

class BulletDetailScreen extends StatelessWidget {
  final String? bulletId;

  const BulletDetailScreen({super.key, this.bulletId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bullet Item Detail')),
      body: const Center(child: Text('Bullet Item Detail')),
    );
  }
}
