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
  late List<Equipment> equips;

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
    equips = <Equipment>[];
    for (int i = 0; i < 4; i++) {
      equips.add(
        Equipment(
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
    equips = other.equips.deepCopyElements(Equipment.from);
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
    for (Equipment item in equips) {
      bytes = bytes.followedBy(item.toBytes(endianness));
    }
    return bytes;
  }

  @override
  String toString() {
    return character.name;
  }
}
