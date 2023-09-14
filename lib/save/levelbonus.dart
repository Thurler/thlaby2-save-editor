import 'dart:typed_data';
import 'package:thlaby2_save_editor/extensions/int_extension.dart';
import 'package:thlaby2_save_editor/extensions/list_extension.dart';

class LevelBonus {
  late int hp;
  late int atk;
  late int def;
  late int mag;
  late int mnd;
  late int spd;

  int getStatData(int index) {
    return <int>[hp, atk, def, mag, mnd, spd][index];
  }

  void setStatData(int index, int value) {
    switch (index) {
      case 0: hp = value;
      break;
      case 1: atk = value;
      break;
      case 2: def = value;
      break;
      case 3: mag = value;
      break;
      case 4: mnd = value;
      break;
      case 5: spd = value;
      break;
    }
  }

  LevelBonus.fromBytes(Endian endianness, List<int> bytes, int offset) {
    hp = bytes.getU32(endianness, offset: offset);
    atk = bytes.getU32(endianness, offset: offset + 4);
    def = bytes.getU32(endianness, offset: offset + 8);
    mag = bytes.getU32(endianness, offset: offset + 12);
    mnd = bytes.getU32(endianness, offset: offset + 16);
    spd = bytes.getU32(endianness, offset: offset + 20);
  }

  LevelBonus.from(LevelBonus other) {
    hp = other.hp;
    atk = other.atk;
    def = other.def;
    mag = other.mag;
    mnd = other.mnd;
    spd = other.spd;
  }

  Iterable<int> toBytes(Endian endianness) {
    return <int>[
      ...hp.toU32(endianness),
      ...atk.toU32(endianness),
      ...def.toU32(endianness),
      ...mag.toU32(endianness),
      ...mnd.toU32(endianness),
      ...spd.toU32(endianness),
    ];
  }
}
