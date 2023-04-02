import 'dart:math';
import 'dart:typed_data';

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

  int getU16(Endian endianness, {int offset = 0}) {
    int result = 0;
    List<int> operands = sublist(offset, offset + 2).map(
      (T t)=>int.parse(t.toString()),
    ).toList();
    if (endianness == Endian.little) {
      result += operands[0];
      result += operands[1] * 256;
    } else {
      result += operands[0] * 256;
      result += operands[1];
    }
    return result;
  }

  int getI16(Endian endianness, {int offset = 0}) {
    int result = getU16(endianness, offset: offset);
    if (result > pow(2, 15)) {
      result -= pow(2, 16) as int;
    }
    return result;
  }

  int getU32(Endian endianness, {int offset = 0}) {
    int result = 0;
    List<int> operands = sublist(offset, offset + 4).map(
      (T t)=>int.parse(t.toString()),
    ).toList();
    for (int i = 0; i < 4; i++) {
      int operand = operands[i];
      if (endianness == Endian.big) {
        operand = operands[3 - i];
      }
      result += operand * (pow(256, i) as int);
    }
    return result;
  }

  int getI32(Endian endianness, {int offset = 0}) {
    int result = getU32(endianness, offset: offset);
    if (result > pow(2, 31)) {
      result -= pow(2, 32) as int;
    }
    return result;
  }

  BigInt getU64(Endian endianness, {int offset = 0}) {
    BigInt result = BigInt.from(0);
    List<BigInt> operands = sublist(offset, offset + 8).map(
      (T t)=>BigInt.from(int.parse(t.toString())),
    ).toList();
    for (int i = 0; i < 8; i++) {
      BigInt operand = operands[i];
      if (endianness == Endian.big) {
        operand = operands[3 - i];
      }
      result += operand * BigInt.from(256).pow(i);
    }
    return result;
  }
}
