# gen_keys

`gen_keys` is a code generator that generates key classes and files. Add your keys to your widgets, annotate the class with `@GenKeys` and `gen_keys` builds the keys file for you.

## How it works

Add your keys to widgets with the format `KeyClassName.keyName`:

    class MyWidget {
      @override
      Widget build(BuildContext context) {
        return Text('Hello', key: MyWidgetKeys.helloText);    // <- Your key
      }
    }

Then annotate the class with `@GenKeys()`:

    @GenKeys()      // <- Add annotation
    class MyWidget {
      @override
      Widget build(BuildContext context) {
        return Text('Hello', key: MyWidgetKeys.helloText);
      }
    }

The key class is a separate file that ends in `.keys.dart`, so you will need the `part` directive at the top of your file:

    part `my_widget.keys.dart`     // Add 'part'

## Now build the .keys.dart file!

Execute `pub run build runner build` to generate your `my_widget.keys.dart` file which has your new keys class:

    part of 'my_widget.dart';

    class MyWidgetKeys {
      static const String _prefix = '__MyWidgetKeys__';
      static const Key helloText = Key('${_prefix}helloText');
    }

## For finer control...

Sometimes a class references references keys your don't want. In that cases, give all the class names you want to the `GenKeys` command:

    @GenKeys((keyClasses: ['MyWidgetKeys'])     // <- Specify which keys to generate here
    class MyWidget {
      @override
      Widget build(BuildContext context) {
        return Row(children: <Widget> [
          Text('Hello', key: MyWidgetKeys.helloText),    // <- You want key generation for this key
          Text('There', key: SomeoneElsesWidgetKeys.buttonText),     // <- But not for this one
        ]);
      }
    }

## That's it!

For questions on anything `gen_keys` please reach out or create an issue.



