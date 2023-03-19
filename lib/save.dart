enum CharacterName {
  reimu,
  marisa,
  rinnosuke,
  keine,
  momiji,
  youmu,
  kogasa,
  rumia,
  cirno,
  minoriko,
  komachi,
  chen,
  nitori,
  parsee,
  wriggle,
  kaguya,
  mokou,
  aya,
  mystia,
  kasen,
  nazrin,
  hina,
  rin,
  utsuho,
  satori,
  yuugi,
  meiling,
  alice,
  patchouli,
  eirin,
  reisen,
  sanae,
  iku,
  suika,
  ran,
  remilia,
  sakuya,
  kanako,
  suwako,
  tenshi,
  flandre,
  yuyuko,
  yuuka,
  yukari,
  byakuren,
  eiki,
  renko,
  maribel,
  shou,
  mamizou,
  futo,
  miko,
  kokoro,
  tokiko,
  koishi,
  akyuu,
}

class CharacterUnlockFlag {
  late CharacterName character;
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

class SaveFileWrapper {
  static final SaveFileWrapper _saveFileWrapper = SaveFileWrapper._internal();

  late SaveFile saveFile;

  factory SaveFileWrapper() {
    return _saveFileWrapper;
  }

  SaveFileWrapper._internal();
}

abstract class SaveFile {
  late List<CharacterUnlockFlag> characterUnlockFlags;
  List<int> achievementData = <int>[];
  List<int> achievementDataPlus = <int>[];
  List<int> achievementNotificationsData = <int>[];
  List<int> achievementNotificationsDataPlus = <int>[];
  List<int> bestiaryData = <int>[];
  List<int> partyData = <int>[];
  List<int> generalGameData = <int>[];
  List<int> eventFlagData = <int>[];
  List<int> mainInventoryFlagData = <int>[];
  List<int> subInventoryFlagData = <int>[];
  List<int> materialInventoryFlagData = <int>[];
  List<int> specialInventoryFlagData = <int>[];
  List<int> mainInventoryData = <int>[];
  List<int> subInventoryData = <int>[];
  List<int> materialInventoryData = <int>[];
  List<int> specialInventoryData = <int>[];
  List<int> characterData = <int>[];
  List<int> mainMapData = <int>[];
  List<int> undergroundMapData = <int>[];

  //
  // Virtual methods that must be overriden
  //

  // This method should write the entire save file content to the provided sink
  List<int> export();

  //
  // Public methods
  //

  Iterable<int> getCharacterUnlockFlags() {
    return characterUnlockFlags.map<int>(
      (CharacterUnlockFlag flag) => (flag.isUnlocked) ? 0x1 : 0x0,
    );
  }

  void setCharacterUnlockFlagsFromBytes(List<int> bytes) {
    characterUnlockFlags = <CharacterUnlockFlag>[];
    for (int i = 0; i < bytes.length; i++) {
      characterUnlockFlags.add(
        CharacterUnlockFlag(
          character: CharacterName.values.elementAt(i),
          isUnlocked: bytes[i] > 0x0,
        ),
      );
    }
  }

  // ignore: use_setters_to_change_properties
  void setAchievementData(List<int> bytes) => achievementData = bytes;
  // ignore: use_setters_to_change_properties
  void setAchievementDataPlus(List<int> bytes) => achievementDataPlus = bytes;
  // ignore: use_setters_to_change_properties
  void setAchievementNotificationData(List<int> bytes) =>
    achievementNotificationsData = bytes;
  // ignore: use_setters_to_change_properties
  void setAchievementNotificationDataPlus(List<int> bytes) =>
    achievementNotificationsDataPlus = bytes;
  // ignore: use_setters_to_change_properties
  void setBestiaryData(List<int> bytes) => bestiaryData = bytes;
  // ignore: use_setters_to_change_properties
  void setPartyData(List<int> bytes) => partyData = bytes;
  // ignore: use_setters_to_change_properties
  void setGeneralGameData(List<int> bytes) => generalGameData = bytes;
  // ignore: use_setters_to_change_properties
  void setEventFlagData(List<int> bytes) => eventFlagData = bytes;
  // ignore: use_setters_to_change_properties
  void setMainInventoryFlagData(List<int> bytes) =>
    mainInventoryFlagData = bytes;
  // ignore: use_setters_to_change_properties
  void setSubInventoryFlagData(List<int> bytes) =>
    subInventoryFlagData = bytes;
  // ignore: use_setters_to_change_properties
  void setMaterialInventoryFlagData(List<int> bytes) =>
  materialInventoryFlagData = bytes;
  // ignore: use_setters_to_change_properties
  void setSpecialInventoryFlagData(List<int> bytes) =>
  specialInventoryFlagData = bytes;
  // ignore: use_setters_to_change_properties
  void setMainInventoryData(List<int> bytes) => mainInventoryData = bytes;
  // ignore: use_setters_to_change_properties
  void setSubInventoryData(List<int> bytes) => subInventoryData = bytes;
  // ignore: use_setters_to_change_properties
  void setMaterialInventoryData(List<int> bytes) =>
  materialInventoryData = bytes;
  // ignore: use_setters_to_change_properties
  void setSpecialInventoryData(List<int> bytes) =>
  specialInventoryData = bytes;
  // ignore: use_setters_to_change_properties
  void setCharacterData(List<int> bytes) => characterData = bytes;
  // ignore: use_setters_to_change_properties
  void setMainMapData(List<int> bytes) => mainMapData = bytes;
  // ignore: use_setters_to_change_properties
  void setUndergroundMapData(List<int> bytes) => undergroundMapData = bytes;
}
