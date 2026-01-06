import 'package:thlaby2_save_editor/save/enums/character.dart';

class PartySlot {
  Character? character;

  PartySlot.empty();

  PartySlot.filled(int byte) : character = Character.values.elementAt(byte - 1);

  PartySlot.from(PartySlot other) : character = other.character;

  bool get isUsed => character != null;

  int toByte() => isUsed ? character!.index + 1 : 0;

  @override
  String toString() => character?.name ?? 'empty';
}
