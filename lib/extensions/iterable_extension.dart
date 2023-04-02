extension IterableExtension<T> on Iterable<T> {
  Iterable<T> deepCopyElements(T Function(T) f) {
    return map((T t)=>f(t));
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
