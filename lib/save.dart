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

class FileSizeException implements Exception {
  const FileSizeException() : super();
}

class InvalidHeaderException implements Exception {
  const InvalidHeaderException() : super();
}

class SaveFileWrapper {
  static final SaveFileWrapper _saveFileWrapper = SaveFileWrapper._internal();

  late SaveFile saveFile;

  factory SaveFileWrapper() {
    return _saveFileWrapper;
  }

  SaveFileWrapper._internal();
}

class SaveFile {
  static const int steamFileSize = 257678;

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

  SaveFile.fromSteamBytes(List<int> bytes, StringBuffer logBuffer) {
    if (bytes.length != steamFileSize) {
      throw const FileSizeException();
    }
    List<int> decrypted = _runSteamEncoding(bytes);
    if (
      decrypted[0] != 0x42 || decrypted[1] != 0x4c ||
      decrypted[2] != 0x48 || decrypted[3] != 0x54 ||
      decrypted[0x67] != 0x01
    ) {
      throw const InvalidHeaderException();
    }
    _setCharacterUnlockFlagsFromBytes(decrypted.sublist(0x5, 0x3d), logBuffer);
    _setAchievementData(decrypted.sublist(0x68, 0xd0));
    _setAchievementDataPlus(decrypted.sublist(0xd6, 0x10a));
    _setAchievementNotificationData(decrypted.sublist(0x130, 0x198));
    _setAchievementNotificationDataPlus(decrypted.sublist(0x19e, 0x1d2));
    _setBestiaryData(decrypted.sublist(0x2c2, 0x4c22));
    _setPartyData(decrypted.sublist(0x5018, 0x5024));
    _setGeneralGameData(decrypted.sublist(0x540c, 0x54c6));
    _setEventFlagData(decrypted.sublist(0x54c6, 0x68b2));
    _setMainInventoryFlagData(decrypted.sublist(0x7bd7, 0x7c13));
    _setSubInventoryFlagData(decrypted.sublist(0x7c9f, 0x7d8f));
    _setMaterialInventoryFlagData(decrypted.sublist(0x7dcb, 0x7e2f));
    _setSpecialInventoryFlagData(decrypted.sublist(0x7ef7, 0x7fab));
    _setMainInventoryData(decrypted.sublist(0x83a8, 0x8420));
    _setSubInventoryData(decrypted.sublist(0x8538, 0x8718));
    _setMaterialInventoryData(decrypted.sublist(0x8790, 0x8858));
    _setSpecialInventoryData(decrypted.sublist(0x89e8, 0x8b50));
    _setCharacterData(decrypted.sublist(0x9346, 0xce8e));
    _setMainMapData(decrypted.sublist(0xce8e, 0x2ae8e));
    _setUndergroundMapData(decrypted.sublist(0x33e8e, 0x3ee8e));
  }

  List<int> exportSteam(StringBuffer logBuffer) {
    List<int> bytes = List<int>.filled(steamFileSize, 0, growable: true);
    bytes[0x67] = 0x1;
    bytes.replaceRange(0x0, 0x4, <int>[0x42, 0x4c, 0x48, 0x54]);
    bytes.replaceRange(0x5, 0x3d, _exportCharacterUnlockFlags(logBuffer));
    bytes.replaceRange(0x68, 0xd0, achievementData);
    bytes.replaceRange(0xd6, 0x10a, achievementDataPlus);
    bytes.replaceRange(0x130, 0x198, achievementNotificationsData);
    bytes.replaceRange(0x19e, 0x1d2, achievementNotificationsDataPlus);
    bytes.replaceRange(0x2c2, 0x4c22, bestiaryData);
    bytes.replaceRange(0x5018, 0x5024, partyData);
    bytes.replaceRange(0x540c, 0x54c6, generalGameData);
    bytes.replaceRange(0x54c6, 0x68b2, eventFlagData);
    bytes.replaceRange(0x7bd7, 0x7c13, mainInventoryFlagData);
    bytes.replaceRange(0x7c9f, 0x7d8f, subInventoryFlagData);
    bytes.replaceRange(0x7dcb, 0x7e2f, materialInventoryFlagData);
    bytes.replaceRange(0x7ef7, 0x7fab, specialInventoryFlagData);
    bytes.replaceRange(0x83a8, 0x8420, mainInventoryData);
    bytes.replaceRange(0x8538, 0x8718, subInventoryData);
    bytes.replaceRange(0x8790, 0x8858, materialInventoryData);
    bytes.replaceRange(0x89e8, 0x8b50, specialInventoryData);
    bytes.replaceRange(0x9346, 0xce8e, characterData);
    bytes.replaceRange(0xce8e, 0x2ae8e, mainMapData);
    bytes.replaceRange(0x33e8e, 0x3ee8e, undergroundMapData);
    return _runSteamEncoding(bytes);
  }

  List<int> _runSteamEncoding(List<int> bytes) {
    return bytes.asMap().map(
      (int index, int value) => MapEntry<int, int>(
        index,
        (index & 0xff) ^ value,
      ),
    ).values.toList();
  }

  Iterable<int> _exportCharacterUnlockFlags(StringBuffer logBuffer) {
    logBuffer.writeln('Character unlock: $characterUnlockFlags');
    return characterUnlockFlags.map<int>(
      (CharacterUnlockFlag flag) => (flag.isUnlocked) ? 0x1 : 0x0,
    );
  }

  void _setCharacterUnlockFlagsFromBytes(
    List<int> bytes,
    StringBuffer logBuffer,
  ) {
    characterUnlockFlags = <CharacterUnlockFlag>[];
    logBuffer.writeln('Character unlock bytes: $bytes');
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
  void _setAchievementData(List<int> bytes) => achievementData = bytes;
  // ignore: use_setters_to_change_properties
  void _setAchievementDataPlus(List<int> bytes) => achievementDataPlus = bytes;
  // ignore: use_setters_to_change_properties
  void _setAchievementNotificationData(List<int> bytes) =>
    achievementNotificationsData = bytes;
  // ignore: use_setters_to_change_properties
  void _setAchievementNotificationDataPlus(List<int> bytes) =>
    achievementNotificationsDataPlus = bytes;
  // ignore: use_setters_to_change_properties
  void _setBestiaryData(List<int> bytes) => bestiaryData = bytes;
  // ignore: use_setters_to_change_properties
  void _setPartyData(List<int> bytes) => partyData = bytes;
  // ignore: use_setters_to_change_properties
  void _setGeneralGameData(List<int> bytes) => generalGameData = bytes;
  // ignore: use_setters_to_change_properties
  void _setEventFlagData(List<int> bytes) => eventFlagData = bytes;
  // ignore: use_setters_to_change_properties
  void _setMainInventoryFlagData(List<int> bytes) =>
    mainInventoryFlagData = bytes;
  // ignore: use_setters_to_change_properties
  void _setSubInventoryFlagData(List<int> bytes) =>
    subInventoryFlagData = bytes;
  // ignore: use_setters_to_change_properties
  void _setMaterialInventoryFlagData(List<int> bytes) =>
  materialInventoryFlagData = bytes;
  // ignore: use_setters_to_change_properties
  void _setSpecialInventoryFlagData(List<int> bytes) =>
  specialInventoryFlagData = bytes;
  // ignore: use_setters_to_change_properties
  void _setMainInventoryData(List<int> bytes) => mainInventoryData = bytes;
  // ignore: use_setters_to_change_properties
  void _setSubInventoryData(List<int> bytes) => subInventoryData = bytes;
  // ignore: use_setters_to_change_properties
  void _setMaterialInventoryData(List<int> bytes) =>
  materialInventoryData = bytes;
  // ignore: use_setters_to_change_properties
  void _setSpecialInventoryData(List<int> bytes) =>
  specialInventoryData = bytes;
  // ignore: use_setters_to_change_properties
  void _setCharacterData(List<int> bytes) => characterData = bytes;
  // ignore: use_setters_to_change_properties
  void _setMainMapData(List<int> bytes) => mainMapData = bytes;
  // ignore: use_setters_to_change_properties
  void _setUndergroundMapData(List<int> bytes) => undergroundMapData = bytes;
}
