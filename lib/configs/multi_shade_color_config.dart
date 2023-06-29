import 'package:yaml/yaml.dart';

import '../error/error.dart';
import '../utils/utils.dart';
import 'color_config.dart';
import 'shaded_swatch.dart';
import 'single_color_config.dart';

class MultiShadeClassWrapper {
  final List<MultiShadeColorConfig> configs;
  final List<ShadedSwatch> swatch;

  const MultiShadeClassWrapper({
    required this.configs,
    required this.swatch,
  });
}

class MultiShadeColorConfig implements ColorConfig {
  const MultiShadeColorConfig({
    required this.configs,
    required this.shadedClassName,
    required this.variableName,
  });

  final List<SingleColorConfig> configs;
  final String shadedClassName;
  final String variableName;

  static MultiShadeClassWrapper parseMultiShade(
      Map<String, dynamic> data, String shadedSwatchPrefix) {
    final List<MultiShadeColorConfig> configs = [];
    final List<ShadedSwatch> swatch = [];
    List<Set<dynamic>> existedShade = [];
    data.forEach((key, value) {
      final colorName = key;
      if (value is! YamlMap) {
        throw const YamlFileHaveWrongFormat();
      }
      final YamlMap resolvedValue = value;
      final currentSet = resolvedValue.keys.toSet();
      int? indexMatch;
      for (int i = 0; i < existedShade.length; i++) {
        if (setEquals(existedShade[i], currentSet)) {
          indexMatch = i;
          break;
        }
      }
      if (indexMatch == null) {
        indexMatch = existedShade.length;
        existedShade.add(currentSet);
        swatch.add(
          ShadedSwatch(
            className: "$shadedSwatchPrefix$indexMatch",
            shades: resolvedValue.keys.map((e) => e.toString()).toList(),
          ),
        );
      }
      final shadedClassName = "$shadedSwatchPrefix$indexMatch";
      final List<SingleColorConfig> singleShadeColorConfig = [];
      resolvedValue.forEach(
        (key, value) {
          if (value is YamlMap) {
            singleShadeColorConfig
                .add(SingleColorConfig.parse(name: key, data: value));
          } else if (value is int) {
            singleShadeColorConfig
                .add(SingleColorConfig.parseFromHex(name: key, data: value));
          } else {
            throw const YamlFileHaveWrongFormat();
          }
        },
      );
      final multiShadeColorConfig = MultiShadeColorConfig(
        configs: singleShadeColorConfig,
        shadedClassName: shadedClassName,
        variableName: colorName,
      );
      configs.add(multiShadeColorConfig);
    });
    return MultiShadeClassWrapper(configs: configs, swatch: swatch);
  }

  @override
  String serialize({String? nameOverride}) {
    final resolvedVariableName = nameOverride ?? variableName;
    String colorVariables = "";
    String mapContent = "";
    String primaryName = "";
    for (var value in configs) {
      if (value.primary == true || primaryName.isEmpty) {
        primaryName = value.name;
      }
      final colorVarName =
          '_$resolvedVariableName${value.name.replaceRange(0, 1, value.name[0].toUpperCase())}';
      colorVariables += "${value.serialize(nameOverride: colorVarName)}\n";
      mapContent += "'${value.name}' : $colorVarName,\n";
    }
    String resultedSerialize = '''
    static final Map<String, Color> _${resolvedVariableName}ColorMap = {
    $mapContent
    };
    static final $resolvedVariableName =  $shadedClassName(_${resolvedVariableName}ColorMap['$primaryName']!.value, _${resolvedVariableName}ColorMap);
    ''';
    return "$colorVariables$resultedSerialize";
  }
}

bool setEquals<T>(Set<T>? a, Set<T>? b) {
  if (a == null) {
    return b == null;
  }
  if (b == null || a.length != b.length) {
    return false;
  }
  if (identical(a, b)) {
    return true;
  }
  for (final T value in a) {
    if (!b.contains(value)) {
      return false;
    }
  }
  return true;
}

void main() {
  const testObject = MultiShadeColorConfig(
    shadedClassName: "\$TestColorClass",
    variableName: "red",
    configs: [
      SingleColorConfig(name: "shade10", hex: 123),
      SingleColorConfig(name: "shade20", hex: 124),
      SingleColorConfig(name: "shade30", hex: 125),
    ],
  );
  info(testObject.serialize());
}
