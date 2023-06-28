import '../utils/utils.dart';
import 'serializable_config.dart';

class ShadedSwatch implements SerializableConfig {
  final String className;
  final List<String> shades;

  const ShadedSwatch({
    required this.className,
    required this.shades,
  });

  @override
  String serialize({String? nameOverride}) {
    final resolvedName = nameOverride ?? className;
    String content = "";
    for (var shade in shades) {
      content += "Color get $shade => this[\"$shade\"]!;\n";
    }
    String resolved = '''
    class $resolvedName extends ColorSwatch<String> {
      const $resolvedName(super.primary, super.swatch);
      $content
    }
    ''';
    return resolved;
  }
}

void main() {
  const testObj = ShadedSwatch(
    className: "\$ShadedSwatch0",
    shades: [
      "shade0",
      "shade1",
      "shade2",
      "shade3",
    ],
  );
  info(testObj.serialize());
}
