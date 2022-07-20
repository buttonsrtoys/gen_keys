# gen_key

`gen_key` generates widget keys by parsing annotated classes. The keys must be of the form `KeyClassName.keyName`. 

    Text('Hello', key: MyWidgetKeys.helloText);

To generate widget keys, annotate the class that contains the references to the keys with `@GenKey()`:

    @GenKey()
    class MyWidget {
      @override
      Widget build(BuildContext context) {
        return Text('Hello', key: MyWidgetKeys.helloText);
      }
    }

'gen_key' parses the code and generates a separate key class that contains the keys.

    class MyWidgetKeys {
      static const String _prefix = '__MyWidgetKeys__';
      static const Key helloText = Key('${_prefix}helloText');
    }

The key class is a separate file that ends in `.keys.dart` that accompanies your class's `.dart` file. So, the keys in `my_widget.dart` are generated to `my_widget.keys.dart`. This is done by placing the `part` command at the top of your Dart file:

    part `my_widget.keys.dart`

    @GenKey()
    class MyWidget {
      @override
      Widget build(BuildContext context) {
        return Text('Hello', key: MyWidgetKeys.helloText);
      }
    }

Sometimes a class has more keys that are generated elsewhere and you only want those of a specified file. In such cases, give all the class names you want to the `GenKey` command:

    @GenKey((keyClasses: ['MyWidgetKeys'])
    class MyWidget {
      @override
      Widget build(BuildContext context) {
        return Row(children: <Widget> [
          Text('Hello', key: MyWidgetKeys.helloText),
          Text('Hi', key: SomeoneElsesWidgetKeys.buttonText),
        ]);
      }
    }

The above call to `GenKey` will only generate keys for `MyWidgetKeys` and will not generate keys for `SomeoneElsesWidgetKeys`.

To generate the key files, run `flutter pub run build runner build`.

## Example

For a more detailed example, check out [the example]() in the package for large example.



