import 'dart:io';
import 'package:path/path.dart' as path;
import '../constants/constants.dart';

File? getPubspecFile({String fileName = defaultPubspecFileName}) {
  final rootDirPath = Directory.current.path;
  final pubspecFilePath = path.join(rootDirPath, fileName);
  final file = File(pubspecFilePath);
  if (file.existsSync()) {
    return file;
  }
  return null;
}

Future<Directory> createOrGetDirectory(String path) async {
  final dir = Directory(path);
  final existed = dir.existsSync();
  if (existed) {
    return dir;
  }
  dir.create(recursive: true);
  return dir;
}

Future<void> createOrWriteToFile(String path, String contents) async {
  final file = File(path);
  if (!file.existsSync()) {
    await file.create(recursive: true);
  }
  await file.writeAsString(contents);
}
