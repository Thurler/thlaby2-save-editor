import 'dart:typed_data';
import 'package:thlaby2_save_editor/extensions/int_extension.dart';
import 'package:thlaby2_save_editor/extensions/list_extension.dart';
import 'package:thlaby2_save_editor/save/enums/item.dart';

class ItemSlot {
  final Item item;
  bool isUnlocked;
  int amount = 0;

  ItemSlot(this.item, {required this.isUnlocked});

  int toUnlockByte() {
    return isUnlocked ? 1 : 0;
  }

  void amountFromBytes({
    required Endian endianness,
    required List<int> bytes,
    required int offset,
  }) {
    amount = bytes.getU16(endianness, offset: offset);
  }

  Iterable<int> toAmountBytes(Endian endianness) {
    return amount.toU16(endianness);
  }

  @override
  String toString() => '${item.name} x$amount (Unlocked: $isUnlocked)';
}
