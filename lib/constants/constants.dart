const defaultPubspecFileName = 'color_gen.yaml';
const defaultClassName = "AppColor";
const defaultLocation = 'lib/generate/color/';
const defaultFileName = 'colors.dart';
const defaultShadedSwatchPrefix = '\$ShadedSwatch';

class ConfigKey {
  const ConfigKey._();

  static const shadedColor = 'shaded_color';
  static const className = 'class_name';
  static const location = 'location';
  static const colors = 'colors';
  static const hex = 'hex';
  static const rgb = 'rgb';
  static const opacity = 'opacity';
  static const alpha = 'alpha';
  static const primary = 'primary';
  static const swatchPrefix = 'swatch_prefix';
  static const fileName = 'file_name';
}
