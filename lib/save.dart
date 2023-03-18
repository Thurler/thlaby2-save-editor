abstract class SaveFile {
  List<bool> _characterUnlockFlags = List<bool>.filled(56, false);
  List<int> _achievementData = <int>[];
  List<int> _achievementDataPlus = <int>[];
  List<int> _achievementNotificationsData = <int>[];
  List<int> _achievementNotificationsDataPlus = <int>[];
  List<int> _bestiaryData = <int>[];
  List<int> _partyData = <int>[];
  List<int> _generalGameData = <int>[];
  List<int> _eventFlagData = <int>[];
  List<int> _mainInventoryFlagData = <int>[];
  List<int> _subInventoryFlagData = <int>[];
  List<int> _materialInventoryFlagData = <int>[];
  List<int> _specialInventoryFlagData = <int>[];
  List<int> _mainInventoryData = <int>[];
  List<int> _subInventoryData = <int>[];
  List<int> _materialInventoryData = <int>[];
  List<int> _specialInventoryData = <int>[];
  List<int> _characterData = <int>[];
  List<int> _mainMapData = <int>[];
  List<int> _undergroundMapData = <int>[];

  void setCharacterUnlockFlagsFromBytes(List<int> bytes) {
    _characterUnlockFlags = bytes.map((int byte)=>byte>0x0).toList();
  }

  // ignore: use_setters_to_change_properties
  void setAchievementData(List<int> bytes) => _achievementData = bytes;
  // ignore: use_setters_to_change_properties
  void setAchievementDataPlus(List<int> bytes) => _achievementDataPlus = bytes;
  // ignore: use_setters_to_change_properties
  void setAchievementNotificationData(List<int> bytes) =>
    _achievementNotificationsData = bytes;
  // ignore: use_setters_to_change_properties
  void setAchievementNotificationDataPlus(List<int> bytes) =>
    _achievementNotificationsDataPlus = bytes;
  // ignore: use_setters_to_change_properties
  void setBestiaryData(List<int> bytes) => _bestiaryData = bytes;
  // ignore: use_setters_to_change_properties
  void setPartyData(List<int> bytes) => _partyData = bytes;
  // ignore: use_setters_to_change_properties
  void setGeneralGameData(List<int> bytes) => _generalGameData = bytes;
  // ignore: use_setters_to_change_properties
  void setEventFlagData(List<int> bytes) => _eventFlagData = bytes;
  // ignore: use_setters_to_change_properties
  void setMainInventoryFlagData(List<int> bytes) =>
    _mainInventoryFlagData = bytes;
  // ignore: use_setters_to_change_properties
  void setSubInventoryFlagData(List<int> bytes) =>
    _subInventoryFlagData = bytes;
  // ignore: use_setters_to_change_properties
  void setMaterialInventoryFlagData(List<int> bytes) =>
  _materialInventoryFlagData = bytes;
  // ignore: use_setters_to_change_properties
  void setSpecialInventoryFlagData(List<int> bytes) =>
  _specialInventoryFlagData = bytes;
  // ignore: use_setters_to_change_properties
  void setMainInventoryData(List<int> bytes) => _mainInventoryData = bytes;
  // ignore: use_setters_to_change_properties
  void setSubInventoryData(List<int> bytes) => _subInventoryData = bytes;
  // ignore: use_setters_to_change_properties
  void setMaterialInventoryData(List<int> bytes) =>
  _materialInventoryData = bytes;
  // ignore: use_setters_to_change_properties
  void setSpecialInventoryData(List<int> bytes) =>
  _specialInventoryData = bytes;
  // ignore: use_setters_to_change_properties
  void setCharacterData(List<int> bytes) => _characterData = bytes;
  // ignore: use_setters_to_change_properties
  void setMainMapData(List<int> bytes) => _mainMapData = bytes;
  // ignore: use_setters_to_change_properties
  void setUndergroundMapData(List<int> bytes) => _undergroundMapData = bytes;
}
