import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gen_key/gen_key.dart';

part "main.keys.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

@GenKey()
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          key: MyHomePageKeys.pageTitle,
          widget.title,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              key: MyHomePageKeys.counterText,
              '$_counter',
              style: const TextStyle(fontSize: 64),
            ),
            OutlinedButton(
              key: MyHomePageKeys.randomButton,
              onPressed: () => setState(() {
                _counter = Random().nextInt(100);
              }),
              child: const Text(
                key: MyHomePageKeys.randomButtonText,
                'Set Random',
              ),
            ),
            OutlinedButton(
              key: MyHomePageKeys.fortyTwoButton,
              onPressed: () => setState(() {
                _counter = 42;
              }),
              child: const Text(
                key: MyHomePageKeys.fortyTwoButtonText,
                'Set 42',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: MyHomePageKeys.floatingActionButton,
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(
          key: MyHomePageKeys.floatingActionButtonIcon,
          Icons.add,
        ),
      ),
    );
  }
}
