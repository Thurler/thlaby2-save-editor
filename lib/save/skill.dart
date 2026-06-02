import 'dart:typed_data';

import 'package:tfields/extensions.dart';

class SkillData {
  final int hpBoost;
  final int mpBoost;
  final int tpBoost;
  final int atkBoost;
  final int defBoost;
  final int magBoost;
  final int mndBoost;
  final int spdBoost;
  final int evaBoost;
  final int accBoost;
  final int affBoost;
  final int resBoost;
  final int motivatedHeart;
  final int handsOnExperience;
  final List<int> personalSkills;
  final List<int> personalSpells;
  final List<int> subclassSkills;

  int getCommonData(int index) => <int>[
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
    motivatedHeart,
    handsOnExperience,
  ][index];

  SkillData({
    required List<int> commonSkills,
    required List<int> personalSkills,
    required List<int> personalSpells,
    required List<int> subclassSkills,
  }) :
    hpBoost = commonSkills.elementAtSafe(0) ?? 0,
    mpBoost = commonSkills.elementAtSafe(1) ?? 0,
    tpBoost = commonSkills.elementAtSafe(2) ?? 0,
    atkBoost = commonSkills.elementAtSafe(3) ?? 0,
    defBoost = commonSkills.elementAtSafe(4) ?? 0,
    magBoost = commonSkills.elementAtSafe(5) ?? 0,
    mndBoost = commonSkills.elementAtSafe(6) ?? 0,
    spdBoost = commonSkills.elementAtSafe(7) ?? 0,
    evaBoost = commonSkills.elementAtSafe(8) ?? 0,
    accBoost = commonSkills.elementAtSafe(9) ?? 0,
    affBoost = commonSkills.elementAtSafe(10) ?? 0,
    resBoost = commonSkills.elementAtSafe(11) ?? 0,
    motivatedHeart = commonSkills.elementAtSafe(12) ?? 0,
    handsOnExperience = commonSkills.elementAtSafe(13) ?? 0,
    personalSkills =
        List<int>.generate(10, (int i) => personalSkills.elementAtSafe(i) ?? 0),
    personalSpells =
        List<int>.generate(10, (int i) => personalSpells.elementAtSafe(i) ?? 0),
    subclassSkills =
        List<int>.generate(20, (int i) => subclassSkills.elementAtSafe(i) ?? 0);

  SkillData.fromBytes(Uint8List bytes, int offset) :
    hpBoost = bytes[offset],
    mpBoost = bytes[offset + 2],
    tpBoost = bytes[offset + 4],
    atkBoost = bytes[offset + 6],
    defBoost = bytes[offset + 8],
    magBoost = bytes[offset + 10],
    mndBoost = bytes[offset + 12],
    spdBoost = bytes[offset + 14],
    evaBoost = bytes[offset + 16],
    accBoost = bytes[offset + 18],
    affBoost = bytes[offset + 20],
    resBoost = bytes[offset + 22],
    motivatedHeart = bytes[offset + 36],
    handsOnExperience = bytes[offset + 38],
    personalSkills =
        List<int>.generate(10, (int i) => bytes[offset + 40 + (i * 2)]),
    personalSpells =
        List<int>.generate(10, (int i) => bytes[offset + 60 + (i * 2)]),
    subclassSkills =
        List<int>.generate(20, (int i) => bytes[offset + 80 + (i * 2)]);

  Iterable<int> _skillListToBytes(List<int> skills, Endian endianness) {
    return skills.fold<Iterable<int>>(
      <int>[],
      (Iterable<int> acc, int skill) => acc.followedBy(skill.toU16(endianness)),
    );
  }

  Iterable<int> toBytes(Endian endianness) => <int>[
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
