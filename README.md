# gen_keys

![gen_keys](https://github.com/buttonsrtoys/gen_keys/blob/main/assets/GenKeysLogo.png)

Code generator for widget keys. Builds a keys class in a separate parts file for classes annotated with @GenKeys().

## How it works

Add your keys to widgets with the format `KeyClassName.keyName`:

    class MyWidget {
      @override
      Widget build(BuildContext context) {
        return Text('Hello', key: MyWidgetKeys.greeting);    // <- Your key
      }
    }

Then annotate the class with `@GenKeys()`:

    @GenKeys()      // <- Add annotation
    class MyWidget {
      @override
      Widget build(BuildContext context) {
        return Text('Hello', key: MyWidgetKeys.greeting);
      }
    }

The key class is a separate file that ends in `.keys.dart`, so add the `part` directive at the top of your file:

    part `my_widget.keys.dart`

## Now build the .keys.dart file!

Execute `pub run build runner build` to generate your `my_widget.keys.dart` file which has your new keys class:

    part of 'my_widget.dart';

    class MyWidgetKeys {
      static const String _prefix = '__MyWidgetKeys__';
      static const Key greeting = Key('${_prefix}greeting');
    }

## For finer control...

Sometimes a class references references keys your don't want. In that cases, give all the class names you want to the `@GenKeys` command:

    @GenKeys((keyClasses: ['MyWidgetKeys']) // <- Optionally specify the key class to generate
    class MyWidget {
      @override
      Widget build(BuildContext context) {
        return Row(children: <Widget> [
          Text('Hello', key: MyWidgetKeys.greeting), // <- Generates this key
          Text('There', key: YourWidgetKeys.buttonText), // <- But not this one
        ]);
      }
    }

## Example

Rich, infill

## That's it!

For questions on anything `gen_key` please reach out or create an issue.