import 'package:example/sandbox_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../testable/common_class_types.dart';

MaterialApp TestApp() {
  return const MaterialApp(
    home: SandboxScreen(),
    debugShowCheckedModeBanner: false,
  );
}

void main() {
  setUpAll(() {
    // registerClassTypes(commonClassTypes);
    // registerClassTypes({SandboxScreen});
  });

  testWidgets('Test for initial widgets', (WidgetTester tester) async {
    await tester.pumpWidget(TestApp());

    // generateWidgetTests(tester, testAppBuilder: TestApp, shouldGesture: true);
  });
}
