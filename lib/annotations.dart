part of './gen_keys.dart';

/// build_runner annotation for generating key classes
///
/// [keyClasses] is an optional parameter to explicitly list the names of the key classes to be generated. If the
/// list is empty, all keys within the annotated class will be placed in a respective generated key class.
/// This parameter is typically only used when the source code contains keys that are declared elsewhere, so do not
/// need to be generated.
///
/// E.g., below, a key class would not be generated for "YourWidgetKeys"
///
///     @GenKeys((keyClasses: ['MyWidgetKeys']) // <- Optionally specify the key class to generate
///     class MyWidget {
///       @override
///       Widget build(BuildContext context) {
///         return Row(children: <Widget> [
///           Text('Hello', key: MyWidgetKeys.helloText), // <- Generates this key
///           Text('There', key: YourWidgetKeys.buttonText), // <- But not this one
///         ]);
///       }
///     }
///
class GenKeys {
  const GenKeys({
    this.keyClasses = const [],
  });

  final List<String> keyClasses;
}
