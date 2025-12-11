import 'package:flutter/material.dart';

class SnackbarService {
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void show(String message) {
    messengerKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }
}
