import 'dart:typed_data';
import 'package:tfields/extensions.dart';
import 'package:thlaby2_save_editor/save/enums/item.dart';

class ItemSlot<I extends Item> {
  final I item;
  bool isUnlocked;
  int amount;

  ItemSlot(this.item, {required this.isUnlocked, this.amount = 0});

  ItemSlot.from(ItemSlot<I> other) :
    item = other.item,
    isUnlocked = other.isUnlocked,
    amount = other.amount;

  int toUnlockByte() => isUnlocked ? 1 : 0;

  void amountFromBytes({
    required Endian endianness,
    required Uint8List bytes,
    required int offset,
  }) {
    amount = bytes.getU16(endianness, offset: offset);
  }

  Iterable<int> toAmountBytes(Endian endianness) => amount.toU16(endianness);

  @override
  String toString() => '${item.prettyName} x$amount (Unlocked: $isUnlocked)';
}
