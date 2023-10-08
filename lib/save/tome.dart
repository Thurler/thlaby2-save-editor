import 'dart:typed_data';

enum TomeStat {
  hp('HP', multiLevel: true),
  mp('MP', multiLevel: true),
  tp('TP', multiLevel: true),
  atk('ATK', multiLevel: true),
  def('DEF', multiLevel: true),
  mag('MAG', multiLevel: true),
  mnd('MND', multiLevel: true),
  spd('SPD', multiLevel: true),
  eva('EVA', multiLevel: false),
  acc('ACC', multiLevel: false),
  aff('Affinity', multiLevel: false),
  res('Resistance', multiLevel: false);

  final String name;
  final bool multiLevel;

  const TomeStat(this.name, {required this.multiLevel});
}

enum TomeLevel {
  unused(0, 0, 'Not used'),
  insight(1, 0, 'Insight'),
  spartanNatural(0, 2, 'Spartan'),
  spartan(1, 2, 'Spartan'),
  veteranNatural(0, 3, 'Veteran'),
  veteran(1, 3, 'Veteran');

  final int flag;
  final int level;
  final String name;

  const TomeLevel(this.flag, this.level, this.name);
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

  static TomeLevel levelFromString(String value, {required bool isNatural}) {
    Iterable<TomeLevel> matches = TomeLevel.values.where(
      (TomeLevel l) => l.name == value,
    );
    if (matches.length > 1) {
      return matches.firstWhere((TomeLevel l) => l.flag == (isNatural ? 0 : 1));
    }
    return matches.first;
  }

  TomeLevel getStatData(int index) {
    return <TomeLevel>[
      hp,
      mp,
      tp,
      atk,
      def,
      mag,
      mnd,
      spd,
      eva,
      acc,
      aff,
      res,
    ][index];
  }

  void setStatData(int index, String raw, {required bool isNatural}) {
    TomeLevel value = levelFromString(raw, isNatural: isNatural);
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
      case 8: eva = value;
      break;
      case 9: acc = value;
      break;
      case 10: aff = value;
      break;
      case 11: res = value;
      break;
    }
  }

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
