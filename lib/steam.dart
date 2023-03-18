import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/save.dart';

class FileSizeException implements Exception {
  const FileSizeException() : super();
}

class InvalidHeaderException implements Exception {
  const InvalidHeaderException() : super();
}

class SteamSaveFile extends SaveFile {
  static const int fileSize = 257678;
  final Logger logger = Logger();

  List<int> _runEncoding(List<int> bytes) {
    return bytes.asMap().map(
      (int index, int value) => MapEntry<int, int>(
        index,
        (index & 0xff) ^ value,
      ),
    ).values.toList();
  }

  SteamSaveFile.fromBytes(List<int> bytes) {
    if (bytes.length != fileSize) {
      throw const FileSizeException();
    }
    List<int> decrypted = _runEncoding(bytes);
    if (
      decrypted[0] != 0x42 || decrypted[1] != 0x4c ||
      decrypted[2] != 0x48 || decrypted[3] != 0x54 ||
      decrypted[0x67] != 0x01
    ) {
      throw const InvalidHeaderException();
    }
    setCharacterUnlockFlagsFromBytes(decrypted.sublist(0x5, 0x3d));
    setAchievementData(decrypted.sublist(0x68, 0xd0));
    setAchievementDataPlus(decrypted.sublist(0xd6, 0x10a));
    setAchievementNotificationData(decrypted.sublist(0x130, 0x198));
    setAchievementNotificationDataPlus(decrypted.sublist(0x19e, 0x1d2));
    setBestiaryData(decrypted.sublist(0x2c2, 0x4c22));
    setPartyData(decrypted.sublist(0x5018, 0x5024));
    setGeneralGameData(decrypted.sublist(0x540c, 0x54c6));
    setEventFlagData(decrypted.sublist(0x54c6, 0x68b2));
    setMainInventoryFlagData(decrypted.sublist(0x7bd7, 0x7c13));
    setSubInventoryFlagData(decrypted.sublist(0x7c9f, 0x7d8f));
    setMaterialInventoryFlagData(decrypted.sublist(0x7dcb, 0x7e2f));
    setSpecialInventoryFlagData(decrypted.sublist(0x7ef7, 0x7fab));
    setMainInventoryData(decrypted.sublist(0x83a8, 0x8420));
    setSubInventoryData(decrypted.sublist(0x8538, 0x8718));
    setMaterialInventoryData(decrypted.sublist(0x8790, 0x8858));
    setSpecialInventoryData(decrypted.sublist(0x89e8, 0x8b50));
    setCharacterData(decrypted.sublist(0x9346, 0xce8e));
    setMainMapData(decrypted.sublist(0xce8e, 0x2ae8e));
    setUndergroundMapData(decrypted.sublist(0x33e8e, 0x3ee8e));
  }

  @override
  List<int> export() {
    List<int> bytes = List<int>.filled(fileSize, 0, growable: true);
    bytes[0x67] = 0x1;
    bytes.replaceRange(0x0, 0x4, <int>[0x42, 0x4c, 0x48, 0x54]);
    bytes.replaceRange(0x5, 0x3d, getCharacterUnlockFlags());
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
    return _runEncoding(bytes);
  }
}
