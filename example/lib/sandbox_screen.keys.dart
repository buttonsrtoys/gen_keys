// part: [/example/lib/sandbox_screen.keys.dart]
// element: 
// element: class S {static _StringGetter of(BuildContext context) => _StringGetter();}
// element: class _StringGetter {String get hideDash => 'Hide Dash'; String get showDash => 'Show Dash';}
// element: class SandboxScreen extends StatefulWidget {const SandboxScreen({Key? key}) : super(key: key); @override State<SandboxScreen> createState() => _SandboxScreenState();}
// element: @Testable() class _SandboxScreenState extends State<SandboxScreen> {bool dashShowing = false; int colorCount = 0; final List<String> colorNames = ['Red', 'Green', 'Blue']; @override Widget build(BuildContext context) {return Scaffold(appBar: AppBar(backgroundColor: Colors.green[600], title: const _ScreenTitle(), centerTitle: true), body: Center(child: Stack(children: <Widget>[Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Spacer(), if (dashShowing) const Dash(), const Spacer(), Row(children: [const Spacer(), TextButton(key: SandboxScreenKeys.dashButton, child: Text(dashShowing ? S.of(context).hideDash : S.of(context).showDash, key: SandboxScreenKeys.dashText, style: const TextStyle(fontSize: 20.0)), onPressed: () => setState(() {dashShowing = !dashShowing;})), ElevatedButton(key: SandboxScreenKeys.colorButton, onPressed: () => setState(() {colorCount++;}), child: const Text('Add Color'), style: ButtonStyle(textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 23)))), const Spacer()]), const SizedBox(height: 50), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [for (int i = 0; i < colorCount; i++) Text(colorNames[i].toUpperCase(), key: SandboxScreenKeys.colorText(i), style: TextStyle(fontSize: 36, color: Colors.green[200], fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))]), const Spacer()])])));}}
// element: @Testable() class _ScreenTitle extends StatelessWidget {const _ScreenTitle({Key? key}) : super(key: key); @override Widget build(BuildContext context) {return Text('Testable Sandbox', style: TextStyle(fontSize: 44, color: Colors.green[100], fontWeight: FontWeight.bold), key: SandboxScreenKeys.titleText);}}
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sandbox_screen.dart';

// **************************************************************************
// TestableGenerator
// **************************************************************************

class SandboxScreenKeys {
	static const String _prefix = '__SandboxScreenKeys__';
	static const ValueKey dashButton = ValueKey<String>('${_prefix}dashButton__');
	static const ValueKey dashText = ValueKey<String>('${_prefix}dashText__');
	static const ValueKey colorButton = ValueKey<String>('${_prefix}colorButton__');
	static ValueKey colorText(Object object) => ValueKey<String>('${_prefix}colorText__${object}__');
	static const ValueKey titleText = ValueKey<String>('${_prefix}titleText__');
}
