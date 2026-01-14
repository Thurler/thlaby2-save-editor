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

  final String prettyName;
  final bool multiLevel;

  const TomeStat(this.prettyName, {this.multiLevel = true});
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
  final String prettyName;

  const TomeLevel(this.flag, this.level, this.prettyName);

  factory TomeLevel.fromBytes(int flag, int level) => switch (level) {
    0 => flag > 0 ? insight : unused,
    2 => flag > 0 ? spartan : spartanNatural,
    _ => flag > 0 ? veteran : veteranNatural,
  };
}

class TomeData {
  static const String lockedMessage = 'Needs a Tome of Insight to unlock';

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

  TomeData({
    required this.hp,
    required this.mp,
    required this.tp,
    required this.atk,
    required this.def,
    required this.mag,
    required this.mnd,
    required this.spd,
    required this.eva,
    required this.acc,
    required this.aff,
    required this.res,
  });

  TomeData.fromBytes(Uint8List bytes, int offset) :
    hp = TomeLevel.fromBytes(bytes[offset], bytes[offset + 12]),
    mp = TomeLevel.fromBytes(bytes[offset + 1], bytes[offset + 13]),
    tp = TomeLevel.fromBytes(bytes[offset + 2], bytes[offset + 14]),
    atk = TomeLevel.fromBytes(bytes[offset + 3], bytes[offset + 15]),
    def = TomeLevel.fromBytes(bytes[offset + 4], bytes[offset + 16]),
    mag = TomeLevel.fromBytes(bytes[offset + 5], bytes[offset + 17]),
    mnd = TomeLevel.fromBytes(bytes[offset + 6], bytes[offset + 18]),
    spd = TomeLevel.fromBytes(bytes[offset + 7], bytes[offset + 19]),
    eva = TomeLevel.fromBytes(bytes[offset + 8], 0),
    acc = TomeLevel.fromBytes(bytes[offset + 9], 0),
    aff = TomeLevel.fromBytes(bytes[offset + 10], 0),
    res = TomeLevel.fromBytes(bytes[offset + 11], 0);

  Iterable<int> toBytes(Endian endianness) {
    List<TomeLevel> stats = <TomeLevel>[hp, mp, tp, atk, def, mag, mnd, spd];
    List<TomeLevel> extra = <TomeLevel>[eva, acc, aff, res];
    return (stats + extra).map((TomeLevel stat) => stat.flag).followedBy(
      stats.map((TomeLevel stat) => stat.level),
    );
  }
}
