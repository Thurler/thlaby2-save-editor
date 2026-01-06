import 'dart:typed_data';

enum TomeStat {
  hp('HP'),
  mp('MP'),
  tp('TP'),
  atk('ATK'),
  def('DEF'),
  mag('MAG'),
  mnd('MND'),
  spd('SPD'),
  eva('EVA', multiLevel: false),
  acc('ACC', multiLevel: false),
  aff('Affinity', multiLevel: false),
  res('Resistance', multiLevel: false);

  final String name;
  final bool multiLevel;

  const TomeStat(this.name, {this.multiLevel = true});
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
  TomeLevel hp;
  TomeLevel mp;
  TomeLevel tp;
  TomeLevel atk;
  TomeLevel def;
  TomeLevel mag;
  TomeLevel mnd;
  TomeLevel spd;
  TomeLevel eva;
  TomeLevel acc;
  TomeLevel aff;
  TomeLevel res;

  static TomeLevel levelFromString(String value, {required bool isNatural}) {
    Iterable<TomeLevel> matches = TomeLevel.values.where(
      (TomeLevel l) => l.name == value,
    );
    if (matches.length > 1) {
      return matches.firstWhere((TomeLevel l) => l.flag == (isNatural ? 0 : 1));
    }
    return matches.first;
  }

  TomeLevel getStatData(int index) => <TomeLevel>[
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

  static TomeLevel _levelFromBytes(int flag, int level) => switch (level) {
    0 => flag > 0 ? TomeLevel.insight : TomeLevel.unused,
    2 => flag > 0 ? TomeLevel.spartan : TomeLevel.spartanNatural,
    _ => flag > 0 ? TomeLevel.veteran : TomeLevel.veteranNatural,
  };

  TomeData.fromBytes(Uint8List bytes, int offset) :
    hp = _levelFromBytes(bytes[offset], bytes[offset + 12]),
    mp = _levelFromBytes(bytes[offset + 1], bytes[offset + 13]),
    tp = _levelFromBytes(bytes[offset + 2], bytes[offset + 14]),
    atk = _levelFromBytes(bytes[offset + 3], bytes[offset + 15]),
    def = _levelFromBytes(bytes[offset + 4], bytes[offset + 16]),
    mag = _levelFromBytes(bytes[offset + 5], bytes[offset + 17]),
    mnd = _levelFromBytes(bytes[offset + 6], bytes[offset + 18]),
    spd = _levelFromBytes(bytes[offset + 7], bytes[offset + 19]),
    eva = _levelFromBytes(bytes[offset + 8], 0),
    acc = _levelFromBytes(bytes[offset + 9], 0),
    aff = _levelFromBytes(bytes[offset + 10], 0),
    res = _levelFromBytes(bytes[offset + 11], 0);

  TomeData.from(TomeData other) :
    hp = other.hp,
    mp = other.mp,
    tp = other.tp,
    atk = other.atk,
    def = other.def,
    mag = other.mag,
    mnd = other.mnd,
    spd = other.spd,
    eva = other.eva,
    acc = other.acc,
    aff = other.aff,
    res = other.res;

  Iterable<int> toBytes(Endian endianness) {
    List<TomeLevel> stats = <TomeLevel>[hp, mp, tp, atk, def, mag, mnd, spd];
    List<TomeLevel> extra = <TomeLevel>[eva, acc, aff, res];
    return (stats + extra).map((TomeLevel stat) => stat.flag).followedBy(
      stats.map((TomeLevel stat) => stat.level),
    );
  }
}
