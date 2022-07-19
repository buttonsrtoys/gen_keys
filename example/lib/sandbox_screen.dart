import 'package:flutter/material.dart';
import 'package:gen_key/annotations.dart';

import 'dash.dart';

part 'sandbox_screen.keys.dart';

/// Mock the Intl package
class S {
  static _StringGetter of(BuildContext context) => _StringGetter();
}

class _StringGetter {
  String get hideDash => 'Hide Dash';
  String get showDash => 'Show Dash';
}

class SandboxScreen extends StatefulWidget {
  const SandboxScreen({Key? key}) : super(key: key);

  @override
  State<SandboxScreen> createState() => _SandboxScreenState();
}

@GenKey()
class _SandboxScreenState extends State<SandboxScreen> {
  bool dashShowing = false;
  int colorCount = 0;

  final List<String> colorNames = ['Red', 'Green', 'Blue'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title: const _ScreenTitle(),
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                if (dashShowing) const Dash(),
                const Spacer(),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      key: SandboxScreenKeys.dashButton,
                      child: Text(
                        dashShowing ? S.of(context).hideDash : S.of(context).showDash,
                        key: SandboxScreenKeys.dashText,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                      onPressed: () => setState(() {
                        dashShowing = !dashShowing;
                      }),
                    ),
                    ElevatedButton(
                      key: SandboxScreenKeys.colorButton,
                      onPressed: () => setState(() {
                        colorCount++;
                      }),
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          const TextStyle(fontSize: 23),
                        ),
                      ),
                      child: const Text('Add Color'),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < colorCount; i++)
                      Text(
                        colorNames[i].toUpperCase(),
                        key: SandboxScreenKeys.colorText(i),
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.green[200],
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

@GenKey()
class _ScreenTitle extends StatelessWidget {
  const _ScreenTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'GenKey Sandbox',
      style: TextStyle(
        fontSize: 44,
        color: Colors.green[100],
        fontWeight: FontWeight.bold,
      ),
      key: SandboxScreenKeys.titleText,
    );
  }
}
