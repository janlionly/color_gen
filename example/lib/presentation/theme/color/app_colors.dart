// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';

// **************************************************************************
// Generator: Shaded Color Generator
// Made by Silent Cat
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes
// ignore_for_file: prefer_const_constructors

class ExampleAppColor {
  const ExampleAppColor._();
  static final primary = red;
  static final blue = Color(0xFF132131).withOpacity(0.5).withAlpha(123);
  static final purple = Color(0xFF123412);
  static final _redShade10 = Color(0xFF132112).withOpacity(1.0);
  static final _redShade50 = Color(0xFF123112).withOpacity(0.5).withAlpha(244);
  static final Map<String, Color> _redColorMap = {
    "shade10": _redShade10,
    "shade50": _redShade50,
  };
  static final red =
      $ShadedSwatch0(_redColorMap["shade10"]!.value, _redColorMap);
  static final _yellowShade10 = Color(0xFF132112).withOpacity(1.0);
  static final _yellowShade50 =
      Color(0xFF123112).withOpacity(0.5).withAlpha(244);
  static final Map<String, Color> _yellowColorMap = {
    "shade10": _yellowShade10,
    "shade50": _yellowShade50,
  };
  static final yellow =
      $ShadedSwatch0(_yellowColorMap["shade50"]!.value, _yellowColorMap);
  static final _brownShade20 = Color(0xFF132112).withOpacity(1.0);
  static final _brownShade50 =
      Color.fromRGBO(12, 12, 256, 1).withOpacity(0.5).withAlpha(244);
  static final Map<String, Color> _brownColorMap = {
    "shade20": _brownShade20,
    "shade50": _brownShade50,
  };
  static final brown =
      $ShadedSwatch1(_brownColorMap["shade20"]!.value, _brownColorMap);
  static final _pinkShade20 = Color(0xFF124912);
  static final _pinkShade10 = Color(0xFF123512);
  static final Map<String, Color> _pinkColorMap = {
    "shade20": _pinkShade20,
    "shade10": _pinkShade10,
  };
  static final pink =
      $ShadedSwatch2(_pinkColorMap["shade20"]!.value, _pinkColorMap);
}

class $ShadedSwatch0 extends ColorSwatch<String> {
  const $ShadedSwatch0(super.primary, super.swatch);
  Color get shade10 => this["shade10"]!;
  Color get shade50 => this["shade50"]!;
}

class $ShadedSwatch1 extends ColorSwatch<String> {
  const $ShadedSwatch1(super.primary, super.swatch);
  Color get shade20 => this["shade20"]!;
  Color get shade50 => this["shade50"]!;
}

class $ShadedSwatch2 extends ColorSwatch<String> {
  const $ShadedSwatch2(super.primary, super.swatch);
  Color get shade20 => this["shade20"]!;
  Color get shade10 => this["shade10"]!;
}
