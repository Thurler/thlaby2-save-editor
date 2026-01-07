import 'package:thlaby2_save_editor/save/enums/character.dart';

class CharacterUnlockFlag {
  final Character character;
  bool isUnlocked;

  CharacterUnlockFlag({
    required this.character,
    required this.isUnlocked,
  });

  CharacterUnlockFlag.from(CharacterUnlockFlag other) :
    character = other.character,
    isUnlocked = other.isUnlocked;

  @override
  String toString() => '${character.name}: $isUnlocked';

  @override
  bool operator ==(Object other) =>
      other is CharacterUnlockFlag &&
      character.name == other.character.name &&
      isUnlocked == other.isUnlocked;

  @override
  int get hashCode => Object.hash(character.name, isUnlocked);
}
