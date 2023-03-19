extension ListExtension<T> on List<T> {
  List<T> deepCopyElements(T Function(T) f) {
    return map((T t)=>f(t)).toList();
  }

  List<T> separateWith(T separator, {bool separatorOnEnds = false}) {
    List<T> result = <T>[];
    if (separatorOnEnds) {
      result.add(separator);
    }
    for (int i = 0; i < length - 1; i++) {
      result.addAll(<T>[elementAt(i), separator]);
    }
    result.add(elementAt(length - 1));
    if (separatorOnEnds) {
      result.add(separator);
    }
    return result;
  }
}
