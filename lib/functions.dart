part of './gen_keys.dart';

/// Attributes of the key
class KeyMeta {
  String keyClassName = '';
  String keyName = '';
  bool isFunction = false;
}

/// Generate the class containing the keys
///
/// Returns the generated class
Future<String> generateKeyClass(List<KeyMeta> keyMetas) async {
  final buffer = StringBuffer();

  final keyClass = _keyClassFromKeyMetas(keyMetas);

  buffer.write(keyClass);

  return buffer.toString();
}

String _keyClassFromKeyMetas(List<KeyMeta> keyMetas) {
  final buffer = StringBuffer();

  keyMetas.sort((a, b) => a.keyClassName.compareTo(b.keyClassName));

  String currentKeyClassName = '';
  bool haveKeyClassDeclaration = false;
  if (keyMetas.isNotEmpty) {
    for (final keyMeta in keyMetas) {
      if (keyMeta.keyClassName != currentKeyClassName) {
        if (haveKeyClassDeclaration) {
          buffer.writeln('}');
        }
        buffer.writeln();
        buffer.writeln('class ${keyMeta.keyClassName} {');
        buffer.writeln("\tstatic const String _prefix = '__${keyMeta.keyClassName}__';");
        haveKeyClassDeclaration = true;
        currentKeyClassName = keyMeta.keyClassName;
      }
      buffer.writeln(keyDeclarationFromKeyMeta(keyMeta));
    }

    buffer.writeln('}');
  }

  return buffer.toString();
}

/// Generates a key declaration within the key class
///
/// [keyMeta] is the information about the key.
///
/// Returns the key declaration.
String keyDeclarationFromKeyMeta(KeyMeta keyMeta) {
  late String keyDeclaration;
  if (keyMeta.isFunction) {
    keyDeclaration = '\tstatic Key ${keyMeta.keyName}(Object object) => '
        "Key('\${_prefix}${keyMeta.keyName}__\$object');";
  } else {
    keyDeclaration = '\tstatic const Key ${keyMeta.keyName} = '
        "Key('\${_prefix}${keyMeta.keyName}');";
  }

  return keyDeclaration;
}

/// Parses Dart code into key meta data
///
/// [classSourceCode] is dart source code for parsing.
/// [keyClasses] is the names of the key classes to search for.
///
/// Returns list of [KeyMeta].
List<KeyMeta> keyMetasFromSourceCode(
  String classSourceCode,
  List<String> keyClasses,
) {
  final keyStrings = _getKeyStrings(classSourceCode);
  final uniqueKeyStrings = keyStrings.toSet().toList();
  return _keyMetasFromKeyStrings(uniqueKeyStrings, keyClasses);
}

/// Return a list of strings with found keys (if any).
List<String> _getKeyStrings(String sourceCode) {
  final keyStrings = <String>[];
  final expression = RegExp(r'(?<=key\: )(\w+\.\w+\(?\w*)(?=[\,|\)])');
  final Iterable<Match> matches = expression.allMatches(sourceCode);

  for (final match in matches) {
    final potentialKey = match[0]!;
    keyStrings.add(potentialKey);
  }

  return keyStrings;
}

/// Parses strings with keys to build [KeyMeta] files
///
/// [keyStrings] are the original source code strings to be parsed.
/// [keyClasses] is a list of valid names for the key classes. If the list is empty, any name is valid.
/// If the list is not empty, only class names in the list will be extracted into [KeyMeta] files.
List<KeyMeta> _keyMetasFromKeyStrings(
  List<String> keyStrings,
  List<String> keyClasses,
) {
  final keyMetas = <KeyMeta>[];

  for (final keyString in keyStrings) {
    final indexOfPeriod = keyString.indexOf('.');
    final keyClassName = keyString.substring(0, indexOfPeriod);

    if (keyClasses.isEmpty || keyClasses.contains(keyClassName)) {
      final keyMeta = KeyMeta();
      keyMeta.keyClassName = keyClassName;

      if (keyString.contains('(')) {
        keyMeta.isFunction = true;
        keyMeta.keyName = keyString.substring(indexOfPeriod + 1, keyString.indexOf('('));
      } else {
        keyMeta.keyName = keyString.substring(indexOfPeriod + 1);
      }

      keyMetas.add(keyMeta);
    }
  }

  return keyMetas;
}
