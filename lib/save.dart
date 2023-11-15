import 'dart:typed_data';
import 'package:thlaby2_save_editor/logger.dart';
import 'package:thlaby2_save_editor/save/character.dart';
import 'package:thlaby2_save_editor/save/character_unlock.dart';
import 'package:thlaby2_save_editor/save/enums/character.dart';
import 'package:thlaby2_save_editor/save/enums/item.dart';
import 'package:thlaby2_save_editor/save/item_slot.dart';
import 'package:thlaby2_save_editor/save/party_slot.dart';

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

class SaveFile with Loggable {
  static const int steamFileSize = 257678;
  static const int characterDataLength = 271;

  late List<CharacterUnlockFlag> characterUnlockFlags;
  List<int> achievementData = <int>[];
  List<int> achievementDataPlus = <int>[];
  List<int> achievementNotificationsData = <int>[];
  List<int> achievementNotificationsDataPlus = <int>[];
  List<int> bestiaryData = <int>[];
  late List<PartySlot> partyData;
  List<int> generalGameData = <int>[];
  List<int> eventFlagData = <int>[];
  late List<ItemSlot> mainInventoryData;
  late List<ItemSlot> subInventoryData;
  late List<ItemSlot> materialInventoryData;
  late List<ItemSlot> specialInventoryData;
  late List<CharacterData> characterData;
  List<int> mainMapData = <int>[];
  List<int> undergroundMapData = <int>[];

  bool loadedWithErrors = false;

  SaveFile.fromSteamBytes(List<int> bytes) {
    if (bytes.length != steamFileSize) {
      throw const FileSizeException();
    }
    List<int> decrypted = _runSteamEncoding(bytes);
    if (
      decrypted[0] != 0x42 ||
      decrypted[1] != 0x4c ||
      decrypted[2] != 0x48 ||
      decrypted[3] != 0x54 ||
      decrypted[0x67] != 0x01
    ) {
      throw const InvalidHeaderException();
    }
    _setCharacterUnlockFlagsFromBytes(decrypted.sublist(0x5, 0x3d));
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

  List<int> exportSteam() {
    List<int> bytes = List<int>.filled(steamFileSize, 0, growable: true);
    bytes[0x67] = 0x1;
    bytes.replaceRange(0x0, 0x4, <int>[0x42, 0x4c, 0x48, 0x54]);
    bytes.replaceRange(0x5, 0x3d, _exportCharacterUnlockFlags());
    bytes.replaceRange(0x68, 0xd0, achievementData);
    bytes.replaceRange(0xd6, 0x10a, achievementDataPlus);
    bytes.replaceRange(0x130, 0x198, achievementNotificationsData);
    bytes.replaceRange(0x19e, 0x1d2, achievementNotificationsDataPlus);
    bytes.replaceRange(0x2c2, 0x4c22, bestiaryData);
    bytes.replaceRange(0x5018, 0x5024, _exportPartyData());
    bytes.replaceRange(0x540c, 0x54c6, generalGameData);
    bytes.replaceRange(0x54c6, 0x68b2, eventFlagData);
    bytes.replaceRange(0x7bd7, 0x7c13, _exportMainInventoryFlagData());
    bytes.replaceRange(0x7c9f, 0x7d8f, _exportSubInventoryFlagData());
    bytes.replaceRange(0x7dcb, 0x7e2f, _exportMaterialFlagData());
    bytes.replaceRange(0x7ef7, 0x7fab, _exportSpecialItemFlagData());
    bytes.replaceRange(0x83a8, 0x8420, _exportMainInventoryAmountData());
    bytes.replaceRange(0x8538, 0x8718, _exportSubInventoryAmountData());
    bytes.replaceRange(0x8790, 0x8858, _exportMaterialInventoryAmountData());
    bytes.replaceRange(0x89e8, 0x8b50, _exportSpecialInventoryAmountData());
    bytes.replaceRange(0x9346, 0xce8e, _exportCharacterData());
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

  Iterable<int> _exportCharacterUnlockFlags() {
    logBuffer(LogLevel.debug, 'Character unlock: $characterUnlockFlags');
    return characterUnlockFlags.map<int>(
      (CharacterUnlockFlag flag) => (flag.isUnlocked) ? 0x1 : 0x0,
    );
  }

  Iterable<int> _exportPartyData() {
    logBuffer(LogLevel.debug, 'Party data: $partyData');
    return partyData.map<int>((PartySlot slot) => slot.toByte());
  }

  Iterable<int> _exportMainInventoryFlagData() {
    logBuffer(LogLevel.debug, 'Inventory data: $mainInventoryData');
    return mainInventoryData.map((ItemSlot slot) => slot.toUnlockByte());
  }

  Iterable<int> _exportSubInventoryFlagData() {
    logBuffer(LogLevel.debug, 'Inventory data: $subInventoryData');
    return subInventoryData.map((ItemSlot slot) => slot.toUnlockByte());
  }

  Iterable<int> _exportMaterialFlagData() {
    logBuffer(LogLevel.debug, 'Inventory data: $materialInventoryData');
    return materialInventoryData.map((ItemSlot slot) => slot.toUnlockByte());
  }

  Iterable<int> _exportSpecialItemFlagData() {
    logBuffer(LogLevel.debug, 'Inventory data: $specialInventoryData');
    return specialInventoryData.map((ItemSlot slot) => slot.toUnlockByte());
  }

  Iterable<int> _exportMainInventoryAmountData() {
    return mainInventoryData.fold(
      <int>[],
      (Iterable<int> acc, ItemSlot slot) => acc.followedBy(
        slot.toAmountBytes(Endian.little),
      ),
    );
  }

  Iterable<int> _exportSubInventoryAmountData() {
    return subInventoryData.fold(
      <int>[],
      (Iterable<int> acc, ItemSlot slot) => acc.followedBy(
        slot.toAmountBytes(Endian.little),
      ),
    );
  }

  Iterable<int> _exportMaterialInventoryAmountData() {
    return materialInventoryData.fold(
      <int>[],
      (Iterable<int> acc, ItemSlot slot) => acc.followedBy(
        slot.toAmountBytes(Endian.little),
      ),
    );
  }

  Iterable<int> _exportSpecialInventoryAmountData() {
    return specialInventoryData.fold(
      <int>[],
      (Iterable<int> acc, ItemSlot slot) => acc.followedBy(
        slot.toAmountBytes(Endian.little),
      ),
    );
  }

  Iterable<int> _exportCharacterData() {
    logBuffer(LogLevel.debug, 'Party data: $characterData');
    return characterData.fold<Iterable<int>>(
      <int>[],
      (Iterable<int> acc, CharacterData data) => acc.followedBy(
        data.toBytes(Endian.little),
      ),
    );
  }

  void _setCharacterUnlockFlagsFromBytes(List<int> bytes) {
    characterUnlockFlags = <CharacterUnlockFlag>[];
    logBuffer(LogLevel.debug, 'Character unlock bytes: $bytes');
    for (int i = 0; i < bytes.length; i++) {
      characterUnlockFlags.add(
        CharacterUnlockFlag(
          character: Character.values.elementAt(i),
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

  void _setPartyData(List<int> bytes) {
    partyData = <PartySlot>[];
    logBuffer(LogLevel.debug, 'Party bytes: $bytes');
    for (int i = 0; i < bytes.length; i++) {
      int byte = bytes[i];
      if (byte == 0) {
        partyData.add(PartySlot.empty());
      } else if (byte <= 56) {
        partyData.add(PartySlot.filled(byte));
      } else {
        logBuffer(LogLevel.error, 'Invalid party member at position $i: $byte');
        loadedWithErrors = true;
      }
    }
  }

  // ignore: use_setters_to_change_properties
  void _setGeneralGameData(List<int> bytes) => generalGameData = bytes;
  // ignore: use_setters_to_change_properties
  void _setEventFlagData(List<int> bytes) => eventFlagData = bytes;

  void _setMainInventoryFlagData(List<int> bytes) {
    logBuffer(LogLevel.debug, 'Main Equip unlock flag bytes: $bytes');
    mainInventoryData = <ItemSlot>[];
    for (MainEquip item in MainEquip.values) {
      // Ignore the empty slot
      if (item != MainEquip.slot0) {
        mainInventoryData.add(
          ItemSlot(item, isUnlocked: bytes[item.index - 1] > 0),
        );
      }
    }
  }

  void _setSubInventoryFlagData(List<int> bytes) {
    logBuffer(LogLevel.debug, 'Sub Equip unlock flag bytes: $bytes');
    subInventoryData = <ItemSlot>[];
    for (SubEquip item in SubEquip.values) {
      // Ignore the empty slot
      if (item != SubEquip.slot0) {
        subInventoryData.add(
          ItemSlot(item, isUnlocked: bytes[item.index - 1] > 0),
        );
      }
    }
  }

  void _setMaterialInventoryFlagData(List<int> bytes) {
    logBuffer(LogLevel.debug, 'Material unlock flag bytes: $bytes');
    materialInventoryData = <ItemSlot>[];
    for (Material item in Material.values) {
      materialInventoryData.add(
        ItemSlot(item, isUnlocked: bytes[item.index] > 0),
      );
    }
  }

  void _setSpecialInventoryFlagData(List<int> bytes) {
    logBuffer(LogLevel.debug, 'Special item unlock flag bytes: $bytes');
    specialInventoryData = <ItemSlot>[];
    for (SpecialItem item in SpecialItem.values) {
      specialInventoryData.add(
        ItemSlot(item, isUnlocked: bytes[item.index] > 0),
      );
    }
  }

  void _setMainInventoryData(List<int> bytes) {
    logBuffer(LogLevel.debug, 'Main Equip amount bytes: $bytes');
    for (int i = 0; i < MainEquip.values.length - 1; i++) {
      mainInventoryData[i].amountFromBytes(
        bytes: bytes,
        offset: i * 2,
        endianness: Endian.little,
      );
    }
  }

  void _setSubInventoryData(List<int> bytes) {
    logBuffer(LogLevel.debug, 'Sub Equip amount bytes: $bytes');
    for (int i = 0; i < SubEquip.values.length - 1; i++) {
      subInventoryData[i].amountFromBytes(
        bytes: bytes,
        offset: i * 2,
        endianness: Endian.little,
      );
    }
  }

  void _setMaterialInventoryData(List<int> bytes) {
    logBuffer(LogLevel.debug, 'Material amount bytes: $bytes');
    for (int i = 0; i < Material.values.length; i++) {
      materialInventoryData[i].amountFromBytes(
        bytes: bytes,
        offset: i * 2,
        endianness: Endian.little,
      );
    }
  }

  void _setSpecialInventoryData(List<int> bytes) {
    logBuffer(LogLevel.debug, 'Special item amount bytes: $bytes');
    for (int i = 0; i < SpecialItem.values.length; i++) {
      specialInventoryData[i].amountFromBytes(
        bytes: bytes,
        offset: i * 2,
        endianness: Endian.little,
      );
    }
  }

  void _setCharacterData(List<int> bytes) {
    characterData = <CharacterData>[];
    for (int i = 0; i < 56; i++) {
      int start = i * characterDataLength;
      int end = (i + 1) * characterDataLength;
      List<int> characterBytes = bytes.sublist(start, end);
      logBuffer(LogLevel.debug, 'Character $i bytes: $characterBytes');
      characterData.add(
        CharacterData.fromBytes(
          index: i,
          bytes: characterBytes,
          endianness: Endian.little,
        ),
      );
    }
  }

  // ignore: use_setters_to_change_properties
  void _setMainMapData(List<int> bytes) => mainMapData = bytes;
  // ignore: use_setters_to_change_properties
  void _setUndergroundMapData(List<int> bytes) => undergroundMapData = bytes;
}

mixin SaveReader {
  final SaveFileWrapper _saveFileWrapper = SaveFileWrapper();

  SaveFile get saveFile => _saveFileWrapper.saveFile;
}

mixin SaveWriter on SaveReader {
  set saveFile(SaveFile file) => _saveFileWrapper.saveFile = file;
}
