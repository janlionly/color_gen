[![pub package](https://img.shields.io/pub/v/color_gen?color=green&include_prereleases&style=plastic)](https://pub.dev/packages/color_gen)

## Features

`color_gen` package is used for `Color` and `ColorSwatch` generation of your flutter apps.

## Getting started

The generation command is short and concise:

```shell
flutter pub run color_gen:generate   
```

In real projects, you may encounter the need for custom `Color` and  `ColorSwatch` beside
Flutter built-in `Colors` class and `MaterialSwatch`.
Writing these can be tedious and repetitive, this package can help you with such problems.

## Usage

To perform `Color` and `ColorSwatch` generation, you may follow these steps:

- Step 1: create `color_gen.yaml`. This is where you store all your color and color swatch configs.
- Step 2: config the `color_gen.yaml` as your requirements.
- Step 3: run the command:  `flutter pub run color_gen:generate`

### Config

To sum it up, here is the supported format:

```yaml
# color_gen.yaml
shaded_color:
  class_name: ExampleAppColor # Generated color class name, which all member will be static, default to `AppColor`
  file_name: app_colors.dart # Generated file name, default to `colors.dart`
  location: lib/presentation/theme/color/ # folder to store generated file, default to `lib/generate/color/`
  swatch_prefix: $ShadedSwatch # Generated `ColorSwatch` class name, default to to `$ShadedSwatch`
  colors:
    red: # will generate `ColorSwatch` `red` with the following variable: shade10, shade50
      shade10:
        hex: 0xFF132112 # hex color code
        opacity: 1 # will add `.withOpacity(1)` after the color variable.
        primary: true # will make this color primary, if not set, will default to the first shade
      shade50:
        rgb: 12, 12, 41 # rgb is supported as well
        alpha: 244 # will add `.withAlpha(244)` after the color variable.
    blue: # normal color `blue`, contain no shade.
      hex: 0xFF132131
    primary: red # color named `primary` references to color `red`
    purple: 0xff123412 # short version of Color, currently only support hex value
    pink: # short version of ColorSwatch
      shade20: 0xff124912
      shade10: 0xff123512
```

The generated colors of the above config may be used like this:

```dart
import 'lib/presentation/theme/color/app_colors.dart';

final Color red = ExampleAppColor.red;
final Color redShade10 = ExampleAppColor.red.shade10;
final Color blue = ExampleAppColor.blue;
final Color primary = ExampleAppColor.primary; // will actually point to `red`
final Color pink = ExampleAppColor.pink.shade20;
```

For each `Color` or specific shade of `ColorSwatch`, the following format/key is supported:

Short version, currently only hexCode is supported.

```yaml
<colorName>: <hexCode> 
```

Longer version:

```yaml
<colorName>:
  hex: <hexCode>
  rgb: <rgb array> # len = 3
  alpha: <alpha> # 0-255
  opacity: <opacity> # 0-1 
  primary: true | false # only for shaded color of `ColorSwatch`, if not set, the first shade will be chosen as primary
``` 

## Additional information

- Code generation will actually use the shade name as variable name and key for query it
- `ColorSwatch` with the same swatch (the same amount of shades and the same variable names) will
  utilize the same generated swatch class.
- Refer to the example for more details.

