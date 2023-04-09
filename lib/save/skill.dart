import 'dart:typed_data';
import 'package:thlaby2_save_editor/extensions/int_extension.dart';

enum Skill {
  hpBoost(5, 2, 'HP Boost'),
  mpBoost(5, 2, 'MP Boost'),
  tpBoost(5, 2, 'TP Boost'),
  atkBoost(5, 2, 'ATK Boost'),
  defBoost(5, 2, 'DEF Boost'),
  magBoost(5, 2, 'MAG Boost'),
  mndBoost(5, 2, 'MND Boost'),
  spdBoost(5, 2, 'SPD Boost'),
  hpBoost2(5, 10, 'HP Boost 2'),
  mpBoost2(5, 10, 'MP Boost 2'),
  tpBoost2(5, 10, 'TP Boost 2'),
  atkBoost2(5, 10, 'ATK Boost 2'),
  defBoost2(5, 10, 'DEF Boost 2'),
  magBoost2(5, 10, 'MAG Boost 2'),
  mndBoost2(5, 10, 'MND Boost 2'),
  spdBoost2(5, 10, 'SPD Boost 2'),
  hpBoost3(5, 50, 'HP Mega Boost'),
  mpBoost3(5, 50, 'MP Mega Boost'),
  tpBoost3(5, 50, 'TP Mega Boost'),
  atkBoost3(5, 50, 'ATK Mega Boost'),
  defBoost3(5, 50, 'DEF Mega Boost'),
  magBoost3(5, 50, 'MAG Mega Boost'),
  mndBoost3(5, 50, 'MND Mega Boost'),
  spdBoost3(5, 50, 'SPD Mega Boost'),
  hpBoost4(5, 6, 'HP High Boost'),
  mpBoost4(5, 3, 'MP High Boost'),
  tpBoost4(5, 6, 'TP High Boost'),
  atkBoost4(5, 6, 'ATK High Boost'),
  defBoost4(5, 6, 'DEF High Boost'),
  magBoost4(5, 6, 'MAG High Boost'),
  mndBoost4(5, 6, 'MND High Boost'),
  spdBoost4(5, 6, 'SPD High Boost'),
  atkBoost5(5, 75, 'ATK Giga Boost'),
  defBoost5(5, 75, 'DEF Giga Boost'),
  magBoost5(5, 75, 'MAG Giga Boost'),
  mndBoost5(5, 75, 'MND Giga Boost'),
  spdBoost5(5, 75, 'SPD Giga Boost'),
  evaBoost(5, 2, 'EVA Boost'),
  accBoost(5, 2, 'ACC Boost'),
  affBoost(5, 2, 'Affinity Boost'),
  resBoost(5, 2, 'Resistance Boost'),
  evaBoost2(5, 6, 'EVA High Boost'),
  accBoost2(5, 6, 'ACC High Boost'),
  affBoost2(5, 6, 'Affinity High Boost'),
  resBoost2(5, 6, 'Resistance High Boost'),
  motivatedHeart(2, 5, 'Motivated Heart'),
  handsOnExperience(2, 5, 'Hands-on Experience');

  final int maxLevel;
  final int levelCost;
  final String name;

  const Skill(this.maxLevel, this.levelCost, this.name);
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
