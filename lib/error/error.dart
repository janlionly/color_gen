class PubspecFileNotFound {
  final String fileName;

  const PubspecFileNotFound({required this.fileName});

  @override
  String toString() {
    return "$fileName not found in scope";
  }
}

class PubspecFileHaveWrongFormat {
  const PubspecFileHaveWrongFormat();

  @override
  String toString() {
    return "Yaml file have wrong format";
  }
}


class ColorNotExisted{
  const ColorNotExisted();
  @override
  String toString() {
    return "Color not existed";
  }
}