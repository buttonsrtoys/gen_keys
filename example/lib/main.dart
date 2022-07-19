import 'package:flutter/material.dart';

import '../sandbox_screen.dart';

void main() {
  runApp(const TestableExample());
}

class TestableExample extends StatelessWidget {
  const TestableExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SandboxScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
