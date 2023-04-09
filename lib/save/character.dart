import 'dart:typed_data';
import 'package:thlaby2_save_editor/extensions/int_extension.dart';
import 'package:thlaby2_save_editor/extensions/list_extension.dart';
import 'package:thlaby2_save_editor/save/equip.dart';
import 'package:thlaby2_save_editor/save/gem.dart';
import 'package:thlaby2_save_editor/save/levelbonus.dart';
import 'package:thlaby2_save_editor/save/library.dart';
import 'package:thlaby2_save_editor/save/skill.dart';
import 'package:thlaby2_save_editor/save/tome.dart';

enum Character {
  reimu(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.mag]),
  marisa(<TomeStat>[TomeStat.mp, TomeStat.mag, TomeStat.spd]),
  rinnosuke(<TomeStat>[
    TomeStat.mp, TomeStat.tp, TomeStat.atk,
    TomeStat.def, TomeStat.mag, TomeStat.mnd,
  ]),
  keine(<TomeStat>[TomeStat.mp, TomeStat.tp, TomeStat.mag]),
  momiji(<TomeStat>[TomeStat.hp, TomeStat.atk, TomeStat.def]),
  youmu(<TomeStat>[TomeStat.atk, TomeStat.def, TomeStat.mnd]),
  kogasa(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  rumia(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  cirno(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  minoriko(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  komachi(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  chen(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  nitori(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  parsee(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  wriggle(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  kaguya(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  mokou(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  aya(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  mystia(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  kasen(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  nazrin(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  hina(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  rin(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  utsuho(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  satori(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  yuugi(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  meiling(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  alice(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  patchouli(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  eirin(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  reisen(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  sanae(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  iku(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  suika(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  ran(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  remilia(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  sakuya(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  kanako(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  suwako(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  tenshi(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  flandre(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  yuyuko(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  yuuka(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  yukari(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  byakuren(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  eiki(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  renko(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  maribel(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  shou(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  mamizou(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  futo(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  miko(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  kokoro(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  tokiko(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  koishi(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]),
  akyuu(<TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp]);

  final List<TomeStat> naturalTomeStats;

  const Character(this.naturalTomeStats);

  bool isNaturalTomeStat(TomeStat stat) => naturalTomeStats.contains(stat);

  List<String> tomeDropdownOptions(TomeStat stat) {
    List<TomeLevel> levels = <TomeLevel>[TomeLevel.unused];
    bool isNatural = isNaturalTomeStat(stat);
    if (!isNatural) {
      levels.add(TomeLevel.insight);
    }
    if (stat.multiLevel && isNatural) {
      levels.add(TomeLevel.spartanNatural);
      levels.add(TomeLevel.veteranNatural);
    } else if (stat.multiLevel) {
      levels.add(TomeLevel.spartan);
      levels.add(TomeLevel.veteran);
    }
    return levels.map((TomeLevel l) => l.name).toList();
  }
}

enum Subclass {
  none('None', isUnique: false),
  guardian('Guardian', isUnique: false),
  monk('Monk', isUnique: false),
  warrior('Warrior', isUnique: false),
  sorcerer('Sorcerer', isUnique: false),
  healer('Healer', isUnique: false),
  enhancer('Enhancer', isUnique: false),
  hexer('Hexer', isUnique: false),
  toxicologist('Toxicologist', isUnique: false),
  magician('Magician', isUnique: false),
  herbalist('Herbalist', isUnique: false),
  strategist('Strategist', isUnique: false),
  gambler('Gambler', isUnique: false),
  diva('Diva', isUnique: false),
  transcendent('Transcendent', isUnique: false),
  swordmaster('Swordmaster', isUnique: false),
  archmage('Archmage', isUnique: false),
  appraiser('Appraiser', isUnique: false),
  elementalist('Elementalist', isUnique: false),
  ninja('Ninja', isUnique: false),
  oracle('Oracle', isUnique: false),
  holyblessing('Holy Blessing', isUnique: true),
  dragongodpower("Dragon God's Power", isUnique: true),
  winner('*WINNER*', isUnique: true);

  final String prettyName;
  final bool isUnique;

  const Subclass(this.prettyName, {required this.isUnique});
}

class CharacterData {
  late Character character;
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
  late MainEquip mainEquip;
  late List<SubEquip> subEquips;

  CharacterData.fromBytes({
    required Endian endianness,
    required int index,
    required List<int> bytes,
  }) {
    character = Character.values.elementAt(index);
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
    mainEquip = MainEquip.values.elementAt(
      bytes.getU16(endianness, offset: 0x107),
    );
    subEquips = <SubEquip>[];
    for (int i = 0; i < 3; i++) {
      int id = bytes.getU16(endianness, offset: 0x109 + (i * 2));
      subEquips.add(SubEquip.values.elementAt(id > 0 ? id - 200 : 0));
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
    mainEquip = other.mainEquip;
    subEquips = List<SubEquip>.from(other.subEquips);
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
    bytes = bytes.followedBy(mainEquip.toBytes(endianness));
    for (SubEquip equip in subEquips) {
      bytes = bytes.followedBy(equip.toBytes(endianness));
    }
    return bytes;
  }

  @override
  String toString() {
    return character.name;
  }
}
