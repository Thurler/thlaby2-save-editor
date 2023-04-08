import 'dart:typed_data';
import 'package:thlaby2_save_editor/extensions/int_extension.dart';
import 'package:thlaby2_save_editor/extensions/list_extension.dart';
import 'package:thlaby2_save_editor/save/equip.dart';
import 'package:thlaby2_save_editor/save/gem.dart';
import 'package:thlaby2_save_editor/save/levelbonus.dart';
import 'package:thlaby2_save_editor/save/library.dart';
import 'package:thlaby2_save_editor/save/skill.dart';
import 'package:thlaby2_save_editor/save/tome.dart';

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
  late Equipment mainEquip;
  late List<Equipment> subEquips;

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
    mainEquip = Equipment(id: bytes.getU16(endianness, offset: 0x107));
    subEquips = <Equipment>[];
    for (int i = 0; i < 3; i++) {
      subEquips.add(
        Equipment(
          id: bytes.getU16(endianness, offset: 0x109 + (i * 2)),
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
    mainEquip = Equipment.from(other.mainEquip);
    subEquips = other.subEquips.deepCopyElements(Equipment.from);
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
    for (Equipment equip in subEquips) {
      bytes = bytes.followedBy(equip.toBytes(endianness));
    }
    return bytes;
  }

  @override
  String toString() {
    return character.name;
  }
}
