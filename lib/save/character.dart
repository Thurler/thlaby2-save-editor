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
  reimu(
    <TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.mag],
    <Skill>[
      CommonSkill.mainReimu, CommonSkill.grandIncantation,
      CommonSkill.hakureiProtection, CommonSkill.finalPrayer,
      CommonSkill.armoredOrb, CommonSkill.youkaiBuster,
      CommonSkill.fantasyBlink, CommonSkill.barrierExpert,
      CommonSkill.superYoukaiBuster,
    ],
    <Skill>[
      Spell.yinYang, Spell.fantasySeal,
      Spell.exorcisingBorder, Spell.greatBarrier,
    ],
  ),
  marisa(
    <TomeStat>[TomeStat.mp, TomeStat.mag, TomeStat.spd],
    <Skill>[],
    <Skill>[],
  ),
  rinnosuke(
    <TomeStat>[
      TomeStat.mp, TomeStat.tp, TomeStat.atk,
      TomeStat.def, TomeStat.mag, TomeStat.mnd,
    ],
    <Skill>[],
    <Skill>[],
  ),
  keine(
    <TomeStat>[TomeStat.mp, TomeStat.tp, TomeStat.mag],
    <Skill>[],
    <Skill>[],
  ),
  momiji(
    <TomeStat>[TomeStat.hp, TomeStat.atk, TomeStat.def],
    <Skill>[],
    <Skill>[],
  ),
  youmu(
    <TomeStat>[TomeStat.atk, TomeStat.def, TomeStat.mnd],
    <Skill>[],
    <Skill>[],
  ),
  kogasa(
    <TomeStat>[TomeStat.tp, TomeStat.atk, TomeStat.eva],
    <Skill>[],
    <Skill>[],
  ),
  rumia(
    <TomeStat>[TomeStat.mag, TomeStat.spd, TomeStat.aff],
    <Skill>[],
    <Skill>[],
  ),
  cirno(
    <TomeStat>[TomeStat.tp, TomeStat.spd, TomeStat.aff],
    <Skill>[],
    <Skill>[],
  ),
  minoriko(
    <TomeStat>[TomeStat.mag, TomeStat.spd, TomeStat.res],
    <Skill>[],
    <Skill>[],
  ),
  komachi(
    <TomeStat>[TomeStat.hp, TomeStat.atk, TomeStat.mnd],
    <Skill>[],
    <Skill>[],
  ),
  chen(
    <TomeStat>[TomeStat.atk, TomeStat.spd, TomeStat.eva],
    <Skill>[],
    <Skill>[],
  ),
  nitori(
    <TomeStat>[TomeStat.def, TomeStat.mnd, TomeStat.aff],
    <Skill>[],
    <Skill>[],
  ),
  parsee(
    <TomeStat>[TomeStat.mp, TomeStat.mnd, TomeStat.res],
    <Skill>[],
    <Skill>[],
  ),
  wriggle(
    <TomeStat>[TomeStat.def, TomeStat.mnd, TomeStat.eva],
    <Skill>[],
    <Skill>[],
  ),
  kaguya(
    <TomeStat>[TomeStat.mp, TomeStat.mag, TomeStat.mnd],
    <Skill>[],
    <Skill>[],
  ),
  mokou(
    <TomeStat>[TomeStat.hp, TomeStat.tp, TomeStat.atk],
    <Skill>[],
    <Skill>[],
  ),
  aya(
    <TomeStat>[TomeStat.hp, TomeStat.atk, TomeStat.eva],
    <Skill>[],
    <Skill>[],
  ),
  mystia(
    <TomeStat>[TomeStat.mp, TomeStat.atk, TomeStat.spd],
    <Skill>[],
    <Skill>[],
  ),
  kasen(
    <TomeStat>[TomeStat.hp, TomeStat.tp, TomeStat.spd],
    <Skill>[],
    <Skill>[],
  ),
  nazrin(
    <TomeStat>[TomeStat.mnd, TomeStat.spd, TomeStat.eva],
    <Skill>[],
    <Skill>[],
  ),
  hina(
    <TomeStat>[TomeStat.hp, TomeStat.def, TomeStat.mnd],
    <Skill>[],
    <Skill>[],
  ),
  rin(
    <TomeStat>[TomeStat.atk, TomeStat.mag, TomeStat.spd],
    <Skill>[],
    <Skill>[],
  ),
  utsuho(
    <TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.mag],
    <Skill>[],
    <Skill>[],
  ),
  satori(
    <TomeStat>[TomeStat.mp, TomeStat.atk, TomeStat.mag],
    <Skill>[],
    <Skill>[],
  ),
  yuugi(
    <TomeStat>[TomeStat.hp, TomeStat.atk, TomeStat.def],
    <Skill>[],
    <Skill>[],
  ),
  meiling(
    <TomeStat>[TomeStat.tp, TomeStat.def, TomeStat.mnd],
    <Skill>[],
    <Skill>[],
  ),
  alice(
    <TomeStat>[TomeStat.hp, TomeStat.mag, TomeStat.mnd],
    <Skill>[],
    <Skill>[],
  ),
  patchouli(
    <TomeStat>[TomeStat.mp, TomeStat.mag, TomeStat.aff],
    <Skill>[],
    <Skill>[],
  ),
  eirin(
    <TomeStat>[TomeStat.hp, TomeStat.mag, TomeStat.res],
    <Skill>[],
    <Skill>[],
  ),
  reisen(
    <TomeStat>[TomeStat.mp, TomeStat.mag, TomeStat.spd],
    <Skill>[],
    <Skill>[],
  ),
  sanae(
    <TomeStat>[TomeStat.def, TomeStat.mag, TomeStat.mnd],
    <Skill>[],
    <Skill>[],
  ),
  iku(
    <TomeStat>[TomeStat.hp, TomeStat.def, TomeStat.mag],
    <Skill>[],
    <Skill>[],
  ),
  suika(
    <TomeStat>[TomeStat.atk, TomeStat.mnd, TomeStat.res],
    <Skill>[],
    <Skill>[],
  ),
  ran(
    <TomeStat>[TomeStat.mp, TomeStat.mag, TomeStat.spd],
    <Skill>[],
    <Skill>[],
  ),
  remilia(
    <TomeStat>[TomeStat.hp, TomeStat.atk, TomeStat.spd],
    <Skill>[],
    <Skill>[],
  ),
  sakuya(
    <TomeStat>[TomeStat.mp, TomeStat.atk, TomeStat.spd],
    <Skill>[],
    <Skill>[],
  ),
  kanako(
    <TomeStat>[TomeStat.hp, TomeStat.def, TomeStat.mag],
    <Skill>[],
    <Skill>[],
  ),
  suwako(
    <TomeStat>[TomeStat.mp, TomeStat.atk, TomeStat.mag],
    <Skill>[],
    <Skill>[],
  ),
  tenshi(
    <TomeStat>[TomeStat.tp, TomeStat.aff, TomeStat.res],
    <Skill>[],
    <Skill>[],
  ),
  flandre(
    <TomeStat>[TomeStat.mp, TomeStat.atk, TomeStat.mag],
    <Skill>[],
    <Skill>[],
  ),
  yuyuko(
    <TomeStat>[TomeStat.mp, TomeStat.mag, TomeStat.spd],
    <Skill>[],
    <Skill>[],
  ),
  yuuka(
    <TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.mag],
    <Skill>[],
    <Skill>[],
  ),
  yukari(
    <TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.mnd],
    <Skill>[],
    <Skill>[],
  ),
  byakuren(
    <TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.spd],
    <Skill>[],
    <Skill>[],
  ),
  eiki(
    <TomeStat>[TomeStat.atk, TomeStat.mag, TomeStat.mnd],
    <Skill>[],
    <Skill>[],
  ),
  renko(
    <TomeStat>[TomeStat.spd, TomeStat.eva, TomeStat.res],
    <Skill>[],
    <Skill>[],
  ),
  maribel(
    <TomeStat>[TomeStat.mp, TomeStat.tp, TomeStat.mag],
    <Skill>[],
    <Skill>[],
  ),
  shou(
    <TomeStat>[TomeStat.hp, TomeStat.def, TomeStat.mnd],
    <Skill>[],
    <Skill>[],
  ),
  mamizou(
    <TomeStat>[TomeStat.mp, TomeStat.tp, TomeStat.eva],
    <Skill>[],
    <Skill>[],
  ),
  futo(
    <TomeStat>[TomeStat.tp, TomeStat.atk, TomeStat.res],
    <Skill>[],
    <Skill>[],
  ),
  miko(
    <TomeStat>[TomeStat.hp, TomeStat.mag, TomeStat.aff],
    <Skill>[],
    <Skill>[],
  ),
  kokoro(
    <TomeStat>[TomeStat.atk, TomeStat.def, TomeStat.mag, TomeStat.mnd],
    <Skill>[],
    <Skill>[],
  ),
  tokiko(
    <TomeStat>[
      TomeStat.atk, TomeStat.def, TomeStat.mag, TomeStat.mnd, TomeStat.spd,
    ],
    <Skill>[],
    <Skill>[],
  ),
  koishi(
    <TomeStat>[TomeStat.mp, TomeStat.mnd, TomeStat.eva],
    <Skill>[],
    <Skill>[],
  ),
  akyuu(
    <TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp],
    <Skill>[],
    <Skill>[],
  );

  final List<TomeStat> naturalTomeStats;
  final List<Skill> skills;
  final List<Skill> spells;

  const Character(this.naturalTomeStats, this.skills, this.spells);

  bool isNaturalTomeStat(TomeStat stat) => naturalTomeStats.contains(stat);

  List<String> tomeDropdownOptions(TomeStat stat) {
    List<TomeLevel> levels = <TomeLevel>[TomeLevel.unused];
    bool isNatural = isNaturalTomeStat(stat);
    if (!isNatural) {
      levels.add(TomeLevel.insight);
    }
    if (stat.multiLevel && isNatural) {
      if (this != rinnosuke) {
        levels.add(TomeLevel.spartanNatural);
      }
      levels.add(TomeLevel.veteranNatural);
    } else if (stat.multiLevel) {
      if (this != rinnosuke) {
        levels.add(TomeLevel.spartan);
      }
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

  bool get isKourin => character == Character.rinnosuke;

  Skill _getSkill(TomeLevel tomeLevel, List<Skill?> skills) {
    // Order is regular / 2 / mega / high / giga
    Skill defaultSkill = skills.elementAt(0)!; // Regular always has everything
    Skill? result;
    if (tomeLevel.index < TomeLevel.spartanNatural.index) {
      result = isKourin ? skills.elementAt(3) : skills.elementAt(0);
    } else if (tomeLevel.index < TomeLevel.veteranNatural.index) {
      result = skills.elementAt(1);
    } else {
      result = isKourin ? skills.elementAt(4) : skills.elementAt(2);
    }
    return result ?? defaultSkill;
  }

  List<Skill?> _boostSkills(int index) {
    return <Skill?>[
      BoostSkill.values.elementAtSafe(index),
      Boost2Skill.values.elementAtSafe(index),
      BoostMegaSkill.values.elementAtSafe(index),
      BoostHighSkill.values.elementAtSafe(index),
      BoostGigaSkill.values.elementAtSafe(index),
    ];
  }

  List<Skill> getCommonSkills(Iterable<String> tomeSelections) {
    List<Skill> commonSkills = <Skill>[];
    for (int i = 0; i < tomeSelections.length; i++) {
      TomeLevel level = TomeData.levelFromString(
        tomeSelections.elementAt(i),
        isNatural: character.isNaturalTomeStat(TomeStat.values.elementAt(i)),
      );
      commonSkills.add(_getSkill(level, _boostSkills(i)));
    }
    return commonSkills;
  }

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
