import 'package:color_gen/utils/utils.dart';
import 'package:dart_style/dart_style.dart';

import 'package:yaml/yaml.dart' as yaml;

import '../configs/color_config.dart';
import '../configs/multi_shade_color_config.dart';
import '../configs/reference_color.dart';
import '../configs/shaded_swatch.dart';
import '../configs/single_color_config.dart';
import '../constants/constants.dart';
import '../error/error.dart';
import '../utils/file_utils.dart';
import 'package:path/path.dart' as path;

class SharedColorGenerator {
  Future<void> generateColorDartFile() async {
    const yamlFileName = defaultPubspecFileName;
    final pubspecFile = getPubspecFile(fileName: yamlFileName);
    if (pubspecFile == null) {
      throw const YamlFileNotFound(fileName: yamlFileName);
    }
    info("Loading YAML file...");
    final pubspecFileContent = pubspecFile.readAsStringSync();
    final parsedYaml = yaml.loadYaml(pubspecFileContent);
    if (parsedYaml is! yaml.YamlMap) {
      throw const YamlFileHaveWrongFormat();
    }
    info("Parsing YAML file...");
    final shadedColorConfig = parsedYaml.value[ConfigKey.shadedColor];
    final className =
        (shadedColorConfig[ConfigKey.className] as String?) ?? defaultClassName;
    final location =
        (shadedColorConfig[ConfigKey.location] as String?) ?? defaultLocation;
    final fileName =
        (shadedColorConfig[ConfigKey.fileName] as String?) ?? defaultFileName;
    final shadedSwatchPrefix =
        (shadedColorConfig[ConfigKey.swatchPrefix] as String?) ??
            defaultShadedSwatchPrefix;
    final colors = shadedColorConfig[ConfigKey.colors];
    if (colors is! yaml.YamlMap) {
      throw const YamlFileHaveWrongFormat();
    }
    final keyWords = {
      ConfigKey.hex,
      ConfigKey.rgb,
      ConfigKey.opacity,
      ConfigKey.alpha,
      ConfigKey.primary,
    };
    final yaml.YamlMap resolvedColor = colors;
    final allColors = resolvedColor.keys.toSet();
    final List<ReferenceColor> referencesColor = [];
    final List<SingleColorConfig> singleColor = [];
    final List<ShadedSwatch> swatch = [];
    final List<MultiShadeColorConfig> multiShadeColor = [];
    final Map<String, dynamic> multiShadeColorMap = {};
    info("Parsing colors...");
    resolvedColor.value.forEach((key, value) {
      if (value is String) {
        if (!allColors.contains(key)) {
          throw const ColorNotExisted();
        }
        referencesColor
            .add(ReferenceColor(colorName: key, referencesColorNames: value));
      } else if (value is yaml.YamlMap) {
        final firstKey = value.keys.toList()[0];
        if (keyWords.contains(firstKey)) {
          singleColor.add(SingleColorConfig.parse(name: key, data: value));
        } else {
          multiShadeColorMap[key] = value;
        }
      } else if (value is int) {
        singleColor.add(SingleColorConfig.parseFromHex(name: key, data: value));
      } else {
        throw const YamlFileHaveWrongFormat();
      }
    });
    final parsedMultiShadeConfig = MultiShadeColorConfig.parseMultiShade(
        multiShadeColorMap, shadedSwatchPrefix);
    multiShadeColor.addAll(parsedMultiShadeConfig.configs);
    swatch.addAll(parsedMultiShadeConfig.swatch);

    final List<ColorConfig> colorsConfig = [
      ...referencesColor,
      ...singleColor,
      ...multiShadeColor
    ];
    info("Writing data...");
    await _writeData(
      className: className,
      location: location,
      configs: colorsConfig,
      swatch: swatch,
      fileName: fileName,
    );
    info("Done");
  }

  Future<void> _writeData({
    required String className,
    required String location,
    required String fileName,
    required List<ColorConfig> configs,
    required List<ShadedSwatch> swatch,
  }) async {
    final template =
        _getTemplate(className: className, configs: configs, swatch: swatch);
    final formatter = DartFormatter();
    final formatted = formatter.format(template);
    final directory = await createOrGetDirectory(location);
    final fullPath = path.join(directory.path, fileName);
    await createOrWriteToFile(fullPath, formatted);
  }

  String _getTemplate({
    required String className,
    required List<ColorConfig> configs,
    required List<ShadedSwatch> swatch,
  }) {
    return """
// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';

// **************************************************************************
// Generator: Color Generator
// Made by Silent Cat
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes
// ignore_for_file: prefer_const_constructors

class $className {
  const $className._();
  ${configs.map((e) => e.serialize()).join()}

}

${swatch.map((e) => e.serialize()).join()}
"""
        .trim();
  }
}
