import 'dart:typed_data';
import 'package:thlaby2_save_editor/extensions/int_extension.dart';

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

  int getBoostData(int index) {
    return <int>[
      hpBoost,
      mpBoost,
      tpBoost,
      atkBoost,
      defBoost,
      magBoost,
      mndBoost,
      spdBoost,
      evaBoost,
      accBoost,
      affBoost,
      resBoost,
    ][index];
  }

  int getExpData(int index) {
    return <int>[motivatedHeart, handsOnExperience][index];
  }

  void setBoostData(int index, int value) {
    switch (index) {
      case 0: hpBoost = value;
      break;
      case 1: mpBoost = value;
      break;
      case 2: tpBoost = value;
      break;
      case 3: atkBoost = value;
      break;
      case 4: defBoost = value;
      break;
      case 5: magBoost = value;
      break;
      case 6: mndBoost = value;
      break;
      case 7: spdBoost = value;
      break;
      case 8: evaBoost = value;
      break;
      case 9: accBoost = value;
      break;
      case 10: affBoost = value;
      break;
      case 11: resBoost = value;
      break;
    }
  }

  void setExpData(int index, int value) {
    switch (index) {
      case 0: motivatedHeart = value;
      break;
      case 1: handsOnExperience = value;
      break;
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
    for (int i = 0; i < 10; i++) {
      personalSkills[i] = bytes[offset + 40 + (i * 2)];
      personalSpells[i] = bytes[offset + 60 + (i * 2)];
    }
    subclassSkills = List<int>.filled(20, 0);
    for (int i = 0; i < 20; i++) {
      subclassSkills[i] = bytes[offset + 80 + (i * 2)];
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
    ];
  }
}
