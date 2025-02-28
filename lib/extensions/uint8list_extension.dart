import 'dart:math';
import 'dart:typed_data';

extension Uint8ListExtension on Uint8List {
  int getU16(Endian endianness, {int offset = 0}) {
    int result = 0;
    if (endianness == Endian.little) {
      result += this[offset];
      result += this[offset + 1] * 256;
    } else {
      result += this[offset] * 256;
      result += this[offset + 1];
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
    for (int i = 0; i < 4; i++) {
      int operand = this[offset + i];
      if (endianness == Endian.big) {
        operand = this[offset + 3 - i];
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
    for (int i = 0; i < 8; i++) {
      BigInt operand = BigInt.from(this[offset + i]);
      if (endianness == Endian.big) {
        operand = BigInt.from(this[offset + 7 - i]);
      }
      result += operand * BigInt.from(256).pow(i);
    }
    return result;
  }
}
