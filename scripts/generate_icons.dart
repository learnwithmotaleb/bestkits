import 'dart:io';

void main() {
  final iconDir = Directory('assets/icons');
  if (!iconDir.existsSync()) {
    print('Error: assets/icons directory not found.');
    return;
  }

  final files = iconDir
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.svg'))
      .toList();

  final buffer = StringBuffer();
  buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
  buffer.writeln('// ignore_for_file: constant_identifier_names');
  buffer.writeln('');
  buffer.writeln('class AppIcons {');
  buffer.writeln('  AppIcons._();');
  buffer.writeln('');
  buffer.writeln('  static const String _basePath = \'assets/icons\';');
  buffer.writeln('');

  for (var file in files) {
    final fileName = file.path.split(Platform.pathSeparator).last;
    final variableName = fileName
        .replaceAll('.svg', '')
        .replaceAll('-', '_')
        .replaceAll(' ', '_')
        .toLowerCase();
    
    // Convert to camelCase if needed, but snake_case is fine for constants.
    // Let's use camelCase for standard Flutter style.
    final camelCaseName = _toCamelCase(variableName);
    
    buffer.writeln('  static const String $camelCaseName = \'\$_basePath/$fileName\';');
  }

  buffer.writeln('}');

  final outputFile = File('lib/utils/app_icons/app_icons.dart');
  outputFile.writeAsStringSync(buffer.toString());

  print('Successfully generated ${files.length} icons in ${outputFile.path}');
}

String _toCamelCase(String text) {
  final words = text.split('_');
  if (words.isEmpty) return text;
  final first = words[0];
  final others = words.skip(1).map((w) => w[0].toUpperCase() + w.substring(1)).join();
  return first + others;
}
