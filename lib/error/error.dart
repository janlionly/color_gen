class YamlFileNotFound {
  final String fileName;

  const YamlFileNotFound({required this.fileName});

  @override
  String toString() {
    return "$fileName not found in scope";
  }
}

class YamlFileHaveWrongFormat {
  const YamlFileHaveWrongFormat();

  @override
  String toString() {
    return "Yaml file have wrong format";
  }
}

class ColorNotExisted {
  const ColorNotExisted();
  @override
  String toString() {
    return "Color not existed";
  }
}
