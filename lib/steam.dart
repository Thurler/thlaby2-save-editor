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

  SteamSaveFile.fromBytes(List<int> bytes) {
    if (bytes.length != fileSize) {
      throw const FileSizeException();
    }
    List<int> decrypted = bytes.asMap().map(
      (int index, int value) => MapEntry<int, int>(
        index,
        (index & 0xff) ^ value,
      ),
    ).values.toList();
    if (
      decrypted[0] != 0x42 || decrypted[1] != 0x4c ||
      decrypted[2] != 0x48 || decrypted[3] != 0x54 ||
      decrypted[0x67] != 0x01
    ) {
      throw const InvalidHeaderException();
    }
    setCharacterUnlockFlagsFromBytes(bytes.sublist(0x5, 0x3d));
    setAchievementData(bytes.sublist(0x68, 0xd0));
    setAchievementDataPlus(bytes.sublist(0xd6, 0x10a));
    setAchievementNotificationData(bytes.sublist(0x130, 0x198));
    setAchievementNotificationDataPlus(bytes.sublist(0x19e, 0x1d2));
    setBestiaryData(bytes.sublist(0x2c2, 0x4c22));
    setPartyData(bytes.sublist(0x5018, 0x5024));
    setGeneralGameData(bytes.sublist(0x540c, 0x54c6));
    setEventFlagData(bytes.sublist(0x54c6, 0x68b2));
    setMainInventoryFlagData(bytes.sublist(0x7bd7, 0x7c13));
    setSubInventoryFlagData(bytes.sublist(0x7c9f, 0x7d8f));
    setMaterialInventoryFlagData(bytes.sublist(0x7dcb, 0x7e2f));
    setSpecialInventoryFlagData(bytes.sublist(0x7ef7, 0x7fab));
    setMainInventoryData(bytes.sublist(0x83a8, 0x8420));
    setSubInventoryData(bytes.sublist(0x8538, 0x8718));
    setMaterialInventoryData(bytes.sublist(0x8790, 0x8858));
    setSpecialInventoryData(bytes.sublist(0x89e8, 0x8b50));
    setCharacterData(bytes.sublist(0x9346, 0xce8e));
    setMainMapData(bytes.sublist(0xce8e, 0x2ae8e));
    setUndergroundMapData(bytes.sublist(0x33e8e, 0x3ee8e));
  }
}
