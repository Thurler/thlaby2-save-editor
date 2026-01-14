import 'dart:typed_data';

import 'package:tfields/extensions.dart';

class LibraryData {
  static const int libraryCap = 99999999; // Hard cap at library
  static const int libraryElementCap = 100; // Hard cap at library

  final int hp;
  final int atk;
  final int def;
  final int mag;
  final int mnd;
  final int spd;
  final int fir;
  final int cld;
  final int wnd;
  final int ntr;
  final int mys;
  final int spi;
  final int drk;
  final int phy;

  int getData(int index) => index < 6
    ? <int>[hp, atk, def, mag, mnd, spd][index]
    : <int>[fir, cld, wnd, ntr, mys, spi, drk, phy][index - 6];

  LibraryData({
    required this.hp,
    required this.atk,
    required this.def,
    required this.mag,
    required this.mnd,
    required this.spd,
    required this.fir,
    required this.cld,
    required this.wnd,
    required this.ntr,
    required this.mys,
    required this.spi,
    required this.drk,
    required this.phy,
  });

  LibraryData.fromBytes(Endian endianness, Uint8List bytes, int offset) :
    hp = bytes.getU32(endianness, offset: offset),
    atk = bytes.getU32(endianness, offset: offset + 4),
    def = bytes.getU32(endianness, offset: offset + 8),
    mag = bytes.getU32(endianness, offset: offset + 12),
    mnd = bytes.getU32(endianness, offset: offset + 16),
    spd = bytes.getU32(endianness, offset: offset + 20),
    fir = bytes.getU32(endianness, offset: offset + 24),
    cld = bytes.getU32(endianness, offset: offset + 28),
    wnd = bytes.getU32(endianness, offset: offset + 32),
    ntr = bytes.getU32(endianness, offset: offset + 36),
    mys = bytes.getU32(endianness, offset: offset + 40),
    spi = bytes.getU32(endianness, offset: offset + 44),
    drk = bytes.getU32(endianness, offset: offset + 48),
    phy = bytes.getU32(endianness, offset: offset + 52);

  Iterable<int> toBytes(Endian endianness) => <int>[
    ...hp.toU32(endianness),
    ...atk.toU32(endianness),
    ...def.toU32(endianness),
    ...mag.toU32(endianness),
    ...mnd.toU32(endianness),
    ...spd.toU32(endianness),
    ...fir.toU32(endianness),
    ...cld.toU32(endianness),
    ...wnd.toU32(endianness),
    ...ntr.toU32(endianness),
    ...mys.toU32(endianness),
    ...spi.toU32(endianness),
    ...drk.toU32(endianness),
    ...phy.toU32(endianness),
  ];
}
