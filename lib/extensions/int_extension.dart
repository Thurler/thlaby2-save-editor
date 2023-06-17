import 'dart:math';
import 'dart:typed_data';

extension IntExtension on int {
  String toCommaSeparatedNotation() {
    bool negative = this < 0;
    String raw = toString();
    if (negative) {
      raw = raw.substring(1);
    }
    int startingDigits = raw.length % 3;
    if (startingDigits == 0) {
      startingDigits = 3;
    }
    StringBuffer copy = StringBuffer();
    copy.write(raw.substring(0, startingDigits));
    for (int i = startingDigits; i < raw.length; i += 3) {
      copy.write(',${raw.substring(i, i+3)}');
    }
    String sign = negative ? '-' : '';
    return '$sign$copy';
  }

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

  Iterable<int> toI16(Endian endianness) {
    int operand = this;
    if (operand < 0) {
      operand += pow(2, 16) as int;
    }
    return operand.toU16(endianness);
  }

  Iterable<int> toI32(Endian endianness) {
    int operand = this;
    if (operand < 0) {
      operand += pow(2, 32) as int;
    }
    return operand.toU32(endianness);
  }
}

extension BigIntExtension on BigInt {
  String toCommaSeparatedNotation() {
    bool negative = this < BigInt.from(0);
    String raw = toString();
    if (negative) {
      raw = raw.substring(1);
    }
    int startingDigits = raw.length % 3;
    if (startingDigits == 0) {
      startingDigits = 3;
    }
    StringBuffer copy = StringBuffer();
    copy.write(raw.substring(0, startingDigits));
    for (int i = startingDigits; i < raw.length; i += 3) {
      copy.write(',${raw.substring(i, i+3)}');
    }
    String sign = negative ? '-' : '';
    return '$sign$copy';
  }

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
