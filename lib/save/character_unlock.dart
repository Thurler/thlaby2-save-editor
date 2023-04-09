import 'package:thlaby2_save_editor/save/character.dart';

class CharacterUnlockFlag {
  late Character character;
  late bool isUnlocked;

  CharacterUnlockFlag({
    required this.character,
    required this.isUnlocked,
  });

  CharacterUnlockFlag.from(CharacterUnlockFlag other) {
    character = other.character;
    isUnlocked = other.isUnlocked;
  }

  @override
  String toString() {
    return '${character.name}: $isUnlocked';
  }
}
