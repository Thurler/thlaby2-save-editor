import 'dart:typed_data';
import 'package:thlaby2_save_editor/extensions/int_extension.dart';
import 'package:thlaby2_save_editor/extensions/list_extension.dart';

class LibraryData {
  late int hp;
  late int atk;
  late int def;
  late int mag;
  late int mnd;
  late int spd;
  late int fir;
  late int cld;
  late int wnd;
  late int ntr;
  late int mys;
  late int spi;
  late int drk;
  late int phy;

  int getStatData(int index) {
    return <int>[hp, atk, def, mag, mnd, spd][index];
  }

  int getElementData(int index) {
    return <int>[fir, cld, wnd, ntr, mys, spi, drk, phy][index];
  }

  void setStatData(int index, int value) {
    switch (index) {
      case 0: hp = value; break;
      case 1: atk = value; break;
      case 2: def = value; break;
      case 3: mag = value; break;
      case 4: mnd = value; break;
      case 5: spd = value; break;
    }
  }

  void setElementData(int index, int value) {
    switch (index) {
      case 0: fir = value; break;
      case 1: cld = value; break;
      case 2: wnd = value; break;
      case 3: ntr = value; break;
      case 4: mys = value; break;
      case 5: spi = value; break;
      case 6: drk = value; break;
      case 7: phy = value; break;
    }
  }

  LibraryData.fromBytes(Endian endianness, List<int> bytes, int offset) {
    hp = bytes.getU32(endianness, offset: offset);
    atk = bytes.getU32(endianness, offset: offset + 4);
    def = bytes.getU32(endianness, offset: offset + 8);
    mag = bytes.getU32(endianness, offset: offset + 12);
    mnd = bytes.getU32(endianness, offset: offset + 16);
    spd = bytes.getU32(endianness, offset: offset + 20);
    fir = bytes.getU32(endianness, offset: offset + 24);
    cld = bytes.getU32(endianness, offset: offset + 28);
    wnd = bytes.getU32(endianness, offset: offset + 32);
    ntr = bytes.getU32(endianness, offset: offset + 36);
    mys = bytes.getU32(endianness, offset: offset + 40);
    spi = bytes.getU32(endianness, offset: offset + 44);
    drk = bytes.getU32(endianness, offset: offset + 48);
    phy = bytes.getU32(endianness, offset: offset + 52);
  }

  LibraryData.from(LibraryData other) {
    hp = other.hp;
    atk = other.atk;
    def = other.def;
    mag = other.mag;
    mnd = other.mnd;
    spd = other.spd;
    fir = other.fir;
    cld = other.cld;
    wnd = other.wnd;
    ntr = other.ntr;
    mys = other.mys;
    spi = other.spi;
    drk = other.drk;
    phy = other.phy;
  }

  Iterable<int> toBytes(Endian endianness) {
    return <int>[
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
}
