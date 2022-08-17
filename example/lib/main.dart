import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gen_keys/gen_keys.dart';

part 'main.keys.dart';                  // <- Add the 'part' directive...

void main() {
  runApp(const MyApp());
}

@GenKeys()                               // <- ...an annotation...
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
        key: MainKeys.homePage,         // <- ...and keys....
        title: 'example',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

@GenKeys()                               // <- ...and another annotation...
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
        key: MainKeys.appBarText,       // ...and keys...
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              key: MainKeys.count,      // <- ...keys...
              '$_counter',
              style: const TextStyle(fontSize: 64),
            ),
            OutlinedButton(
              key: MainKeys.randomButton,
              onPressed: () => setState(() {
                _counter = Random().nextInt(100);
              }),
              child: const Text(
                key: MainKeys.randomButtonText,
                'Set Random',
              ),
            ),
            OutlinedButton(
              key: MainKeys.fortyTwoButton,
              onPressed: () => setState(() {
                _counter = 42;
              }),
              child: const Text(
                key: MainKeys.fortyTwoButtonText,
                'Set 42',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: MainKeys.fab,              // <- ...and more keys!
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// then 'pub run build_runner build' to generate the keys file
