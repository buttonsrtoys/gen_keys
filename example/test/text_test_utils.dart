import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Returns a function that gets a String field from a Widget.
///
/// This is a helper function for [TypeWithStringFinder] and is effectively a switch statement that uses
/// [widgetType] to lookup a widget's String field. Add cases to the switch statement as necessary.
dynamic Function(Widget widget) _stringGetter(Type widgetType) {
  late dynamic Function(Widget widget) stringGetter;

  switch (widgetType) {
    case Text:
      stringGetter = (Widget widget) => (widget as Text).data;
      break;
    default:
      assert(
        false,
        "No getter function found for class type $widgetType. Please add a getter to the switch "
        "statement that generated this error.",
      );
      stringGetter = (Widget widget) => '';
      break;
  }

  return stringGetter;
}

/// Finder for elements of a given type that also have a field that matches the given string.
///
/// [widgetType] is the Type to match.
/// [stringGetter] is a function that receives a Widget and returns the String field to test for matching.
/// [stringSought] is the String to match.
///
/// Note that [Finder.widgetWithText] performs a similar function but traverses the tree and is therefore too slow.
class TypeWithStringFinder extends MatchFinder {
  TypeWithStringFinder({
    required this.widgetType,
    required this.stringGetter,
    required this.stringSought,
    bool skipOffstage = true,
  }) : super(skipOffstage: skipOffstage);

  final Type widgetType;
  dynamic Function(Widget o) stringGetter;
  String stringSought;

  @override
  String get description => 'type "$widgetType" stringSought "$stringSought"';

  @override
  bool matches(Element candidate) {
    return candidate.widget.runtimeType == widgetType && stringGetter(candidate.widget) == stringSought;
  }
}

extension WidgetTesterExtension on WidgetTester {
  /// Returns a [Finder] for Widgets that match one or more parameters
  ///
  /// [intl] receives the `intl` package [S] object and returns the String to find.
  /// [text] is a String to find.
  /// [widgetType] is the Type of widget to find.
  /// [key] is the key to find.
  ///
  /// You can pass no String, [intl], or [text], but not both.
  /// If [key] and [widgetType] are BOTH null, [widgetType] is assumed to be Text
  Finder findBy({
    String? text,
    Type? widgetType,
    ValueKey? key,
  }) {
    final Type? soughtType = key == null && widgetType == null ? Text : widgetType;

    late Finder finder;

    if (key != null) {
      finder = find.byKey(key);
      if (soughtType == Text && text != null) {
        final String widgetText = text;
        expect(find.text(widgetText).evaluate(), finder.evaluate());
      }
    } else {
      finder = find.byType(soughtType!);
      if (text != null) {
        final String widgetText = text;
        if (soughtType == Text) {
          finder = find.text(widgetText);
        } else {
          finder = TypeWithStringFinder(
            widgetType: soughtType,
            stringGetter: _stringGetter(soughtType),
            stringSought: widgetText,
          );
        }
      }
    }

    return finder;
  }

  /// See [findBy] for param descriptions.
  void expectWidget({
    String? text,
    Type? widgetType,
    ValueKey? key,
    Matcher matcher = findsOneWidget,
  }) {
    final Finder finder = findBy(text: text, widgetType: widgetType, key: key);
    expect(finder, matcher);
  }
}
