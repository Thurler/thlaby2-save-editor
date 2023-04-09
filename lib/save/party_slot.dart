import 'package:thlaby2_save_editor/save/character.dart';

class PartySlot {
  late Character character;
  late bool isUsed;

  PartySlot.empty() : isUsed = false;
  PartySlot.filled(int byte) {
    character = Character.values.elementAt(byte - 1);
    isUsed = true;
  }

  PartySlot.from(PartySlot other) {
    isUsed = other.isUsed;
    if (isUsed) {
      character = other.character;
    }
  }

  int toByte() {
    return isUsed ? character.index + 1 : 0;
  }

  @override
  String toString() {
    return isUsed ? character.name : 'empty';
  }
}
