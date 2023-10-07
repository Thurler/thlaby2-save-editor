import 'package:thlaby2_save_editor/save/enums/skill.dart';

enum Subclass {
  none(
    'None',
    skills: <Skill>[],
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  guardian(
    'Guardian',
    skills: <Skill>[],
    spells: <SubclassSpell>[
      SubclassSpell.shieldBash,
      SubclassSpell.shieldDefense,
    ],
    isUnique: false,
  ),
  monk(
    'Monk',
    skills: <Skill>[],
    spells: <SubclassSpell>[
      SubclassSpell.puncturingThrust,
      SubclassSpell.ironMountainCharge,
    ],
    isUnique: false,
  ),
  warrior(
    'Warrior',
    skills: <Skill>[],
    spells: <SubclassSpell>[
      SubclassSpell.severingFlash,
      SubclassSpell.explosiveFlameSword,
    ],
    isUnique: false,
  ),
  sorcerer(
    'Sorcerer',
    skills: <Skill>[],
    spells: <SubclassSpell>[
      SubclassSpell.penetrator,
      SubclassSpell.aspirationSurge,
    ],
    isUnique: false,
  ),
  healer(
    'Healer',
    skills: <Skill>[],
    spells: <SubclassSpell>[
      SubclassSpell.prayerRecovery,
      SubclassSpell.prayerGoodHealth,
    ],
    isUnique: false,
  ),
  enhancer(
    'Enhancer',
    skills: <Skill>[],
    spells: <SubclassSpell>[
      SubclassSpell.artBattlemage,
      SubclassSpell.ouncePrevention,
    ],
    isUnique: false,
  ),
  hexer(
    'Hexer',
    skills: <Skill>[],
    spells: <SubclassSpell>[
      SubclassSpell.hexCrimson,
      SubclassSpell.hexDark,
      SubclassSpell.hexWhite,
    ],
    isUnique: false,
  ),
  toxicologist(
    'Toxicologist',
    skills: <Skill>[],
    spells: <SubclassSpell>[
      SubclassSpell.poisonousIncense,
      SubclassSpell.paralyzingIncense,
      SubclassSpell.numbingIncense,
      SubclassSpell.deathlyIncense,
    ],
    isUnique: false,
  ),
  magician(
    'Magician',
    skills: <Skill>[],
    spells: <SubclassSpell>[
      SubclassSpell.magicTransfer,
      SubclassSpell.magicCircuit,
    ],
    isUnique: false,
  ),
  herbalist(
    'Herbalist',
    skills: <Skill>[],
    spells: <SubclassSpell>[
      SubclassSpell.placeboEffect,
      SubclassSpell.incenseTreatment,
      SubclassSpell.herbAwakening,
    ],
    isUnique: false,
  ),
  strategist(
    'Strategist',
    skills: <Skill>[],
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  gambler(
    'Gambler',
    skills: <Skill>[],
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  diva(
    'Diva',
    skills: <Skill>[],
    spells: <SubclassSpell>[
      SubclassSpell.rhythmicDance,
      SubclassSpell.danceCochlea,
    ],
    isUnique: false,
  ),
  transcendent(
    'Transcendent',
    skills: <Skill>[],
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  swordmaster(
    'Swordmaster',
    skills: <Skill>[],
    spells: <SubclassSpell>[
      SubclassSpell.severingFlash,
      SubclassSpell.explosiveFlameSword,
      SubclassSpell.moonShadowFlash,
      SubclassSpell.samidareSlash,
      SubclassSpell.swordmasterStance,
    ],
    isUnique: false,
  ),
  archmage(
    'Archmage',
    skills: <Skill>[],
    spells: <SubclassSpell>[
      SubclassSpell.penetrator,
      SubclassSpell.aspirationSurge,
      SubclassSpell.southernCross,
      SubclassSpell.execution,
      SubclassSpell.archmageChant,
    ],
    isUnique: false,
  ),
  appraiser(
    'Appraiser',
    skills: <Skill>[],
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  elementalist(
    'Elementalist',
    skills: <Skill>[],
    spells: <SubclassSpell>[
      SubclassSpell.enchantSpinel,
      SubclassSpell.enchantLazurite,
      SubclassSpell.enchantPyrope,
      SubclassSpell.enchantFluorite,
    ],
    isUnique: false,
  ),
  ninja(
    'Ninja',
    skills: <Skill>[],
    spells: <SubclassSpell>[
      SubclassSpell.assassinationSword,
      SubclassSpell.swiftSpeed,
    ],
    isUnique: false,
  ),
  oracle(
    'Oracle',
    skills: <Skill>[],
    spells: <SubclassSpell>[SubclassSpell.oracleTalisman],
    isUnique: false,
  ),
  holyblessing(
    'Holy Blessing',
    skills: <Skill>[],
    spells: <SubclassSpell>[
      SubclassSpell.ameMurakumoSlash,
      SubclassSpell.startHeavenlyDemise,
      SubclassSpell.worldShakingRule,
    ],
    isUnique: true,
  ),
  dragongodpower(
    "Dragon God's Power",
    skills: <Skill>[],
    spells: <SubclassSpell>[SubclassSpell.dragonGodSigh],
    isUnique: true,
  ),
  winner(
    '*WINNER*',
    skills: <Skill>[],
    spells: <SubclassSpell>[
      SubclassSpell.vorpalBlade,
      SubclassSpell.manaStorm,
      SubclassSpell.swordLight,
      SubclassSpell.staffDestruction,
    ],
    isUnique: true,
  );

  final String prettyName;
  final bool isUnique;
  final List<Skill> skills;
  final List<SubclassSpell> spells;

  List<Skill> get allSkills => skills + spells;

  const Subclass(
    this.prettyName, {
    required this.skills,
    required this.spells,
    required this.isUnique,
  });

  factory Subclass.fromName(String? name) {
    return Subclass.values.firstWhere(
      (Subclass s) => s.prettyName == name,
    );
  }
}
