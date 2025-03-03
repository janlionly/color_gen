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
  late final String hexString;

  SingleColorConfig({
    this.alpha,
    this.hex,
    this.opacity,
    this.rgb,
    this.primary,
    required this.name,
  }) : assert(hex != null || rgb != null) {
    hexString = _parseHexString();
  }

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

  String _parseHexString() {
    int red;
    int green;
    int blue;
    int alpha;
    if (hex != null) {
      final colorValue = hex! & 0xFFFFFFFF;
      alpha = (0xff000000 & colorValue) >> 24;
      red = (0x00ff0000 & colorValue) >> 16;
      green = (0x0000ff00 & colorValue) >> 8;
      blue = (0x000000ff & colorValue) >> 0;
    } else {
      assert(rgb != null);
      final resolvedRgb = rgb!;
      red = resolvedRgb[0];
      green = resolvedRgb[1];
      blue = resolvedRgb[2];
      alpha = 255;
    }

    if (opacity != null) {
      alpha = (255.0 * opacity!).round();
    }
    if (this.alpha != null) {
      alpha = this.alpha!;
    }
    final resolvedValue = (((alpha & 0xff) << 24) |
            ((red & 0xff) << 16) |
            ((green & 0xff) << 8) |
            ((blue & 0xff) << 0)) &
        0xFFFFFFFF;
    String resolvedString =
        "0x${resolvedValue.toRadixString(16).padLeft(8, '0')}";
    return resolvedString.toUpperCase();
  }

  @override
  String serialize({String? nameOverride}) {
    String resolvedString =
        "static const ${nameOverride ?? name} = Color(${_parseHexString()});";
    return resolvedString;
  }
}

void main() {
  final testObject = SingleColorConfig(name: "shade10", hex: 0xff123459);
  info(testObject.serialize());
  info(testObject.hexString);
}
