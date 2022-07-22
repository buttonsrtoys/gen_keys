import 'package:flutter_test/flutter_test.dart';
import 'package:gen_key/functions.dart';

void main() {
  const prefix = '<KeysFileBuilder Tests> ';
  const keyClassName = 'MyClassKeys';
  const keyName = 'myKey';
  const fullKeyName = '$keyClassName.$keyName';
  const anotherFullKeyNameWithSameKeyClass = '$keyClassName.anotherKeyName';
  const anotherFullKeyNameWithDifferentKeyClass = 'anotherClassKeys.anotherKeyName';
  const keyClassesOneClass = <String>[keyClassName];
  const keyClassesNoClasses = <String>[];

  group('$prefix key generation ', () {
    test('generates for key followed by comma', () {
      const sourceCode = "blah blah blah key: $fullKeyName, blah blah blah blah blah blah";
      final keyMetas = keyMetasFromSourceCode(sourceCode, keyClassesNoClasses);
      expect(keyMetas.length, 1);
      final keyDeclaration = keyDeclarationFromKeyMeta(keyMetas[0]);
      expect(keyDeclaration, "\tstatic const ValueKey myKey = ValueKey<String>('\${prefix}${keyName}__');");
    });

    test('generates for key followed by parenthesis', () {
      const sourceCode = "blah blah blah key: $fullKeyName) blah blah blah blah blah blah";
      final keyMetas = keyMetasFromSourceCode(sourceCode, keyClassesNoClasses);
      expect(keyMetas.length, 1);
      final keyDeclaration = keyDeclarationFromKeyMeta(keyMetas[0]);
      expect(keyDeclaration, "\tstatic const ValueKey myKey = ValueKey<String>('\${prefix}${keyName}__');");
    });

    test('ignores key followed by space', () {
      const sourceCode = "blah blah blah key: $fullKeyName blah blah blah blah blah blah";
      final keyMetas = keyMetasFromSourceCode(sourceCode, keyClassesNoClasses);
      expect(keyMetas.length, 0);
    });

    test('ignores key without decimal', () {
      const sourceCode = "blah blah blah key: $keyClassName, blah blah blah blah blah blah";
      final keyMetas = keyMetasFromSourceCode(sourceCode, keyClassesNoClasses);
      expect(keyMetas.length, 0);
    });

    test('ignores key with two decimals', () {
      const sourceCode = "blah blah blah key: $fullKeyName.tooMany, blah blah blah blah blah blah";
      final keyMetas = keyMetasFromSourceCode(sourceCode, keyClassesNoClasses);
      expect(keyMetas.length, 0);
    });

    test('ignores key with two decimals', () {
      const sourceCode = "blah blah blah key: $fullKeyName.wrong, blah blah blah blah blah blah";
      final keyMetas = keyMetasFromSourceCode(sourceCode, keyClassesNoClasses);
      expect(keyMetas.length, 0);
    });

    test('generates for indexed key', () {
      const sourceCode = "blah blah blah key: $fullKeyName(someIndex), blah blah blah blah blah blah";
      final keyMetas = keyMetasFromSourceCode(sourceCode, keyClassesNoClasses);
      expect(keyMetas.length, 1);
      final keyDeclaration = keyDeclarationFromKeyMeta(keyMetas[0]);
      expect(
        keyDeclaration,
        "\tstatic ValueKey myKey(Object object) => ValueKey<String>('\${prefix}myKey__\${object}__');",
      );
    });

    test('generates two keys when key class name is the same', () {
      const sourceCode =
          "blah blah blah key: $fullKeyName, blah blah key: $anotherFullKeyNameWithSameKeyClass, blah blah blah blah";
      final keyMetas = keyMetasFromSourceCode(sourceCode, keyClassesNoClasses);
      expect(keyMetas.length, 2);
    });

    test('generates two keys when key class names are different', () {
      const sourceCode =
          "blah blah blah key: $fullKeyName, blah blah key: $anotherFullKeyNameWithDifferentKeyClass, blah blah blah blah";
      final keyMetas = keyMetasFromSourceCode(sourceCode, keyClassesNoClasses);
      expect(keyMetas.length, 2);
    });

    test('generates ignores key when key class name not passed as parameter', () {
      const sourceCode =
          "blah blah blah key: $fullKeyName, blah blah key: $anotherFullKeyNameWithDifferentKeyClass, blah blah blah blah";
      final keyMetas = keyMetasFromSourceCode(sourceCode, keyClassesOneClass);
      expect(keyMetas.length, 1);
    });
  });
}
