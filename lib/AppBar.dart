import 'package:flutter/material.dart';

class AppBarMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Super Duper Led App',
        style: TextStyle(
          fontFamily: 'serif-monospace',
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
