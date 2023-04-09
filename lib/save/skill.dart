import 'dart:typed_data';
import 'package:thlaby2_save_editor/extensions/int_extension.dart';

abstract class Skill {
  final int maxLevel;
  final int levelCost;
  final String name;

  Skill(this.maxLevel, this.levelCost, this.name);
}

enum BoostSkill implements Skill {
  hp(5, 2, 'HP Boost'),
  mp(5, 2, 'MP Boost'),
  tp(5, 2, 'TP Boost'),
  atk(5, 2, 'ATK Boost'),
  def(5, 2, 'DEF Boost'),
  mag(5, 2, 'MAG Boost'),
  mnd(5, 2, 'MND Boost'),
  spd(5, 2, 'SPD Boost'),
  eva(5, 2, 'EVA Boost'),
  acc(5, 2, 'ACC Boost'),
  aff(5, 2, 'Affinity Boost'),
  res(5, 2, 'Resistance Boost');

  @override
  final int maxLevel;
  @override
  final int levelCost;
  @override
  final String name;

  const BoostSkill(this.maxLevel, this.levelCost, this.name);
}

enum Boost2Skill implements Skill {
  hp(5, 10, 'HP Boost 2'),
  mp(5, 10, 'MP Boost 2'),
  tp(5, 10, 'TP Boost 2'),
  atk(5, 10, 'ATK Boost 2'),
  def(5, 10, 'DEF Boost 2'),
  mag(5, 10, 'MAG Boost 2'),
  mnd(5, 10, 'MND Boost 2'),
  spd(5, 10, 'SPD Boost 2');

  @override
  final int maxLevel;
  @override
  final int levelCost;
  @override
  final String name;

  const Boost2Skill(this.maxLevel, this.levelCost, this.name);
}

enum BoostMegaSkill implements Skill {
  hp(5, 50, 'HP Mega Boost'),
  mp(5, 50, 'MP Mega Boost'),
  tp(5, 50, 'TP Mega Boost'),
  atk(5, 50, 'ATK Mega Boost'),
  def(5, 50, 'DEF Mega Boost'),
  mag(5, 50, 'MAG Mega Boost'),
  mnd(5, 50, 'MND Mega Boost'),
  spd(5, 50, 'SPD Mega Boost');

  @override
  final int maxLevel;
  @override
  final int levelCost;
  @override
  final String name;

  const BoostMegaSkill(this.maxLevel, this.levelCost, this.name);
}

enum BoostHighSkill implements Skill {
  hp(5, 6, 'HP High Boost'),
  mp(5, 3, 'MP High Boost'),
  tp(5, 6, 'TP High Boost'),
  atk(5, 6, 'ATK High Boost'),
  def(5, 6, 'DEF High Boost'),
  mag(5, 6, 'MAG High Boost'),
  mnd(5, 6, 'MND High Boost'),
  spd(5, 6, 'SPD High Boost'),
  eva(5, 6, 'EVA High Boost'),
  acc(5, 6, 'ACC High Boost'),
  aff(5, 6, 'Affinity High Boost'),
  res(5, 6, 'Resistance High Boost');

  @override
  final int maxLevel;
  @override
  final int levelCost;
  @override
  final String name;

  const BoostHighSkill(this.maxLevel, this.levelCost, this.name);
}

enum BoostGigaSkill implements Skill {
  hp(5, 75, 'HP Giga Boost'),
  mp(5, 75, 'MP Giga Boost'),
  tp(5, 75, 'TP Giga Boost'),
  atk(5, 75, 'ATK Giga Boost'),
  def(5, 75, 'DEF Giga Boost'),
  mag(5, 75, 'MAG Giga Boost'),
  mnd(5, 75, 'MND Giga Boost'),
  spd(5, 75, 'SPD Giga Boost');

  @override
  final int maxLevel;
  @override
  final int levelCost;
  @override
  final String name;

  const BoostGigaSkill(this.maxLevel, this.levelCost, this.name);
}

enum ExpSkill implements Skill {
  motivatedHeart(2, 5, 'Motivated Heart'),
  handsOnExperience(2, 5, 'Hands-on Experience');

  @override
  final int maxLevel;
  @override
  final int levelCost;
  @override
  final String name;

  const ExpSkill(this.maxLevel, this.levelCost, this.name);
}

enum CommonSkill implements Skill {
  mainReimu(2, 5, 'Main Character: Reimu'),
  grandIncantation(2, 5, 'Grand Incantation'),
  hakureiProtection(2, 5, "Hakurei's Divine Protection"),
  finalPrayer(2, 5, 'Final Prayer'),
  armoredOrb(2, 5, 'Armored Yin-Yang Orb'),
  youkaiBuster(2, 5, 'Youkai Buster'),
  fantasyBlink(10, 16, 'Fantasy Seal -Blink-'),
  barrierExpert(1, 50, 'Barrier Expert'),
  superYoukaiBuster(2, 40, 'Super Youkai Buster'),
  maliceMarisa(2, 5, 'MAlice Cannon (Marisa)'),
  mainMarisa(2, 5, 'Main Character: Marisa'),
  sheerForce(1, 15, 'Sheer Force'),
  suddenImpulse(2, 5, 'Sudden Impulse'),
  givingWings(2, 5, 'Giving You Wings'),
  magicTraining(2, 5, 'Magic Training'),
  hakkeroCharge(1, 80, 'Hakkero Charge Mode'),
  hakkeroCustom(1, 70, 'Hakkero Custom Mode'),
  magicDrain(7, 10, 'Magic Drain Missile');

  @override
  final int maxLevel;
  @override
  final int levelCost;
  @override
  final String name;

  const CommonSkill(this.maxLevel, this.levelCost, this.name);
}

enum Spell implements Skill {
  yinYang(5, 5, 'Yin-Yang Orb'),
  fantasySeal(5, 5, 'Fantasy Seal'),
  exorcisingBorder(5, 5, 'Exorcising Border'),
  greatBarrier(5, 5, 'Great Hakurei Barrier'),
  magicMissile(5, 5, 'Magic Missile'),
  asteroidBelt(5, 5, 'Asteroid Belt'),
  masterSpark(5, 5, 'Master Spark'),
  concentration(5, 5, 'Concentration');

  @override
  final int maxLevel;
  @override
  final int levelCost;
  @override
  final String name;

  const Spell(this.maxLevel, this.levelCost, this.name);
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

  int getBoostData(int index) {
    return <int>[
      hpBoost, mpBoost, tpBoost, atkBoost, defBoost, magBoost,
      mndBoost, spdBoost, evaBoost, accBoost, affBoost, resBoost,
    ][index];
  }

  int getExpData(int index) {
    return <int>[motivatedHeart, handsOnExperience][index];
  }

  void setBoostData(int index, String raw) {
    int value = int.parse(raw);
    switch (index) {
      case 0: hpBoost = value; break;
      case 1: mpBoost = value; break;
      case 2: tpBoost = value; break;
      case 3: atkBoost = value; break;
      case 4: defBoost = value; break;
      case 5: magBoost = value; break;
      case 6: mndBoost = value; break;
      case 7: spdBoost = value; break;
      case 8: evaBoost = value; break;
      case 9: accBoost = value; break;
      case 10: affBoost = value; break;
      case 11: resBoost = value; break;
    }
  }

  void setExpData(int index, String raw) {
    int value = int.parse(raw);
    switch (index) {
      case 0: motivatedHeart = value; break;
      case 1: handsOnExperience = value; break;
    }
  }

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
