import 'dart:math';
import 'dart:typed_data';

extension IntExtension on int {
  Iterable<int> toU16(Endian endianness) {
    List<int> bytes = List<int>.filled(2, 0);
    bytes[0] = this % 256;
    bytes[1] = (this ~/ 256) % 256;
    if (endianness == Endian.little) {
      return bytes;
    } else {
      return bytes.reversed;
    }
  }

  Iterable<int> toU32(Endian endianness) {
    List<int> bytes = List<int>.filled(4, 0);
    for (int i = 0; i < 4; i++) {
      bytes[i] = (this ~/ pow(256, i)) % 256;
    }
    if (endianness == Endian.little) {
      return bytes;
    } else {
      return bytes.reversed;
    }
  }
}

extension BigIntExtension on BigInt {
  Iterable<int> toU64(Endian endianness) {
    List<int> bytes = List<int>.filled(8, 0);
    for (int i = 0; i < 8; i++) {
      bytes[i] = ((this ~/ BigInt.from(256).pow(i)) % BigInt.from(256)).toInt();
    }
    if (endianness == Endian.little) {
      return bytes;
    } else {
      return bytes.reversed;
    }
  }
}
