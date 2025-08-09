import 'package:flutter/material.dart';

class StickyBoardScreen extends StatelessWidget {
  const StickyBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sticky Board")),
      body: const Center(child: Text("Sticky Notes will be displayed here.")),
    );
  }
}