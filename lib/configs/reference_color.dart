import 'color_config.dart';

class ReferenceColor implements ColorConfig {
  final String colorName;
  final String referencesColorNames;

  const ReferenceColor({
    required this.colorName,
    required this.referencesColorNames,
  });

  @override
  String serialize({String? nameOverride}) {
    return "static const $colorName = $referencesColorNames;";
  }
}
