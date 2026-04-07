import 'dart:typed_data';

import 'package:tfields/extensions.dart';
import 'package:thlaby2_save_editor/widgets/forms/groups/character_basic.dart';

class LevelBonus {
  static const int levelBonusCap = CharacterBasic.levelCap - 1;
  static const int levelBonusStatCount = 6;

  final int hp;
  final int atk;
  final int def;
  final int mag;
  final int mnd;
  final int spd;

  int getStatData(int index) => <int>[hp, atk, def, mag, mnd, spd][index];

  LevelBonus({
    required this.hp,
    required this.atk,
    required this.def,
    required this.mag,
    required this.mnd,
    required this.spd,
  });

  LevelBonus.fromBytes(Endian endianness, Uint8List bytes, int offset) :
    hp = bytes.getU32(endianness, offset: offset),
    atk = bytes.getU32(endianness, offset: offset + 4),
    def = bytes.getU32(endianness, offset: offset + 8),
    mag = bytes.getU32(endianness, offset: offset + 12),
    mnd = bytes.getU32(endianness, offset: offset + 16),
    spd = bytes.getU32(endianness, offset: offset + 20);

  Iterable<int> toBytes(Endian endianness) => <int>[
    ...hp.toU32(endianness),
    ...atk.toU32(endianness),
    ...def.toU32(endianness),
    ...mag.toU32(endianness),
    ...mnd.toU32(endianness),
    ...spd.toU32(endianness),
  ];
}
