import 'dart:typed_data';
import 'package:thlaby2_save_editor/extensions/int_extension.dart';
import 'package:thlaby2_save_editor/extensions/list_extension.dart';
import 'package:thlaby2_save_editor/save/equip.dart';
import 'package:thlaby2_save_editor/save/gem.dart';
import 'package:thlaby2_save_editor/save/levelbonus.dart';
import 'package:thlaby2_save_editor/save/library.dart';
import 'package:thlaby2_save_editor/save/skill.dart';
import 'package:thlaby2_save_editor/save/tome.dart';

enum Character {
  reimu(
    <TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.mag],
    <Skill>[
      CommonSkill.mainReimu, CommonSkill.grandIncantation,
      CommonSkill.hakureiProtection, CommonSkill.finalPrayer,
      CommonSkill.armoredOrb, CommonSkill.youkaiBuster,
      CommonSkill.fantasyBlink, CommonSkill.barrierExpert,
      CommonSkill.superYoukaiBuster,
    ],
    <Skill>[
      Spell.yinYang, Spell.fantasySeal,
      Spell.exorcisingBorder, Spell.greatBarrier,
    ],
    <Skill>[],
  ),
  marisa(
    <TomeStat>[TomeStat.mp, TomeStat.mag, TomeStat.spd],
    <Skill>[
      CommonSkill.maliceMarisa, CommonSkill.mainMarisa, CommonSkill.sheerForce,
      CommonSkill.suddenImpulse, CommonSkill.givingWings,
      CommonSkill.magicTraining, CommonSkill.hakkeroCharge,
      CommonSkill.hakkeroCustom, CommonSkill.magicDrain,
    ],
    <Skill>[
      Spell.magicMissile, Spell.asteroidBelt,
      Spell.masterSparkMarisa, Spell.concentration,
    ],
    <Skill>[],
  ),
  rinnosuke(
    <TomeStat>[
      TomeStat.mp, TomeStat.tp, TomeStat.atk,
      TomeStat.def, TomeStat.mag, TomeStat.mnd,
    ],
    <Skill>[
      CommonSkill.shopkeeper, CommonSkill.shopowner,
      CommonSkill.effectiveChange, CommonSkill.weirdCreatures,
      CommonSkill.attackDebuff, CommonSkill.magicDebuff,
      CommonSkill.murakumoOwner, CommonSkill.guts,
    ],
    <Skill>[Spell.firstAid, Spell.battleCommand],
    <Skill>[Spell.preciseDiagnosis],
  ),
  keine(
    <TomeStat>[TomeStat.mp, TomeStat.tp, TomeStat.mag],
    <Skill>[
      CommonSkill.withMokou, CommonSkill.organizedFormation,
      CommonSkill.firmDefense, CommonSkill.teacherCommand,
      CommonSkill.historianSchool, CommonSkill.historyAccumulation,
      CommonSkill.imperviousChange, CommonSkill.wereHakutaku,
      CommonSkill.createHistory,
    ],
    <Skill>[
      Spell.ancientHistory, Spell.newHistory,
      Spell.treasuresSword, Spell.treasuresMirror,
    ],
    <Skill>[],
  ),
  momiji(
    <TomeStat>[TomeStat.hp, TomeStat.atk, TomeStat.def],
    <Skill>[
      CommonSkill.seeFarDistances, CommonSkill.tenguWatchful,
      CommonSkill.accelerate, CommonSkill.perceiveReality,
      CommonSkill.instantAttack, CommonSkill.whiteWolfSwordShield,
      CommonSkill.youkaiAlliance, CommonSkill.encounterFoe,
    ],
    <Skill>[Spell.rabiesBite, Spell.expelleeCanaan],
    <Skill>[],
  ),
  youmu(
    <TomeStat>[TomeStat.atk, TomeStat.def, TomeStat.mnd],
    <Skill>[
      CommonSkill.regenerationAbility, CommonSkill.liveUnderworld,
      CommonSkill.dexterity, CommonSkill.mentalConcentration,
      CommonSkill.meikyoShisui, CommonSkill.desperation,
      CommonSkill.swordSpirit, CommonSkill.asuraBlood,
      CommonSkill.silentNirvana, CommonSkill.mistressServant,
    ],
    <Skill>[
      Spell.presentSlash, Spell.slashEternity,
      Spell.slashKarmaWind, Spell.slashSixSenses,
    ],
    <Skill>[],
  ),
  kogasa(
    <TomeStat>[TomeStat.tp, TomeStat.atk, TomeStat.eva],
    <Skill>[
      CommonSkill.surpriseHumans, CommonSkill.easygoing, CommonSkill.sheerForce,
      CommonSkill.heartPerseverance, CommonSkill.forgottenItem,
      CommonSkill.waterproofUmbrella, CommonSkill.astonishingUmbrella,
      CommonSkill.angstfreude, CommonSkill.terrorDeath,
      CommonSkill.speedyFormationChange,
    ],
    <Skill>[
      Spell.karakasaFlash, Spell.rainyGhostStory, Spell.drizzlingRaindrops,
    ],
    <Skill>[],
  ),
  rumia(
    <TomeStat>[TomeStat.mag, TomeStat.spd, TomeStat.aff],
    <Skill>[
      CommonSkill.team9, CommonSkill.realmDarkness, CommonSkill.youkaiKnowledge,
      CommonSkill.piercingAttack, CommonSkill.darknessManipulation,
      CommonSkill.greatPiercingAttack, CommonSkill.robesDarkness,
      CommonSkill.darknessYoukai, CommonSkill.proofKinship,
      CommonSkill.goingAlone,
    ],
    <Skill>[Spell.moonlightRay, Spell.darkSideMoon, Spell.demarcation],
    <Skill>[],
  ),
  cirno(
    <TomeStat>[TomeStat.tp, TomeStat.spd, TomeStat.aff],
    <Skill>[
      CommonSkill.team9, CommonSkill.risingFalling, CommonSkill.tomboyishLove,
      CommonSkill.givingWings, CommonSkill.manipulateIce,
      CommonSkill.blizzardBlowout, CommonSkill.tomboyishVengeance,
      CommonSkill.acrobaticFairy, CommonSkill.proofKinship,
      CommonSkill.goingAlone,
    ],
    <Skill>[
      Spell.icicleFall, Spell.diamondBlizzard,
      Spell.perfectFreeze, Spell.whiteAlbum,
    ],
    <Skill>[],
  ),
  minoriko(
    <TomeStat>[TomeStat.mag, TomeStat.spd, TomeStat.res],
    <Skill>[
      CommonSkill.symbolHarvest, CommonSkill.desireRest,
      CommonSkill.regenerationAbility, CommonSkill.controlHarvests,
      CommonSkill.emergencyRecovery, CommonSkill.rapidCharge,
      CommonSkill.myriadHarvest, CommonSkill.plantationBlessing,
      CommonSkill.abundanceHarvest,
    ],
    <Skill>[
      Spell.autumnSky, Spell.warmHarvest,
      Spell.sweetPotato, Spell.owotoshiHarvester,
    ],
    <Skill>[],
  ),
  komachi(
    <TomeStat>[TomeStat.hp, TomeStat.atk, TomeStat.mnd],
    <Skill>[
      CommonSkill.shinigamiWork, CommonSkill.ferryWages,
      CommonSkill.flexibility, CommonSkill.regenerationAbility,
      CommonSkill.edokkoDeath, CommonSkill.eyeForEye, CommonSkill.enmaShinigami,
      CommonSkill.shinigamiScythe, CommonSkill.slackerMotivation,
    ],
    <Skill>[
      Spell.shortExpectancy, Spell.ferriageFog,
      Spell.confinesAvici, Spell.scytheChoosesDead,
    ],
    <Skill>[],
  ),
  chen(
    <TomeStat>[TomeStat.atk, TomeStat.spd, TomeStat.eva],
    <Skill>[
      CommonSkill.yakumoClan, CommonSkill.instantAttack, CommonSkill.beatDown,
      CommonSkill.accelerate, CommonSkill.idaten, CommonSkill.screwThis,
      CommonSkill.shikigamiAccel, CommonSkill.monsterCat,
      CommonSkill.proofKinship,
    ],
    <Skill>[Spell.flightIdaten, Spell.phoenixWings, Spell.kimontonkou],
    <Skill>[],
  ),
  nitori(
    <TomeStat>[TomeStat.def, TomeStat.mnd, TomeStat.aff],
    <Skill>[
      CommonSkill.maintenance, CommonSkill.manipulateWater,
      CommonSkill.kappaObservation, CommonSkill.overheating,
      CommonSkill.coolingDown, CommonSkill.enhancedMachine,
      CommonSkill.youkaiAlliance, CommonSkill.kappaAesthetica,
    ],
    <Skill>[
      Spell.kappaWatterfall, Spell.extendingArm,
      Spell.superScope, Spell.portableMachine,
    ],
    <Skill>[],
  ),
  parsee(
    <TomeStat>[TomeStat.mp, TomeStat.mnd, TomeStat.res],
    <Skill>[
      CommonSkill.twoWayCurse, CommonSkill.finalBlow,
      CommonSkill.jealousyManipulation, CommonSkill.flamesJealousy,
      CommonSkill.emergencyRecovery, CommonSkill.jealousyBomber,
      CommonSkill.greenEyedMonster, CommonSkill.jealousyFinalBlow,
    ],
    <Skill>[
      Spell.largeSmallBox, Spell.midnightRitual,
      Spell.grudgeReturning, Spell.jealousyKindLovely,
    ],
    <Skill>[],
  ),
  wriggle(
    <TomeStat>[TomeStat.def, TomeStat.mnd, TomeStat.eva],
    <Skill>[
      CommonSkill.team9, CommonSkill.inhalePoison, CommonSkill.kodokuQueen,
      CommonSkill.toxicVaccine, CommonSkill.insectCommander,
      CommonSkill.poisonTouch, CommonSkill.fireflySwarm,
      CommonSkill.nightbugCarnival, CommonSkill.proofKinship,
      CommonSkill.goingAlone,
    ],
    <Skill>[Spell.cometEarth, Spell.fireflyPhenomenon, Spell.nightbugTornado],
    <Skill>[],
  ),
  kaguya(
    <TomeStat>[TomeStat.mp, TomeStat.mag, TomeStat.mnd],
    <Skill>[
      CommonSkill.residentsEientei, CommonSkill.royalPeopleMoon,
      CommonSkill.robeFireRat, CommonSkill.desireRest,
      CommonSkill.thousandExile, CommonSkill.lunarPower,
      CommonSkill.lunarIlmenite, CommonSkill.fiveRequests,
      CommonSkill.proofKinship,
    ],
    <Skill>[
      Spell.dragonJewel, Spell.buddhaBowl,
      Spell.swallowShell, Spell.bulletHourai,
    ],
    <Skill>[],
  ),
  mokou(
    <TomeStat>[TomeStat.hp, TomeStat.tp, TomeStat.atk],
    <Skill>[
      CommonSkill.withKeine, CommonSkill.regeneration, CommonSkill.resurrection,
      CommonSkill.blazing, CommonSkill.fightingSpirit,
      CommonSkill.moraleMaintenance, CommonSkill.sheerForce,
      CommonSkill.desperation, CommonSkill.imperishableShooting,
    ],
    <Skill>[Spell.firePhoenix, Spell.tsukiCurse, Spell.fujiyamaVolcano],
    <Skill>[],
  ),
  aya(
    <TomeStat>[TomeStat.hp, TomeStat.atk, TomeStat.eva],
    <Skill>[
      CommonSkill.quickwitted, CommonSkill.fastestLessons,
      CommonSkill.tenguWind, CommonSkill.manipulateWind, CommonSkill.extraSteps,
      CommonSkill.proofFastest, CommonSkill.tenguWatchfulEyes,
      CommonSkill.youkaiAlliance,
    ],
    <Skill>[
      Spell.windGodFan, Spell.peerlessWindGod,
      Spell.sarutahikoGuidance, Spell.divineAdvent,
    ],
    <Skill>[],
  ),
  mystia(
    <TomeStat>[TomeStat.mp, TomeStat.atk, TomeStat.spd],
    <Skill>[
      CommonSkill.team9, CommonSkill.divaDarkness, CommonSkill.singingSilence,
      CommonSkill.soothingType, CommonSkill.instantAttack,
      CommonSkill.tunnelVision, CommonSkill.deafAllSong,
      CommonSkill.proofKinship, CommonSkill.goingAlone,
    ],
    <Skill>[
      Spell.illDive, Spell.poisonousDance,
      Spell.midnightChorus, Spell.mysteriousSong,
    ],
    <Skill>[],
  ),
  kasen(
    <TomeStat>[TomeStat.hp, TomeStat.tp, TomeStat.spd],
    <Skill>[
      CommonSkill.guideAnimals, CommonSkill.guts, CommonSkill.fightingSpirit,
      CommonSkill.adversity, CommonSkill.thankfulPreaching,
      CommonSkill.impactAttack, CommonSkill.adversityPlus,
      CommonSkill.healthySpirit, CommonSkill.fourDevaOoe,
    ],
    <Skill>[
      Spell.higekiriArm, Spell.echoForestGods,
      Spell.divingWaltz, Spell.breathHermit,
    ],
    <Skill>[Spell.summonDragonTiger],
  ),
  nazrin(
    <TomeStat>[TomeStat.mnd, TomeStat.spd, TomeStat.eva],
    <Skill>[
      CommonSkill.myourenPersonnel, CommonSkill.bishamontenBlessing,
      CommonSkill.dowsing, CommonSkill.perceiveReality,
      CommonSkill.extraSteps, CommonSkill.bishamontenProtectionMag,
      CommonSkill.bishamontenProtectionSpd, CommonSkill.extraAttack,
      CommonSkill.effectiveChange, CommonSkill.tinyCommanderWisdom,
    ],
    <Skill>[Spell.goldRush, Spell.rareMetalDetector, Spell.nazrinPendulum],
    <Skill>[],
  ),
  hina(
    <TomeStat>[TomeStat.hp, TomeStat.def, TomeStat.mnd],
    <Skill>[
      CommonSkill.wardingAwayLuck, CommonSkill.twoWayCurse,
      CommonSkill.curseReversal, CommonSkill.misfortuneStockpiling,
      CommonSkill.spinningMoreUsual, CommonSkill.roleNagashiBina,
      CommonSkill.sorrowfulExiled, CommonSkill.youkaiAlliance,
      CommonSkill.cursedDoll,
    ],
    <Skill>[Spell.misfortuneBiorhythm, Spell.painFlow, Spell.oldLadyFire],
    <Skill>[],
  ),
  rin(
    <TomeStat>[TomeStat.atk, TomeStat.mag, TomeStat.spd],
    <Skill>[
      CommonSkill.earthSpiritsParty, CommonSkill.hellNecromancer,
      CommonSkill.speedyFormationChange, CommonSkill.twoWayCurse,
      CommonSkill.finalBlow, CommonSkill.extraAttack,
      CommonSkill.apparitionCarrier, CommonSkill.vengefulCatStep,
      CommonSkill.ashRekindling, CommonSkill.proofKinship,
    ],
    <Skill>[
      Spell.catWalk, Spell.vengefulSpirit,
      Spell.hellNeedleHill, Spell.blazingWheel,
    ],
    <Skill>[],
  ),
  utsuho(
    <TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.mag],
    <Skill>[
      CommonSkill.earthSpiritsParty, CommonSkill.blazing,
      CommonSkill.overheating, CommonSkill.fightingSpirit,
      CommonSkill.sheerForce, CommonSkill.selfTokamak, CommonSkill.highBlazing,
      CommonSkill.proofKinship,
    ],
    <Skill>[Spell.gigaFlare, Spell.nuclearReaction, Spell.hellTokamak],
    <Skill>[],
  ),
  satori(
    <TomeStat>[TomeStat.mp, TomeStat.atk, TomeStat.mag],
    <Skill>[
      CommonSkill.earthSpiritsParty, CommonSkill.perceiveReality,
      CommonSkill.smallMpRecovery, CommonSkill.traumaRecollection,
      CommonSkill.spellRecollection, CommonSkill.traumaRecreation,
      CommonSkill.terrifyingHypnotism, CommonSkill.proofKinship,
    ],
    <Skill>[Spell.brainFingerprint],
    <Skill>[],
  ),
  yuugi(
    <TomeStat>[TomeStat.hp, TomeStat.atk, TomeStat.def],
    <Skill>[
      CommonSkill.physicalCounter, CommonSkill.lastFortress,
      CommonSkill.beatDown, CommonSkill.ruinousStrength,
      CommonSkill.hoshigumaDish, CommonSkill.adamantHelix,
      CommonSkill.dreadfulWaves, CommonSkill.ablityPhenomena,
      CommonSkill.lastFortressPlus, CommonSkill.fourDevaOoe,
    ],
    <Skill>[
      Spell.supernaturalPhenomenon, Spell.koThreeSteps,
      Spell.irremovableShackles,
    ],
    <Skill>[],
  ),
  meiling(
    <TomeStat>[TomeStat.tp, TomeStat.def, TomeStat.mnd],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  alice(
    <TomeStat>[TomeStat.hp, TomeStat.mag, TomeStat.mnd],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  patchouli(
    <TomeStat>[TomeStat.mp, TomeStat.mag, TomeStat.aff],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  eirin(
    <TomeStat>[TomeStat.hp, TomeStat.mag, TomeStat.res],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  reisen(
    <TomeStat>[TomeStat.mp, TomeStat.mag, TomeStat.spd],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  sanae(
    <TomeStat>[TomeStat.def, TomeStat.mag, TomeStat.mnd],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  iku(
    <TomeStat>[TomeStat.hp, TomeStat.def, TomeStat.mag],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  suika(
    <TomeStat>[TomeStat.atk, TomeStat.mnd, TomeStat.res],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  ran(
    <TomeStat>[TomeStat.mp, TomeStat.mag, TomeStat.spd],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  remilia(
    <TomeStat>[TomeStat.hp, TomeStat.atk, TomeStat.spd],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  sakuya(
    <TomeStat>[TomeStat.mp, TomeStat.atk, TomeStat.spd],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  kanako(
    <TomeStat>[TomeStat.hp, TomeStat.def, TomeStat.mag],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  suwako(
    <TomeStat>[TomeStat.mp, TomeStat.atk, TomeStat.mag],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  tenshi(
    <TomeStat>[TomeStat.tp, TomeStat.aff, TomeStat.res],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  flandre(
    <TomeStat>[TomeStat.mp, TomeStat.atk, TomeStat.mag],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  yuyuko(
    <TomeStat>[TomeStat.mp, TomeStat.mag, TomeStat.spd],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  yuuka(
    <TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.mag],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  yukari(
    <TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.mnd],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  byakuren(
    <TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.spd],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  eiki(
    <TomeStat>[TomeStat.atk, TomeStat.mag, TomeStat.mnd],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  renko(
    <TomeStat>[TomeStat.spd, TomeStat.eva, TomeStat.res],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  maribel(
    <TomeStat>[TomeStat.mp, TomeStat.tp, TomeStat.mag],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  shou(
    <TomeStat>[TomeStat.hp, TomeStat.def, TomeStat.mnd],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  mamizou(
    <TomeStat>[TomeStat.mp, TomeStat.tp, TomeStat.eva],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  futo(
    <TomeStat>[TomeStat.tp, TomeStat.atk, TomeStat.res],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  miko(
    <TomeStat>[TomeStat.hp, TomeStat.mag, TomeStat.aff],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  kokoro(
    <TomeStat>[TomeStat.atk, TomeStat.def, TomeStat.mag, TomeStat.mnd],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  tokiko(
    <TomeStat>[
      TomeStat.atk, TomeStat.def, TomeStat.mag, TomeStat.mnd, TomeStat.spd,
    ],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  koishi(
    <TomeStat>[TomeStat.mp, TomeStat.mnd, TomeStat.eva],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  ),
  akyuu(
    <TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp],
    <Skill>[],
    <Skill>[],
    <Skill>[],
  );

  final List<TomeStat> naturalTomeStats;
  final List<Skill> skills;
  final List<Skill> spells;
  final List<Skill> awakeningSpells;

  const Character(
    this.naturalTomeStats, this.skills, this.spells, this.awakeningSpells,
  );

  bool isNaturalTomeStat(TomeStat stat) => naturalTomeStats.contains(stat);

  List<String> tomeDropdownOptions(TomeStat stat) {
    List<TomeLevel> levels = <TomeLevel>[TomeLevel.unused];
    bool isNatural = isNaturalTomeStat(stat);
    if (!isNatural) {
      levels.add(TomeLevel.insight);
    }
    if (stat.multiLevel && isNatural) {
      if (this != rinnosuke) {
        levels.add(TomeLevel.spartanNatural);
      }
      levels.add(TomeLevel.veteranNatural);
    } else if (stat.multiLevel) {
      if (this != rinnosuke) {
        levels.add(TomeLevel.spartan);
      }
      levels.add(TomeLevel.veteran);
    }
    return levels.map((TomeLevel l) => l.name).toList();
  }
}

enum Subclass {
  none('None', isUnique: false),
  guardian('Guardian', isUnique: false),
  monk('Monk', isUnique: false),
  warrior('Warrior', isUnique: false),
  sorcerer('Sorcerer', isUnique: false),
  healer('Healer', isUnique: false),
  enhancer('Enhancer', isUnique: false),
  hexer('Hexer', isUnique: false),
  toxicologist('Toxicologist', isUnique: false),
  magician('Magician', isUnique: false),
  herbalist('Herbalist', isUnique: false),
  strategist('Strategist', isUnique: false),
  gambler('Gambler', isUnique: false),
  diva('Diva', isUnique: false),
  transcendent('Transcendent', isUnique: false),
  swordmaster('Swordmaster', isUnique: false),
  archmage('Archmage', isUnique: false),
  appraiser('Appraiser', isUnique: false),
  elementalist('Elementalist', isUnique: false),
  ninja('Ninja', isUnique: false),
  oracle('Oracle', isUnique: false),
  holyblessing('Holy Blessing', isUnique: true),
  dragongodpower("Dragon God's Power", isUnique: true),
  winner('*WINNER*', isUnique: true);

  final String prettyName;
  final bool isUnique;

  const Subclass(this.prettyName, {required this.isUnique});
}

class CharacterData {
  late Character character;
  late int level;
  late int unusedSkillPoints;
  late int unusedBonusPoints;
  late int usedManuals;
  late int bp;
  late BigInt experience;
  late Subclass subclass;
  late LibraryData libraryLevels;
  late LevelBonus levelBonus;
  late SkillData skills;
  late TomeData tomes;
  late GemData gems;
  late MainEquip mainEquip;
  late List<SubEquip> subEquips;

  bool get isKourin => character == Character.rinnosuke;

  Skill _getSkill(TomeLevel tomeLevel, List<Skill?> skills) {
    // Order is regular / 2 / mega / high / giga
    Skill defaultSkill = skills.elementAt(0)!; // Regular always has everything
    Skill? result;
    if (tomeLevel.index < TomeLevel.spartanNatural.index) {
      result = isKourin ? skills.elementAt(3) : skills.elementAt(0);
    } else if (tomeLevel.index < TomeLevel.veteranNatural.index) {
      result = skills.elementAt(1);
    } else {
      result = isKourin ? skills.elementAt(4) : skills.elementAt(2);
    }
    return result ?? defaultSkill;
  }

  List<Skill?> _boostSkills(int index) {
    return <Skill?>[
      BoostSkill.values.elementAtSafe(index),
      Boost2Skill.values.elementAtSafe(index),
      BoostMegaSkill.values.elementAtSafe(index),
      BoostHighSkill.values.elementAtSafe(index),
      BoostGigaSkill.values.elementAtSafe(index),
    ];
  }

  List<Skill> getCommonSkills(Iterable<String> tomeSelections) {
    List<Skill> commonSkills = <Skill>[];
    for (int i = 0; i < tomeSelections.length; i++) {
      TomeLevel level = TomeData.levelFromString(
        tomeSelections.elementAt(i),
        isNatural: character.isNaturalTomeStat(TomeStat.values.elementAt(i)),
      );
      commonSkills.add(_getSkill(level, _boostSkills(i)));
    }
    return commonSkills;
  }

  CharacterData.fromBytes({
    required Endian endianness,
    required int index,
    required List<int> bytes,
  }) {
    character = Character.values.elementAt(index);
    level = bytes.getU32(endianness);
    experience = bytes.getU64(endianness, offset: 0x4);
    libraryLevels = LibraryData.fromBytes(endianness, bytes, 0xc);
    levelBonus = LevelBonus.fromBytes(endianness, bytes, 0x44);
    subclass = Subclass.values.elementAt(
      bytes[0x5c] > 0 ? bytes[0x5c] - 99 : 0,
    );
    skills = SkillData.fromBytes(bytes, 0x60);
    tomes = TomeData.fromBytes(bytes, 0xd8);
    unusedSkillPoints = bytes.getI16(endianness, offset: 0xec);
    unusedBonusPoints = bytes.getI32(endianness, offset: 0xee);
    gems = GemData.fromBytes(bytes, 0xf2);
    usedManuals = bytes[0x102];
    bp = bytes.getU32(endianness, offset: 0x103);
    mainEquip = MainEquip.values.elementAt(
      bytes.getU16(endianness, offset: 0x107),
    );
    subEquips = <SubEquip>[];
    for (int i = 0; i < 3; i++) {
      int id = bytes.getU16(endianness, offset: 0x109 + (i * 2));
      subEquips.add(SubEquip.values.elementAt(id > 0 ? id - 200 : 0));
    }
  }

  CharacterData.from(CharacterData other) {
    character = other.character;
    level = other.level;
    unusedSkillPoints = other.unusedSkillPoints;
    unusedBonusPoints = other.unusedBonusPoints;
    usedManuals = other.usedManuals;
    bp = other.bp;
    experience = other.experience;
    subclass = other.subclass;
    libraryLevels = LibraryData.from(other.libraryLevels);
    levelBonus = LevelBonus.from(other.levelBonus);
    skills = SkillData.from(other.skills);
    tomes = TomeData.from(other.tomes);
    gems = GemData.from(other.gems);
    mainEquip = other.mainEquip;
    subEquips = List<SubEquip>.from(other.subEquips);
  }

  Iterable<int> toBytes(Endian endianness) {
    Iterable<int> bytes = <int>[];
    bytes = bytes.followedBy(level.toU32(endianness));
    bytes = bytes.followedBy(experience.toU64(endianness));
    bytes = bytes.followedBy(libraryLevels.toBytes(endianness));
    bytes = bytes.followedBy(levelBonus.toBytes(endianness));
    int subclassIndex = (subclass != Subclass.none) ? subclass.index + 99 : 0;
    bytes = bytes.followedBy(subclassIndex.toU32(endianness));
    bytes = bytes.followedBy(skills.toBytes(endianness));
    bytes = bytes.followedBy(tomes.toBytes(endianness));
    bytes = bytes.followedBy(unusedSkillPoints.toI16(endianness));
    bytes = bytes.followedBy(unusedBonusPoints.toI32(endianness));
    bytes = bytes.followedBy(gems.toBytes(endianness));
    bytes = bytes.followedBy(<int>[usedManuals]);
    bytes = bytes.followedBy(bp.toU32(endianness));
    bytes = bytes.followedBy(mainEquip.toBytes(endianness));
    for (SubEquip equip in subEquips) {
      bytes = bytes.followedBy(equip.toBytes(endianness));
    }
    return bytes;
  }

  @override
  String toString() {
    return character.name;
  }
}
