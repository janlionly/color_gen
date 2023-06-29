import 'package:yaml/yaml.dart';

import '../constants/constants.dart';
import '../error/error.dart';
import '../utils/utils.dart';
import 'color_config.dart';

class SingleColorConfig implements ColorConfig {
  final int? hex;
  final List<int>? rgb;
  final double? opacity;
  final int? alpha;
  final String name;
  final bool? primary;

  const SingleColorConfig({
    this.alpha,
    this.hex,
    this.opacity,
    this.rgb,
    this.primary,
    required this.name,
  }) : assert(hex != null || rgb != null);

  static SingleColorConfig parseFromHex(
      {required String name, required int data}) {
    return SingleColorConfig(name: name, hex: data);
  }

  static SingleColorConfig parse(
      {required String name, required YamlMap data}) {
    final mapData = data.value;
    List<int>? resolvedRbg;
    if (mapData[ConfigKey.rgb] != null) {
      final splitInt = (mapData[ConfigKey.rgb].toString()).split(',');
      if (splitInt.length != 3) {
        throw const YamlFileHaveWrongFormat();
      }
      for (var value in splitInt) {
        final parsed = int.tryParse(value.trim());
        if (parsed == null) {
          throw const YamlFileHaveWrongFormat();
        }
        resolvedRbg ??= [];
        resolvedRbg.add(parsed);
      }
    }
    final double? opacity =
        double.tryParse(mapData[ConfigKey.opacity].toString());
    final int? alpha = int.tryParse(mapData[ConfigKey.alpha].toString());
    final bool? primary = mapData[ConfigKey.primary] as bool?;
    return SingleColorConfig(
      name: name,
      hex: mapData[ConfigKey.hex] as int?,
      rgb: resolvedRbg,
      opacity: opacity,
      alpha: alpha,
      primary: primary,
    );
  }

  @override
  String serialize({String? nameOverride}) {
    String resolvedString = "static final ${nameOverride ?? name} = ";
    if (hex != null) {
      resolvedString +=
          "Color(0x${hex!.toRadixString(16).padLeft(4, '0').toUpperCase()})";
    } else {
      resolvedString += "Color.fromRGBO(${rgb?[0]}, ${rgb?[1]}, ${rgb?[2]}, 1)";
    }
    if (opacity != null) {
      resolvedString += ".withOpacity($opacity)";
    }
    if (alpha != null) {
      resolvedString += ".withAlpha($alpha)";
    }
    return "$resolvedString;";
  }
}

void main() {
  const testObject = SingleColorConfig(
      name: "shade10", hex: 0xff123459, opacity: 0.5, alpha: 244);
  info(testObject.serialize());
}
