import 'package:analyzer/dart/element/element.dart' as el;
import 'package:build/build.dart' as bld;
import 'package:gen_keys/gen_keys.dart';
import 'package:source_gen/source_gen.dart';

/// Return an instance of [KeysFileBuilder]
bld.Builder keysFileBuilder(bld.BuilderOptions options) {
  return KeysFileBuilder();
}

/// Parses Dart code into keys file.
class KeysFileBuilder implements bld.Builder {
  KeysFileBuilder();

  @override
  final buildExtensions = const {
    '.dart': ['.keys.dart']
  };

  @override
  Future<void> build(bld.BuildStep buildStep) async {
    try {
      final fileInputId = buildStep.inputId;
      final filename = fileInputId.pathSegments.last;
      final keysFileInputId = fileInputId.changeExtension('.keys.dart');
      final keysFilename = keysFileInputId.pathSegments.last;
      final libraryElement = await buildStep.resolver.libraryFor(fileInputId);
      const typeChecker = TypeChecker.fromRuntime(GenKeys);
      final annotatedElements = LibraryReader(libraryElement).annotatedWith(typeChecker);

      _throwOnPartOrAnnotationWrong(annotatedElements, keysFilename, filename, libraryElement, fileInputId);

      if (annotatedElements.isNotEmpty) {
        final keyMetas = await _keyMetasFromAnnotatedElements(annotatedElements, buildStep);

        _throwOnAnnotationButNoKeys(keyMetas, fileInputId);

        await _generateKeysFile(filename, keyMetas, buildStep, keysFileInputId);
      }
    } on bld.NonLibraryAssetException {
      // if here, likely hit a file we don't want to process. (e.g., .g.dart file). Do nothing.
    }
  }

  /// Generate [KeyMeta] instances for elements with annotations.
  Future<List<KeyMeta>> _keyMetasFromAnnotatedElements(
    Iterable<AnnotatedElement> annotatedElements,
    bld.BuildStep buildStep,
  ) async {
    final keyMetasForAllClasses = <KeyMeta>[];
    for (final annotatedElement in annotatedElements) {
      final source = annotatedElement.element.source;

      if (source != null) {
        final sourceCode = await _sourceCodeFromBuildStep(annotatedElement.element, buildStep);
        final keyClasses = _keyClassesFromAnnotation(annotatedElement.annotation);
        final keyMetas = keyMetasFromSourceCode(sourceCode, keyClasses);
        keyMetasForAllClasses.addAll(keyMetas);
      }
    }
    return keyMetasForAllClasses;
  }

  /// Perform the code generation.
  Future<void> _generateKeysFile(
    String filename,
    List<KeyMeta> keyMetasForAllClasses,
    bld.BuildStep buildStep,
    bld.AssetId keysFileInputId,
  ) async {
    final buffer = StringBuffer();
    buffer.write(_generateHeader(filename));
    buffer.write(await generateKeyClass(keyMetasForAllClasses));
    await buildStep.writeAsString(keysFileInputId, buffer.toString());
  }

  /// Convenience throw function.
  void _throwOnAnnotationButNoKeys(List<KeyMeta> keyMetasForAllClasses, bld.AssetId fileInputId) {
    if (keyMetasForAllClasses.isEmpty) {
      throw Exception(
        "No keys found in classes annotated with @GenKeys in '$fileInputId'",
      );
    }
  }

  /// Convenience throw function.
  void _throwOnPartOrAnnotationWrong(
    Iterable<AnnotatedElement> annotatedElements,
    String keysFilename,
    String filename,
    el.LibraryElement libraryElement,
    bld.AssetId fileInputId,
  ) {
    final bool havePart = _havePart(libraryElement, keysFilename);

    if (annotatedElements.isNotEmpty && !havePart) {
      throw Exception(
        "The declaration \"part '$keysFilename';\" is missing in '$filename'",
      );
    }

    if (havePart && annotatedElements.isEmpty) {
      throw Exception(
        "No classes annotated with @GenKeys in '$filename'",
      );
    }
  }

  /// returns true of `part` declaration made.
  bool _havePart(
    el.LibraryElement libraryElement,
    String keysFilename,
  ) {
    bool foundPart = false;

    for (final part in libraryElement.parts) {
      if (part.toString().contains('/$keysFilename')) {
        foundPart = true;
        break;
      }
    }

    return foundPart;
  }
}

/// Generate the file header.
String _generateHeader(String partOfFilename) {
  final buffer = StringBuffer();

  buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
  buffer.writeln();
  buffer.writeln("part of '$partOfFilename';");
  buffer.writeln();
  buffer.writeln(
    '// **************************************************************************',
  );
  buffer.writeln('// GenKeyGenerator');
  buffer.writeln(
    '// **************************************************************************',
  );

  return buffer.toString();
}

/// Generate the file source code.
Future<String> _sourceCodeFromBuildStep(
  el.Element element,
  bld.BuildStep buildStep,
) async {
  final ast = await buildStep.resolver.astNodeFor(element);

  late String classSourceCode;

  if (ast == null) {
    classSourceCode = '';
  } else {
    classSourceCode = ast.toSource();
  }

  return classSourceCode;
}

/// Return a list of key classes (if any) in the annotation.
List<String> _keyClassesFromAnnotation(
  ConstantReader annotation,
) {
  final keyClasses = <String>[];

  try {
    annotation.read('keyClasses').listValue.forEach((dartObject) {
      final String? keyClass = dartObject.toStringValue();
      if (keyClass != null) {
        keyClasses.add(keyClass);
      }
    });
  } on FormatException {
    // If here, parameter not entered. Do nothing
  }

  return keyClasses;
}
