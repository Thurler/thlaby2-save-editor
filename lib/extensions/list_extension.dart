extension ListExtension<T> on List<T> {
  Iterable<MapEntry<int, T>> enumerate() {
    return asMap().entries;
  }

  List<T> deepCopyElements(T Function(T) f) {
    return map((T t) => f(t)).toList();
  }

  T? elementAtSafe(int index) => index < length ? elementAt(index) : null;
}
