extension StringExtension on String {
  String upperCaseFirstChar() {
    return replaceRange(0, 1, this[0].toUpperCase());
  }
}
