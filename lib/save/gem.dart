import 'dart:typed_data';
import 'package:thlaby2_save_editor/extensions/int_extension.dart';

class GemData {
  late int hp;
  late int mp;
  late int tp;
  late int atk;
  late int def;
  late int mag;
  late int mnd;
  late int spd;

  int getStatData(int index) {
    return <int>[hp, mp, tp, atk, def, mag, mnd, spd][index];
  }

  void setStatData(int index, int value) {
    switch (index) {
      case 0: hp = value;
      break;
      case 1: mp = value;
      break;
      case 2: tp = value;
      break;
      case 3: atk = value;
      break;
      case 4: def = value;
      break;
      case 5: mag = value;
      break;
      case 6: mnd = value;
      break;
      case 7: spd = value;
      break;
    }
  }

  GemData.fromBytes(List<int> bytes, int offset) {
    hp = bytes[offset];
    mp = bytes[offset + 2];
    tp = bytes[offset + 4];
    atk = bytes[offset + 6];
    def = bytes[offset + 8];
    mag = bytes[offset + 10];
    mnd = bytes[offset + 12];
    spd = bytes[offset + 14];
  }

  GemData.from(GemData other) {
    hp = other.hp;
    mp = other.mp;
    tp = other.tp;
    atk = other.atk;
    def = other.def;
    mag = other.mag;
    mnd = other.mnd;
    spd = other.spd;
  }

  Iterable<int> toBytes(Endian endianness) {
    return <int>[
      ...hp.toU16(endianness),
      ...mp.toU16(endianness),
      ...tp.toU16(endianness),
      ...atk.toU16(endianness),
      ...def.toU16(endianness),
      ...mag.toU16(endianness),
      ...mnd.toU16(endianness),
      ...spd.toU16(endianness),
    ];
  }
}
