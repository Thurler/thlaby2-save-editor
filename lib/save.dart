import 'dart:typed_data';
import 'package:thlaby2_save_editor/int_extension.dart';
import 'package:thlaby2_save_editor/list_extension.dart';

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

enum Subclass {
  none,
  guardian,
  monk,
  warrior,
  sorcerer,
  healer,
  enhancer,
  hexer,
  toxicologist,
  magician,
  herbalist,
  strategist,
  gambler,
  diva,
  transcendent,
  swordmaster,
  archmage,
  appraiser,
  elementalist,
  ninja,
  oracle,
  holyblessing,
  dragongodpower,
  winner,
}

class LibraryData {
  late int hp;
  late int atk;
  late int def;
  late int mag;
  late int mnd;
  late int spd;
  late int fir;
  late int cld;
  late int wnd;
  late int ntr;
  late int mys;
  late int spi;
  late int drk;
  late int phy;

  LibraryData.fromBytes(Endian endianness, List<int> bytes, int offset) {
    hp = bytes.getU32(endianness, offset: offset);
    atk = bytes.getU32(endianness, offset: offset + 4);
    def = bytes.getU32(endianness, offset: offset + 8);
    mag = bytes.getU32(endianness, offset: offset + 12);
    mnd = bytes.getU32(endianness, offset: offset + 16);
    spd = bytes.getU32(endianness, offset: offset + 20);
    fir = bytes.getU32(endianness, offset: offset + 24);
    cld = bytes.getU32(endianness, offset: offset + 28);
    wnd = bytes.getU32(endianness, offset: offset + 32);
    ntr = bytes.getU32(endianness, offset: offset + 36);
    mys = bytes.getU32(endianness, offset: offset + 40);
    spi = bytes.getU32(endianness, offset: offset + 44);
    drk = bytes.getU32(endianness, offset: offset + 48);
    phy = bytes.getU32(endianness, offset: offset + 52);
  }

  LibraryData.from(LibraryData other) {
    hp = other.hp;
    atk = other.atk;
    def = other.def;
    mag = other.mag;
    mnd = other.mnd;
    spd = other.spd;
    fir = other.fir;
    cld = other.cld;
    wnd = other.wnd;
    ntr = other.ntr;
    mys = other.mys;
    spi = other.spi;
    drk = other.drk;
    phy = other.phy;
  }

  Iterable<int> toBytes(Endian endianness) {
    return <int>[
      ...hp.toU32(endianness),
      ...atk.toU32(endianness),
      ...def.toU32(endianness),
      ...mag.toU32(endianness),
      ...mnd.toU32(endianness),
      ...spd.toU32(endianness),
      ...fir.toU32(endianness),
      ...cld.toU32(endianness),
      ...wnd.toU32(endianness),
      ...ntr.toU32(endianness),
      ...mys.toU32(endianness),
      ...spi.toU32(endianness),
      ...drk.toU32(endianness),
      ...phy.toU32(endianness),
    ];
  }
}

class LevelBonus {
  late int hp;
  late int atk;
  late int def;
  late int mag;
  late int mnd;
  late int spd;

  LevelBonus.fromBytes(Endian endianness, List<int> bytes, int offset) {
    hp = bytes.getU32(endianness, offset: offset);
    atk = bytes.getU32(endianness, offset: offset + 4);
    def = bytes.getU32(endianness, offset: offset + 8);
    mag = bytes.getU32(endianness, offset: offset + 12);
    mnd = bytes.getU32(endianness, offset: offset + 16);
    spd = bytes.getU32(endianness, offset: offset + 20);
  }

  LevelBonus.from(LevelBonus other) {
    hp = other.hp;
    atk = other.atk;
    def = other.def;
    mag = other.mag;
    mnd = other.mnd;
    spd = other.spd;
  }

  Iterable<int> toBytes(Endian endianness) {
    return <int>[
      ...hp.toU32(endianness),
      ...atk.toU32(endianness),
      ...def.toU32(endianness),
      ...mag.toU32(endianness),
      ...mnd.toU32(endianness),
      ...spd.toU32(endianness),
    ];
  }
}

class SkillData {
  late int hpBoost;
  late int mpBoost;
  late int tpBoost;
  late int atkBoost;
  late int defBoost;
  late int magBoost;
  late int mndBoost;
  late int spdBoost;
  late int evaBoost;
  late int accBoost;
  late int affBoost;
  late int resBoost;
  late int motivatedHeart;
  late int handsOnExperience;
  late List<int> personalSkills;
  late List<int> personalSpells;
  late List<int> subclassSkills;
  late List<int> subclassSpells;

  SkillData.fromBytes(List<int> bytes, int offset) {
    hpBoost = bytes[offset];
    mpBoost = bytes[offset + 2];
    tpBoost = bytes[offset + 4];
    atkBoost = bytes[offset + 6];
    defBoost = bytes[offset + 8];
    magBoost = bytes[offset + 10];
    mndBoost = bytes[offset + 12];
    spdBoost = bytes[offset + 14];
    evaBoost = bytes[offset + 16];
    accBoost = bytes[offset + 18];
    affBoost = bytes[offset + 20];
    resBoost = bytes[offset + 22];
    motivatedHeart = bytes[offset + 36];
    handsOnExperience = bytes[offset + 38];
    personalSkills = List<int>.filled(10, 0);
    personalSpells = List<int>.filled(10, 0);
    subclassSkills = List<int>.filled(10, 0);
    subclassSpells = List<int>.filled(10, 0);
    for (int i = 0; i < 10; i++) {
      personalSkills[i] = bytes[offset + 40 + (i * 2)];
      personalSpells[i] = bytes[offset + 60 + (i * 2)];
      subclassSkills[i] = bytes[offset + 80 + (i * 2)];
      subclassSpells[i] = bytes[offset + 100 + (i * 2)];
    }
  }

  SkillData.from(SkillData other) {
    hpBoost = other.hpBoost;
    mpBoost = other.mpBoost;
    tpBoost = other.tpBoost;
    atkBoost = other.atkBoost;
    defBoost = other.defBoost;
    magBoost = other.magBoost;
    mndBoost = other.mndBoost;
    spdBoost = other.spdBoost;
    evaBoost = other.evaBoost;
    accBoost = other.accBoost;
    affBoost = other.affBoost;
    resBoost = other.resBoost;
    motivatedHeart = other.motivatedHeart;
    handsOnExperience = other.handsOnExperience;
    personalSkills = List<int>.from(other.personalSkills);
    personalSpells = List<int>.from(other.personalSpells);
    subclassSkills = List<int>.from(other.subclassSkills);
    subclassSpells = List<int>.from(other.subclassSpells);
  }

  Iterable<int> _skillListToBytes(List<int> skills, Endian endianness) {
    return skills.fold<Iterable<int>>(
      <int>[],
      (Iterable<int> acc, int skill) => acc.followedBy(skill.toU16(endianness)),
    );
  }

  Iterable<int> toBytes(Endian endianness) {
    return <int>[
      ...hpBoost.toU16(endianness),
      ...mpBoost.toU16(endianness),
      ...tpBoost.toU16(endianness),
      ...atkBoost.toU16(endianness),
      ...defBoost.toU16(endianness),
      ...magBoost.toU16(endianness),
      ...mndBoost.toU16(endianness),
      ...spdBoost.toU16(endianness),
      ...evaBoost.toU16(endianness),
      ...accBoost.toU16(endianness),
      ...affBoost.toU16(endianness),
      ...resBoost.toU16(endianness),
      ...List<int>.filled(2 * 6, 0), // 6 empty slots
      ...motivatedHeart.toU16(endianness),
      ...handsOnExperience.toU16(endianness),
      ..._skillListToBytes(personalSkills, endianness),
      ..._skillListToBytes(personalSpells, endianness),
      ..._skillListToBytes(subclassSkills, endianness),
      ..._skillListToBytes(subclassSpells, endianness),
    ];
  }
}

enum TomeLevel {
  unused(0, 0),
  insight(1, 0),
  spartanNatural(0, 2),
  spartan(1, 2),
  veteranNatural(0, 3),
  veteran(1, 3);

  final int flag;
  final int level;

  const TomeLevel(this.flag, this.level);
}

class TomeData {
  late TomeLevel hp;
  late TomeLevel mp;
  late TomeLevel tp;
  late TomeLevel atk;
  late TomeLevel def;
  late TomeLevel mag;
  late TomeLevel mnd;
  late TomeLevel spd;
  late TomeLevel eva;
  late TomeLevel acc;
  late TomeLevel aff;
  late TomeLevel res;

  TomeLevel _levelFromBytes(int flag, int level) {
    bool flagSet = flag > 0;
    if (level == 0) {
      return flagSet ? TomeLevel.insight : TomeLevel.unused;
    } else if (level == 2) {
      return flagSet ? TomeLevel.spartan : TomeLevel.spartanNatural;
    } else {
      return flagSet ? TomeLevel.veteran : TomeLevel.veteranNatural;
    }
  }

  TomeData.fromBytes(List<int> bytes, int offset) {
    hp = _levelFromBytes(bytes[offset], bytes[offset + 12]);
    mp = _levelFromBytes(bytes[offset + 1], bytes[offset + 13]);
    tp = _levelFromBytes(bytes[offset + 2], bytes[offset + 14]);
    atk = _levelFromBytes(bytes[offset + 3], bytes[offset + 15]);
    def = _levelFromBytes(bytes[offset + 4], bytes[offset + 16]);
    mag = _levelFromBytes(bytes[offset + 5], bytes[offset + 17]);
    mnd = _levelFromBytes(bytes[offset + 6], bytes[offset + 18]);
    spd = _levelFromBytes(bytes[offset + 7], bytes[offset + 19]);
    eva = _levelFromBytes(bytes[offset + 8], 0);
    acc = _levelFromBytes(bytes[offset + 9], 0);
    aff = _levelFromBytes(bytes[offset + 10], 0);
    res = _levelFromBytes(bytes[offset + 11], 0);
  }

  TomeData.from(TomeData other) {
    hp = other.hp;
    mp = other.mp;
    tp = other.tp;
    atk = other.atk;
    def = other.def;
    mag = other.mag;
    mnd = other.mnd;
    spd = other.spd;
  }

  Iterable<int> toBytes(Endian endianness) {
    List<TomeLevel> stats = <TomeLevel>[hp, mp, tp, atk, def, mag, mnd, spd];
    List<TomeLevel> extra = <TomeLevel>[eva, acc, aff, res];
    return (stats + extra).map((TomeLevel stat) => stat.flag).followedBy(
      stats.map((TomeLevel stat) => stat.level),
    );
  }
}

class GemData {
  late int hp;
  late int mp;
  late int tp;
  late int atk;
  late int def;
  late int mag;
  late int mnd;
  late int spd;

  GemData.fromBytes(List<int> bytes, int offset) {
    hp = bytes[offset];
    mp = bytes[offset + 2];
    tp = bytes[offset + 4];
    atk = bytes[offset + 6];
    def = bytes[offset + 8];
    mag = bytes[offset + 10];
    mnd = bytes[offset + 12];
    spd = bytes[offset + 14];
  }

  GemData.from(GemData other) {
    hp = other.hp;
    mp = other.mp;
    tp = other.tp;
    atk = other.atk;
    def = other.def;
    mag = other.mag;
    mnd = other.mnd;
    spd = other.spd;
  }

  Iterable<int> toBytes(Endian endianness) {
    return <int>[
      ...hp.toU16(endianness),
      ...mp.toU16(endianness),
      ...tp.toU16(endianness),
      ...atk.toU16(endianness),
      ...def.toU16(endianness),
      ...mag.toU16(endianness),
      ...mnd.toU16(endianness),
      ...spd.toU16(endianness),
    ];
  }
}

class Item {
  late int id;

  Item({required this.id});

  Item.from(Item other) {
    id = other.id;
  }

  Iterable<int> toBytes(Endian endianness) {
    return id.toU16(endianness);
  }
}

class CharacterData {
  late CharacterName character;
  late int level;
  late int unusedSkillPoints;
  late int unusedBonusPoints;
  late int usedManuals;
  late int bp;
  late BigInt experience;
  late Subclass subclass;
  late LibraryData libraryLevels;
  late LevelBonus levelBonus;
  late SkillData skills;
  late TomeData tomes;
  late GemData gems;
  late List<Item> equips;

  CharacterData.fromBytes({
    required Endian endianness,
    required int index,
    required List<int> bytes,
  }) {
    character = CharacterName.values.elementAt(index);
    level = bytes.getU32(endianness);
    experience = bytes.getU64(endianness, offset: 0x4);
    libraryLevels = LibraryData.fromBytes(endianness, bytes, 0xc);
    levelBonus = LevelBonus.fromBytes(endianness, bytes, 0x44);
    subclass = Subclass.values.elementAt(
      bytes[0x5c] > 0 ? bytes[0x5c] - 99 : 0,
    );
    skills = SkillData.fromBytes(bytes, 0x60);
    tomes = TomeData.fromBytes(bytes, 0xd8);
    unusedSkillPoints = bytes.getI16(endianness, offset: 0xec);
    unusedBonusPoints = bytes.getI32(endianness, offset: 0xee);
    gems = GemData.fromBytes(bytes, 0xf2);
    usedManuals = bytes[0x102];
    bp = bytes.getU32(endianness, offset: 0x103);
    equips = <Item>[];
    for (int i = 0; i < 4; i++) {
      equips.add(
        Item(
          id: bytes.getU16(endianness, offset: 0x107 + (i * 2)),
        ),
      );
    }
  }

  CharacterData.from(CharacterData other) {
    character = other.character;
    level = other.level;
    unusedSkillPoints = other.unusedSkillPoints;
    unusedBonusPoints = other.unusedBonusPoints;
    usedManuals = other.usedManuals;
    bp = other.bp;
    experience = other.experience;
    subclass = other.subclass;
    libraryLevels = LibraryData.from(other.libraryLevels);
    levelBonus = LevelBonus.from(other.levelBonus);
    skills = SkillData.from(other.skills);
    tomes = TomeData.from(other.tomes);
    gems = GemData.from(other.gems);
    equips = other.equips.deepCopyElements(Item.from);
  }

  Iterable<int> toBytes(Endian endianness) {
    Iterable<int> bytes = <int>[];
    bytes = bytes.followedBy(level.toU32(endianness));
    bytes = bytes.followedBy(experience.toU64(endianness));
    bytes = bytes.followedBy(libraryLevels.toBytes(endianness));
    bytes = bytes.followedBy(levelBonus.toBytes(endianness));
    int subclassIndex = (subclass != Subclass.none) ? subclass.index + 99 : 0;
    bytes = bytes.followedBy(subclassIndex.toU32(endianness));
    bytes = bytes.followedBy(skills.toBytes(endianness));
    bytes = bytes.followedBy(tomes.toBytes(endianness));
    bytes = bytes.followedBy(unusedSkillPoints.toI16(endianness));
    bytes = bytes.followedBy(unusedBonusPoints.toI32(endianness));
    bytes = bytes.followedBy(gems.toBytes(endianness));
    bytes = bytes.followedBy(<int>[usedManuals]);
    bytes = bytes.followedBy(bp.toU32(endianness));
    for (Item item in equips) {
      bytes = bytes.followedBy(item.toBytes(endianness));
    }
    return bytes;
  }

  @override
  String toString() {
    return character.name;
  }
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

class PartySlot {
  late CharacterName character;
  late bool isUsed;

  PartySlot.empty() : isUsed = false;
  PartySlot.filled(int byte) {
    character = CharacterName.values.elementAt(byte - 1);
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

class LogBuffer {
  StringBuffer debug = StringBuffer();
  StringBuffer error = StringBuffer();
}

class SaveFile {
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
  List<int> mainInventoryFlagData = <int>[];
  List<int> subInventoryFlagData = <int>[];
  List<int> materialInventoryFlagData = <int>[];
  List<int> specialInventoryFlagData = <int>[];
  List<int> mainInventoryData = <int>[];
  List<int> subInventoryData = <int>[];
  List<int> materialInventoryData = <int>[];
  List<int> specialInventoryData = <int>[];
  late List<CharacterData> characterData;
  List<int> mainMapData = <int>[];
  List<int> undergroundMapData = <int>[];

  SaveFile.fromSteamBytes(List<int> bytes, LogBuffer logBuffer) {
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
    _setPartyData(decrypted.sublist(0x5018, 0x5024), logBuffer);
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
    _setCharacterData(decrypted.sublist(0x9346, 0xce8e), logBuffer);
    _setMainMapData(decrypted.sublist(0xce8e, 0x2ae8e));
    _setUndergroundMapData(decrypted.sublist(0x33e8e, 0x3ee8e));
  }

  List<int> exportSteam(LogBuffer logBuffer) {
    List<int> bytes = List<int>.filled(steamFileSize, 0, growable: true);
    bytes[0x67] = 0x1;
    bytes.replaceRange(0x0, 0x4, <int>[0x42, 0x4c, 0x48, 0x54]);
    bytes.replaceRange(0x5, 0x3d, _exportCharacterUnlockFlags(logBuffer));
    bytes.replaceRange(0x68, 0xd0, achievementData);
    bytes.replaceRange(0xd6, 0x10a, achievementDataPlus);
    bytes.replaceRange(0x130, 0x198, achievementNotificationsData);
    bytes.replaceRange(0x19e, 0x1d2, achievementNotificationsDataPlus);
    bytes.replaceRange(0x2c2, 0x4c22, bestiaryData);
    bytes.replaceRange(0x5018, 0x5024, _exportPartyData(logBuffer));
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
    bytes.replaceRange(0x9346, 0xce8e, _exportCharacterData(logBuffer));
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

  Iterable<int> _exportCharacterUnlockFlags(LogBuffer logBuffer) {
    logBuffer.debug.writeln('Character unlock: $characterUnlockFlags');
    return characterUnlockFlags.map<int>(
      (CharacterUnlockFlag flag) => (flag.isUnlocked) ? 0x1 : 0x0,
    );
  }

  Iterable<int> _exportPartyData(LogBuffer logBuffer) {
    logBuffer.debug.writeln('Party data: $partyData');
    return partyData.map<int>((PartySlot slot) => slot.toByte());
  }

  Iterable<int> _exportCharacterData(LogBuffer logBuffer) {
    logBuffer.debug.writeln('Party data: $characterData');
    return characterData.fold<Iterable<int>>(
      <int>[],
      (Iterable<int> acc, CharacterData data) {
        Iterable<int> bytes = data.toBytes(Endian.little);
        return acc.followedBy(
          bytes,
        );
      },
    );
  }

  void _setCharacterUnlockFlagsFromBytes(
    List<int> bytes,
    LogBuffer logBuffer,
  ) {
    characterUnlockFlags = <CharacterUnlockFlag>[];
    logBuffer.debug.writeln('Character unlock bytes: $bytes');
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

  void _setPartyData(List<int> bytes, LogBuffer logBuffer) {
    partyData = <PartySlot>[];
    logBuffer.debug.writeln('Party bytes: $bytes');
    for (int i = 0; i < bytes.length; i++) {
      int byte = bytes[i];
      if (byte == 0) {
        partyData.add(PartySlot.empty());
      } else if (byte <= 56) {
        partyData.add(PartySlot.filled(byte));
      } else {
        logBuffer.error.writeln('Invalid party member at position $i: $byte');
      }
    }
  }

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

  void _setCharacterData(List<int> bytes, LogBuffer logBuffer) {
    characterData = <CharacterData>[];
    for (int i = 0; i < 56; i++) {
      int start = i * characterDataLength;
      int end = (i + 1) * characterDataLength;
      List<int> characterBytes = bytes.sublist(start, end);
      logBuffer.debug.writeln('Character $i bytes: $characterBytes');
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
