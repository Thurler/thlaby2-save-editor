import 'dart:typed_data';

import 'package:tfields/extensions.dart';

class GemData {
  static const int gemCap = 20; // Hard cap at shrine

  final int hp;
  final int mp;
  final int tp;
  final int atk;
  final int def;
  final int mag;
  final int mnd;
  final int spd;

  int getStatData(int index) =>
      <int>[hp, mp, tp, atk, def, mag, mnd, spd][index];

  GemData({
    required this.hp,
    required this.mp,
    required this.tp,
    required this.atk,
    required this.def,
    required this.mag,
    required this.mnd,
    required this.spd,
  });

  GemData.fromBytes(Uint8List bytes, int offset) :
    hp = bytes[offset],
    mp = bytes[offset + 2],
    tp = bytes[offset + 4],
    atk = bytes[offset + 6],
    def = bytes[offset + 8],
    mag = bytes[offset + 10],
    mnd = bytes[offset + 12],
    spd = bytes[offset + 14];

  Iterable<int> toBytes(Endian endianness) => <int>[
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
