import 'dart:typed_data';
import 'package:tfields/extensions.dart';
import 'package:thlaby2_save_editor/save/enums/character.dart';
import 'package:thlaby2_save_editor/save/enums/item.dart';
import 'package:thlaby2_save_editor/save/enums/skill.dart';
import 'package:thlaby2_save_editor/save/enums/subclass.dart';
import 'package:thlaby2_save_editor/save/gem.dart';
import 'package:thlaby2_save_editor/save/levelbonus.dart';
import 'package:thlaby2_save_editor/save/library.dart';
import 'package:thlaby2_save_editor/save/skill.dart';
import 'package:thlaby2_save_editor/save/tome.dart';
import 'package:thlaby2_save_editor/widgets/forms/groups/character_basic.dart';

class CharacterData {
  static const int skillPointBonusCap = CharacterBasic.levelCap + 2;
  static const int trainingManualsCap = 255;

  final Character character;
  final int level;
  final int unusedSkillPoints;
  final int unusedBonusPoints;
  final int usedManuals;
  final int bp;
  final BigInt experience;
  final Subclass subclass;
  final LibraryData libraryLevels;
  final LevelBonus levelBonus;
  final SkillData skills;
  final TomeData tomes;
  final GemData gems;
  final MainEquip mainEquip;
  final List<SubEquip> subEquips;

  bool get isKourin => character == Character.rinnosuke;

  bool getCommonSkillLocked(int index) =>
      tomes.getStatData(index) == TomeLevel.unused &&
      !character.isNaturalTomeStat(TomeStat.values[index]);

  Skill _getSkill(TomeLevel tomeLevel, List<Skill?> skills) =>
      switch (tomeLevel) {
    // Order is regular / 2 / mega / high / giga
    TomeLevel.unused || TomeLevel.insight => isKourin ? skills[3] : skills[0],
    TomeLevel.spartan || TomeLevel.spartanNatural => skills[1],
    TomeLevel.veteran ||
    TomeLevel.veteranNatural =>
      isKourin ? skills[4] : skills[2]
  } ?? skills[0]!; // Regular always has everything

  List<Skill?> _boostSkills(int index) => <Skill?>[
    BoostSkill.values.elementAtSafe(index),
    Boost2Skill.values.elementAtSafe(index),
    BoostMegaSkill.values.elementAtSafe(index),
    BoostHighSkill.values.elementAtSafe(index),
    BoostGigaSkill.values.elementAtSafe(index),
  ];

  Skill getCommonSkill(TomeLevel level, TomeStat stat) =>
      _getSkill(level, _boostSkills(stat.index));

  List<Skill> getCommonSkills(TomeData tomeData) => List<Skill>.generate(
    TomeStat.values.length,
    (int index) => _getSkill(tomeData.getStatData(index), _boostSkills(index)),
  );

  CharacterData({
    required this.character,
    required this.level,
    required this.unusedSkillPoints,
    required this.unusedBonusPoints,
    required this.usedManuals,
    required this.bp,
    required this.experience,
    required this.subclass,
    required this.libraryLevels,
    required this.levelBonus,
    required this.skills,
    required this.tomes,
    required this.gems,
    required this.mainEquip,
    required this.subEquips,
  });

  CharacterData.fromBytes({
    required Endian endianness,
    required int index,
    required Uint8List bytes,
  }) :
    character = Character.values.elementAt(index),
    level = bytes.getU32(endianness),
    experience = bytes.getU64(endianness, offset: 0x4),
    libraryLevels = LibraryData.fromBytes(endianness, bytes, 0xc),
    levelBonus = LevelBonus.fromBytes(endianness, bytes, 0x44),
    subclass =
        Subclass.values.elementAt(bytes[0x5c] > 0 ? bytes[0x5c] - 99 : 0),
    skills = SkillData.fromBytes(bytes, 0x60),
    tomes = TomeData.fromBytes(bytes, 0xd8),
    unusedSkillPoints = bytes.getI16(endianness, offset: 0xec),
    unusedBonusPoints = bytes.getI32(endianness, offset: 0xee),
    gems = GemData.fromBytes(bytes, 0xf2),
    usedManuals = bytes[0x102],
    bp = bytes.getU32(endianness, offset: 0x103),
    mainEquip = MainEquip.fromId(bytes.getU16(endianness, offset: 0x107)),
    subEquips = List<SubEquip>.generate(
      3,
      (int i) => SubEquip.fromId(
        bytes.getU16(endianness, offset: 0x109 + (i * 2)),
      ),
    );

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
    bytes = bytes.followedBy(mainEquip.toBytes(endianness));
    for (SubEquip equip in subEquips) {
      bytes = bytes.followedBy(equip.toBytes(endianness));
    }
    return bytes;
  }

  @override
  String toString() => character.name;
}
