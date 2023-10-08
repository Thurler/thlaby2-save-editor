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
    skills: <Skill>[
      CommonSkill.guardianMastery,
      CommonSkill.frontlineGuard,
      CommonSkill.initiative,
      CommonSkill.absoluteDefensiveLine,
      CommonSkill.efficientConcentration,
    ],
    spells: <SubclassSpell>[
      SubclassSpell.shieldBash,
      SubclassSpell.shieldDefense,
    ],
    isUnique: false,
  ),
  monk(
    'Monk',
    skills: <Skill>[
      CommonSkill.monkMastery,
      CommonSkill.bodyRevitalization,
      CommonSkill.fastDash,
      CommonSkill.dexterityTraining,
      CommonSkill.areaNormalAttack,
    ],
    spells: <SubclassSpell>[
      SubclassSpell.puncturingThrust,
      SubclassSpell.ironMountainCharge,
    ],
    isUnique: false,
  ),
  warrior(
    'Warrior',
    skills: <Skill>[
      CommonSkill.warriorMastery,
      CommonSkill.tensionUp,
      CommonSkill.fastAttack,
      CommonSkill.enhancedNormalAttack,
      CommonSkill.mindBodyOne,
      CommonSkill.enhancedRowAttack,
    ],
    spells: <SubclassSpell>[
      SubclassSpell.severingFlash,
      SubclassSpell.explosiveFlameSword,
    ],
    isUnique: false,
  ),
  sorcerer(
    'Sorcerer',
    skills: <Skill>[
      CommonSkill.sorcererMastery,
      CommonSkill.magicBeating,
      CommonSkill.mindAssault,
      CommonSkill.enhancedNormalAttack,
      CommonSkill.mindBodyOne,
      CommonSkill.enhancedRowAttack,
    ],
    spells: <SubclassSpell>[
      SubclassSpell.penetrator,
      SubclassSpell.aspirationSurge,
    ],
    isUnique: false,
  ),
  healer(
    'Healer',
    skills: <Skill>[
      CommonSkill.healerMastery,
      CommonSkill.efficientTreatment,
      CommonSkill.highLevelTreatment,
      CommonSkill.emergencyTreatment,
      CommonSkill.devotedCare,
    ],
    spells: <SubclassSpell>[
      SubclassSpell.prayerRecovery,
      SubclassSpell.prayerGoodHealth,
    ],
    isUnique: false,
  ),
  enhancer(
    'Enhancer',
    skills: <Skill>[
      CommonSkill.enhancerMastery,
      CommonSkill.heartCompassion,
      CommonSkill.heartPrayers,
      CommonSkill.enhancedBuffing,
    ],
    spells: <SubclassSpell>[
      SubclassSpell.artBattlemage,
      SubclassSpell.ouncePrevention,
    ],
    isUnique: false,
  ),
  hexer(
    'Hexer',
    skills: <Skill>[
      CommonSkill.hexerMastery,
      CommonSkill.enhancedHexes,
      CommonSkill.hexerDefense,
      CommonSkill.hexerConversion,
    ],
    spells: <SubclassSpell>[
      SubclassSpell.hexCrimson,
      SubclassSpell.hexDark,
      SubclassSpell.hexWhite,
    ],
    isUnique: false,
  ),
  toxicologist(
    'Toxicologist',
    skills: <Skill>[
      CommonSkill.toxicologistMastery,
      CommonSkill.enhancedToxins,
      CommonSkill.toxicDefense,
      CommonSkill.toxinConversion,
    ],
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
    skills: <Skill>[
      CommonSkill.magicianMastery,
      CommonSkill.magicSufficiency,
      CommonSkill.magicConservation,
      CommonSkill.entrustedWill,
    ],
    spells: <SubclassSpell>[
      SubclassSpell.magicTransfer,
      SubclassSpell.magicCircuit,
    ],
    isUnique: false,
  ),
  herbalist(
    'Herbalist',
    skills: <Skill>[
      CommonSkill.herbalistMastery,
      CommonSkill.medicinalFragrance,
      CommonSkill.morningDewHerbs,
    ],
    spells: <SubclassSpell>[
      SubclassSpell.placeboEffect,
      SubclassSpell.incenseTreatment,
      SubclassSpell.herbAwakening,
    ],
    isUnique: false,
  ),
  strategist(
    'Strategist',
    skills: <Skill>[
      CommonSkill.strategistMastery,
      CommonSkill.inspirationalPlan,
      CommonSkill.furiousScheme,
      CommonSkill.ironcladStrategy,
      CommonSkill.raidManeuver,
    ],
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  gambler(
    'Gambler',
    skills: <Skill>[
      CommonSkill.gamblerMastery,
      CommonSkill.highStakes,
      CommonSkill.allOrNothing,
    ],
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  diva(
    'Diva',
    skills: <Skill>[
      CommonSkill.divaMastery,
      CommonSkill.songDelight,
      CommonSkill.silentMelody,
      CommonSkill.melodyFortune,
    ],
    spells: <SubclassSpell>[
      SubclassSpell.rhythmicDance,
      SubclassSpell.danceCochlea,
    ],
    isUnique: false,
  ),
  transcendent(
    'Transcendent',
    skills: <Skill>[
      CommonSkill.transcendentMastery,
      CommonSkill.bodyReinforcement,
      CommonSkill.enhancedCombat,
    ],
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  swordmaster(
    'Swordmaster',
    skills: <Skill>[
      CommonSkill.swordmasterMastery,
      CommonSkill.asuraStance,
    ],
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
    skills: <Skill>[
      CommonSkill.archmageMastery,
      CommonSkill.welcomeSpirituality,
    ],
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
    skills: <Skill>[
      CommonSkill.appraiserMastery,
      CommonSkill.dailyToils,
      CommonSkill.basicsBusiness,
      CommonSkill.aestheticSense,
      CommonSkill.killBonusExp,
      CommonSkill.killBonusMoney,
      CommonSkill.killBonusDrops,
    ],
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  elementalist(
    'Elementalist',
    skills: <Skill>[
      CommonSkill.elementalistMastery,
      CommonSkill.elementMemoryDefense,
      CommonSkill.elementAreaDefense,
    ],
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
    skills: <Skill>[
      CommonSkill.ninjaMastery,
      CommonSkill.armorPierce,
      CommonSkill.ironOxideCaltrops,
      CommonSkill.lacqueredSpikedKnuckles,
      CommonSkill.ruffianKnowledge,
    ],
    spells: <SubclassSpell>[
      SubclassSpell.assassinationSword,
      SubclassSpell.swiftSpeed,
    ],
    isUnique: false,
  ),
  oracle(
    'Oracle',
    skills: <Skill>[
      CommonSkill.oracleMastery,
      CommonSkill.fakeOracleMachine,
      CommonSkill.ecstaticalCeremony,
      CommonSkill.prophetPrediction,
      CommonSkill.heavenlyRevelation,
      CommonSkill.worldLinkingIntuition,
    ],
    spells: <SubclassSpell>[SubclassSpell.oracleTalisman],
    isUnique: false,
  ),
  holyblessing(
    'Holy Blessing',
    skills: <Skill>[
      CommonSkill.holyBlessing,
      CommonSkill.oneOfThreeTreasures,
      CommonSkill.ninigiSwordSheath,
      CommonSkill.powerSupremeRuler,
      CommonSkill.threeLegendarySwords,
    ],
    spells: <SubclassSpell>[
      SubclassSpell.ameMurakumoSlash,
      SubclassSpell.startHeavenlyDemise,
      SubclassSpell.worldShakingRule,
    ],
    isUnique: true,
  ),
  dragongodpower(
    "Dragon God's Power",
    skills: <Skill>[
      CommonSkill.dragonGodPower,
      CommonSkill.elementalProtection,
      CommonSkill.flameBlessing,
      CommonSkill.woodBlessing,
      CommonSkill.waterBlessing,
      CommonSkill.earthBlessing,
      CommonSkill.metalBlessing,
    ],
    spells: <SubclassSpell>[SubclassSpell.dragonGodSigh],
    isUnique: true,
  ),
  winner(
    '*WINNER*',
    skills: <Skill>[
      CommonSkill.winnerTitle,
      CommonSkill.autoRoller,
      CommonSkill.elementalImmunity,
      CommonSkill.magicArmor,
    ],
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
