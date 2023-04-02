import 'dart:typed_data';
import 'package:thlaby2_save_editor/extensions/int_extension.dart';

class Equipment {
  late int id;

  Equipment({required this.id});

  Equipment.from(Equipment other) {
    id = other.id;
  }

  Iterable<int> toBytes(Endian endianness) {
    return id.toU16(endianness);
  }
}
