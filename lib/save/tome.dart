import 'dart:typed_data';

enum TomeLevel {
  unused(0, 0),
  insight(1, 0),
  spartanNatural(0, 2),
  spartan(1, 2),
  veteranNatural(0, 3),
  veteran(1, 3);

  final int flag;
  final int level;

  const TomeLevel(this.flag, this.level);
}

class TomeData {
  late TomeLevel hp;
  late TomeLevel mp;
  late TomeLevel tp;
  late TomeLevel atk;
  late TomeLevel def;
  late TomeLevel mag;
  late TomeLevel mnd;
  late TomeLevel spd;
  late TomeLevel eva;
  late TomeLevel acc;
  late TomeLevel aff;
  late TomeLevel res;

  TomeLevel _levelFromBytes(int flag, int level) {
    bool flagSet = flag > 0;
    if (level == 0) {
      return flagSet ? TomeLevel.insight : TomeLevel.unused;
    } else if (level == 2) {
      return flagSet ? TomeLevel.spartan : TomeLevel.spartanNatural;
    } else {
      return flagSet ? TomeLevel.veteran : TomeLevel.veteranNatural;
    }
  }

  TomeData.fromBytes(List<int> bytes, int offset) {
    hp = _levelFromBytes(bytes[offset], bytes[offset + 12]);
    mp = _levelFromBytes(bytes[offset + 1], bytes[offset + 13]);
    tp = _levelFromBytes(bytes[offset + 2], bytes[offset + 14]);
    atk = _levelFromBytes(bytes[offset + 3], bytes[offset + 15]);
    def = _levelFromBytes(bytes[offset + 4], bytes[offset + 16]);
    mag = _levelFromBytes(bytes[offset + 5], bytes[offset + 17]);
    mnd = _levelFromBytes(bytes[offset + 6], bytes[offset + 18]);
    spd = _levelFromBytes(bytes[offset + 7], bytes[offset + 19]);
    eva = _levelFromBytes(bytes[offset + 8], 0);
    acc = _levelFromBytes(bytes[offset + 9], 0);
    aff = _levelFromBytes(bytes[offset + 10], 0);
    res = _levelFromBytes(bytes[offset + 11], 0);
  }

  TomeData.from(TomeData other) {
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
    List<TomeLevel> stats = <TomeLevel>[hp, mp, tp, atk, def, mag, mnd, spd];
    List<TomeLevel> extra = <TomeLevel>[eva, acc, aff, res];
    return (stats + extra).map((TomeLevel stat) => stat.flag).followedBy(
      stats.map((TomeLevel stat) => stat.level),
    );
  }
}
