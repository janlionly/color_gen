library color_gen;

import 'package:color_gen/color_gen.dart';
import 'package:color_gen/utils/utils.dart';

Future<void> main(List<String> args) async {
  try {
    var generator = SharedColorGenerator();
    await generator.generateColorDartFile();
  } catch (e) {
    exitWithError('Failed to generate color file.\n$e');
  }
}
