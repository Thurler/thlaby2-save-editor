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
    'Reimu',
    <TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.mag],
    <Skill>[
      CommonSkill.mainReimu,
      CommonSkill.grandIncantation,
      CommonSkill.hakureiProtection,
      CommonSkill.finalPrayer,
      CommonSkill.armoredOrb,
      CommonSkill.youkaiBuster,
      CommonSkill.fantasyBlink,
      CommonSkill.barrierExpert,
      CommonSkill.superYoukaiBuster,
    ],
    <Skill>[
      Spell.yinYang,
      Spell.fantasySeal,
      Spell.exorcisingBorder,
      Spell.greatBarrier,
    ],
    <Skill>[],
  ),
  marisa(
    'Marisa',
    <TomeStat>[TomeStat.mp, TomeStat.mag, TomeStat.spd],
    <Skill>[
      CommonSkill.maliceMarisa,
      CommonSkill.mainMarisa,
      CommonSkill.sheerForce,
      CommonSkill.suddenImpulse,
      CommonSkill.givingWings,
      CommonSkill.magicTraining,
      CommonSkill.hakkeroCharge,
      CommonSkill.hakkeroCustom,
      CommonSkill.magicDrain,
    ],
    <Skill>[
      Spell.magicMissile,
      Spell.asteroidBelt,
      Spell.masterSparkMarisa,
      Spell.concentration,
    ],
    <Skill>[],
  ),
  rinnosuke(
    'Kourin',
    <TomeStat>[
      TomeStat.mp,
      TomeStat.tp,
      TomeStat.atk,
      TomeStat.def,
      TomeStat.mag,
      TomeStat.mnd,
    ],
    <Skill>[
      CommonSkill.shopkeeper,
      CommonSkill.shopowner,
      CommonSkill.effectiveChange,
      CommonSkill.weirdCreatures,
      CommonSkill.attackDebuff,
      CommonSkill.magicDebuff,
      CommonSkill.murakumoOwner,
      CommonSkill.guts,
    ],
    <Skill>[Spell.firstAid, Spell.battleCommand],
    <Skill>[Spell.preciseDiagnosis],
  ),
  keine(
    'Keine',
    <TomeStat>[TomeStat.mp, TomeStat.tp, TomeStat.mag],
    <Skill>[
      CommonSkill.withMokou,
      CommonSkill.organizedFormation,
      CommonSkill.firmDefense,
      CommonSkill.teacherCommand,
      CommonSkill.historianSchool,
      CommonSkill.historyAccumulation,
      CommonSkill.imperviousChange,
      CommonSkill.wereHakutaku,
      CommonSkill.createHistory,
    ],
    <Skill>[
      Spell.ancientHistory,
      Spell.newHistory,
      Spell.treasuresSword,
      Spell.treasuresMirror,
    ],
    <Skill>[],
  ),
  momiji(
    'Momiji',
    <TomeStat>[TomeStat.hp, TomeStat.atk, TomeStat.def],
    <Skill>[
      CommonSkill.seeFarDistances,
      CommonSkill.tenguWatchful,
      CommonSkill.accelerate,
      CommonSkill.perceiveReality,
      CommonSkill.instantAttack,
      CommonSkill.whiteWolfSwordShield,
      CommonSkill.youkaiAlliance,
      CommonSkill.encounterFoe,
    ],
    <Skill>[Spell.rabiesBite, Spell.expelleeCanaan],
    <Skill>[],
  ),
  youmu(
    'Youmu',
    <TomeStat>[TomeStat.atk, TomeStat.def, TomeStat.mnd],
    <Skill>[
      CommonSkill.regenerationAbility,
      CommonSkill.liveUnderworld,
      CommonSkill.dexterity,
      CommonSkill.mentalConcentration,
      CommonSkill.meikyoShisui,
      CommonSkill.desperation,
      CommonSkill.swordSpirit,
      CommonSkill.asuraBlood,
      CommonSkill.silentNirvana,
      CommonSkill.mistressServant,
    ],
    <Skill>[
      Spell.presentSlash,
      Spell.slashEternity,
      Spell.slashKarmaWind,
      Spell.slashSixSenses,
    ],
    <Skill>[],
  ),
  kogasa(
    'Kogasa',
    <TomeStat>[TomeStat.tp, TomeStat.atk, TomeStat.eva],
    <Skill>[
      CommonSkill.surpriseHumans,
      CommonSkill.easygoing,
      CommonSkill.sheerForce,
      CommonSkill.heartPerseverance,
      CommonSkill.forgottenItem,
      CommonSkill.waterproofUmbrella,
      CommonSkill.astonishingUmbrella,
      CommonSkill.angstfreude,
      CommonSkill.terrorDeath,
      CommonSkill.speedyFormationChange,
    ],
    <Skill>[
      Spell.karakasaFlash,
      Spell.rainyGhostStory,
      Spell.drizzlingRaindrops,
    ],
    <Skill>[],
  ),
  rumia(
    'Rumia',
    <TomeStat>[TomeStat.mag, TomeStat.spd, TomeStat.aff],
    <Skill>[
      CommonSkill.team9,
      CommonSkill.realmDarkness,
      CommonSkill.youkaiKnowledge,
      CommonSkill.piercingAttack,
      CommonSkill.darknessManipulation,
      CommonSkill.greatPiercingAttack,
      CommonSkill.robesDarkness,
      CommonSkill.darknessYoukai,
      CommonSkill.proofKinship,
      CommonSkill.goingAlone,
    ],
    <Skill>[Spell.moonlightRay, Spell.darkSideMoon, Spell.demarcation],
    <Skill>[],
  ),
  cirno(
    'Cirno',
    <TomeStat>[TomeStat.tp, TomeStat.spd, TomeStat.aff],
    <Skill>[
      CommonSkill.team9,
      CommonSkill.risingFalling,
      CommonSkill.tomboyishLove,
      CommonSkill.givingWings,
      CommonSkill.manipulateIce,
      CommonSkill.blizzardBlowout,
      CommonSkill.tomboyishVengeance,
      CommonSkill.acrobaticFairy,
      CommonSkill.proofKinship,
      CommonSkill.goingAlone,
    ],
    <Skill>[
      Spell.icicleFall,
      Spell.diamondBlizzard,
      Spell.perfectFreeze,
      Spell.whiteAlbum,
    ],
    <Skill>[],
  ),
  minoriko(
    'Minoriko',
    <TomeStat>[TomeStat.mag, TomeStat.spd, TomeStat.res],
    <Skill>[
      CommonSkill.symbolHarvest,
      CommonSkill.desireRest,
      CommonSkill.regenerationAbility,
      CommonSkill.controlHarvests,
      CommonSkill.emergencyRecovery,
      CommonSkill.rapidCharge,
      CommonSkill.myriadHarvest,
      CommonSkill.plantationBlessing,
      CommonSkill.abundanceHarvest,
    ],
    <Skill>[
      Spell.autumnSky,
      Spell.warmHarvest,
      Spell.sweetPotato,
      Spell.owotoshiHarvester,
    ],
    <Skill>[],
  ),
  komachi(
    'Komachi',
    <TomeStat>[TomeStat.hp, TomeStat.atk, TomeStat.mnd],
    <Skill>[
      CommonSkill.shinigamiWork,
      CommonSkill.ferryWages,
      CommonSkill.flexibility,
      CommonSkill.regenerationAbility,
      CommonSkill.edokkoDeath,
      CommonSkill.eyeForEye,
      CommonSkill.enmaShinigami,
      CommonSkill.shinigamiScythe,
      CommonSkill.slackerMotivation,
    ],
    <Skill>[
      Spell.shortExpectancy,
      Spell.ferriageFog,
      Spell.confinesAvici,
      Spell.scytheChoosesDead,
    ],
    <Skill>[],
  ),
  chen(
    'Chen',
    <TomeStat>[TomeStat.atk, TomeStat.spd, TomeStat.eva],
    <Skill>[
      CommonSkill.yakumoClan,
      CommonSkill.instantAttack,
      CommonSkill.beatDown,
      CommonSkill.accelerate,
      CommonSkill.idaten,
      CommonSkill.screwThis,
      CommonSkill.shikigamiAccel,
      CommonSkill.monsterCat,
      CommonSkill.proofKinship,
    ],
    <Skill>[Spell.flightIdaten, Spell.phoenixWings, Spell.kimontonkou],
    <Skill>[],
  ),
  nitori(
    'Nitori',
    <TomeStat>[TomeStat.def, TomeStat.mnd, TomeStat.aff],
    <Skill>[
      CommonSkill.maintenance,
      CommonSkill.manipulateWater,
      CommonSkill.kappaObservation,
      CommonSkill.overheating,
      CommonSkill.coolingDown,
      CommonSkill.enhancedMachine,
      CommonSkill.youkaiAlliance,
      CommonSkill.kappaAesthetica,
    ],
    <Skill>[
      Spell.kappaWatterfall,
      Spell.extendingArm,
      Spell.superScope,
      Spell.portableMachine,
    ],
    <Skill>[],
  ),
  parsee(
    'Parsee',
    <TomeStat>[TomeStat.mp, TomeStat.mnd, TomeStat.res],
    <Skill>[
      CommonSkill.twoWayCurse,
      CommonSkill.finalBlow,
      CommonSkill.jealousyManipulation,
      CommonSkill.flamesJealousy,
      CommonSkill.emergencyRecovery,
      CommonSkill.jealousyBomber,
      CommonSkill.greenEyedMonster,
      CommonSkill.jealousyFinalBlow,
    ],
    <Skill>[
      Spell.largeSmallBox,
      Spell.midnightRitual,
      Spell.grudgeReturning,
      Spell.jealousyKindLovely,
    ],
    <Skill>[],
  ),
  wriggle(
    'Wriggle',
    <TomeStat>[TomeStat.def, TomeStat.mnd, TomeStat.eva],
    <Skill>[
      CommonSkill.team9,
      CommonSkill.inhalePoison,
      CommonSkill.kodokuQueen,
      CommonSkill.toxicVaccine,
      CommonSkill.insectCommander,
      CommonSkill.poisonTouch,
      CommonSkill.fireflySwarm,
      CommonSkill.nightbugCarnival,
      CommonSkill.proofKinship,
      CommonSkill.goingAlone,
    ],
    <Skill>[Spell.cometEarth, Spell.fireflyPhenomenon, Spell.nightbugTornado],
    <Skill>[],
  ),
  kaguya(
    'Kaguya',
    <TomeStat>[TomeStat.mp, TomeStat.mag, TomeStat.mnd],
    <Skill>[
      CommonSkill.residentsEientei,
      CommonSkill.royalPeopleMoon,
      CommonSkill.robeFireRat,
      CommonSkill.desireRest,
      CommonSkill.thousandExile,
      CommonSkill.lunarPower,
      CommonSkill.lunarIlmenite,
      CommonSkill.fiveRequests,
      CommonSkill.proofKinship,
    ],
    <Skill>[
      Spell.dragonJewel,
      Spell.buddhaBowl,
      Spell.swallowShell,
      Spell.bulletHourai,
    ],
    <Skill>[],
  ),
  mokou(
    'Mokou',
    <TomeStat>[TomeStat.hp, TomeStat.tp, TomeStat.atk],
    <Skill>[
      CommonSkill.withKeine,
      CommonSkill.regeneration,
      CommonSkill.resurrection,
      CommonSkill.blazing,
      CommonSkill.fightingSpirit,
      CommonSkill.moraleMaintenance,
      CommonSkill.sheerForce,
      CommonSkill.desperation,
      CommonSkill.imperishableShooting,
    ],
    <Skill>[Spell.firePhoenix, Spell.tsukiCurse, Spell.fujiyamaVolcano],
    <Skill>[],
  ),
  aya(
    'Aya',
    <TomeStat>[TomeStat.hp, TomeStat.atk, TomeStat.eva],
    <Skill>[
      CommonSkill.quickwitted,
      CommonSkill.fastestLessons,
      CommonSkill.tenguWind,
      CommonSkill.manipulateWind,
      CommonSkill.extraSteps,
      CommonSkill.proofFastest,
      CommonSkill.tenguWatchfulEyes,
      CommonSkill.youkaiAlliance,
    ],
    <Skill>[
      Spell.windGodFan,
      Spell.peerlessWindGod,
      Spell.sarutahikoGuidance,
      Spell.divineAdvent,
    ],
    <Skill>[],
  ),
  mystia(
    'Mystia',
    <TomeStat>[TomeStat.mp, TomeStat.atk, TomeStat.spd],
    <Skill>[
      CommonSkill.team9,
      CommonSkill.divaDarkness,
      CommonSkill.singingSilence,
      CommonSkill.soothingType,
      CommonSkill.instantAttack,
      CommonSkill.tunnelVision,
      CommonSkill.deafAllSong,
      CommonSkill.proofKinship,
      CommonSkill.goingAlone,
    ],
    <Skill>[
      Spell.illDive,
      Spell.poisonousDance,
      Spell.midnightChorus,
      Spell.mysteriousSong,
    ],
    <Skill>[],
  ),
  kasen(
    'Kasen',
    <TomeStat>[TomeStat.hp, TomeStat.tp, TomeStat.spd],
    <Skill>[
      CommonSkill.guideAnimals,
      CommonSkill.guts,
      CommonSkill.fightingSpirit,
      CommonSkill.adversity,
      CommonSkill.thankfulPreaching,
      CommonSkill.impactAttack,
      CommonSkill.adversityPlus,
      CommonSkill.healthySpirit,
      CommonSkill.fourDevaOoe,
    ],
    <Skill>[
      Spell.higekiriArm,
      Spell.echoForestGods,
      Spell.divingWaltz,
      Spell.breathHermit,
    ],
    <Skill>[Spell.summonDragonTiger],
  ),
  nazrin(
    'Nazrin',
    <TomeStat>[TomeStat.mnd, TomeStat.spd, TomeStat.eva],
    <Skill>[
      CommonSkill.myourenPersonnel,
      CommonSkill.bishamontenBlessing,
      CommonSkill.dowsing,
      CommonSkill.perceiveReality,
      CommonSkill.extraSteps,
      CommonSkill.bishamontenProtectionMag,
      CommonSkill.bishamontenProtectionSpd,
      CommonSkill.extraAttack,
      CommonSkill.effectiveChange,
      CommonSkill.tinyCommanderWisdom,
    ],
    <Skill>[Spell.goldRush, Spell.rareMetalDetector, Spell.nazrinPendulum],
    <Skill>[],
  ),
  hina(
    'Hina',
    <TomeStat>[TomeStat.hp, TomeStat.def, TomeStat.mnd],
    <Skill>[
      CommonSkill.wardingAwayLuck,
      CommonSkill.twoWayCurse,
      CommonSkill.curseReversal,
      CommonSkill.misfortuneStockpiling,
      CommonSkill.spinningMoreUsual,
      CommonSkill.roleNagashiBina,
      CommonSkill.sorrowfulExiled,
      CommonSkill.youkaiAlliance,
      CommonSkill.cursedDoll,
    ],
    <Skill>[Spell.misfortuneBiorhythm, Spell.painFlow, Spell.oldLadyFire],
    <Skill>[],
  ),
  rin(
    'Rin',
    <TomeStat>[TomeStat.atk, TomeStat.mag, TomeStat.spd],
    <Skill>[
      CommonSkill.earthSpiritsParty,
      CommonSkill.hellNecromancer,
      CommonSkill.speedyFormationChange,
      CommonSkill.twoWayCurse,
      CommonSkill.finalBlow,
      CommonSkill.extraAttack,
      CommonSkill.apparitionCarrier,
      CommonSkill.vengefulCatStep,
      CommonSkill.ashRekindling,
      CommonSkill.proofKinship,
    ],
    <Skill>[
      Spell.catWalk,
      Spell.vengefulSpirit,
      Spell.hellNeedleHill,
      Spell.blazingWheel,
    ],
    <Skill>[],
  ),
  utsuho(
    'Utsuho',
    <TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.mag],
    <Skill>[
      CommonSkill.earthSpiritsParty,
      CommonSkill.blazing,
      CommonSkill.overheating,
      CommonSkill.fightingSpirit,
      CommonSkill.sheerForce,
      CommonSkill.selfTokamak,
      CommonSkill.highBlazing,
      CommonSkill.proofKinship,
    ],
    <Skill>[Spell.gigaFlare, Spell.nuclearReaction, Spell.hellTokamak],
    <Skill>[],
  ),
  satori(
    'Satori',
    <TomeStat>[TomeStat.mp, TomeStat.atk, TomeStat.mag],
    <Skill>[
      CommonSkill.earthSpiritsParty,
      CommonSkill.perceiveReality,
      CommonSkill.smallMpRecovery,
      CommonSkill.traumaRecollection,
      CommonSkill.spellRecollection,
      CommonSkill.traumaRecreation,
      CommonSkill.terrifyingHypnotism,
      CommonSkill.proofKinship,
    ],
    <Skill>[Spell.brainFingerprint],
    <Skill>[],
  ),
  yuugi(
    'Yuugi',
    <TomeStat>[TomeStat.hp, TomeStat.atk, TomeStat.def],
    <Skill>[
      CommonSkill.physicalCounter,
      CommonSkill.lastFortress,
      CommonSkill.beatDown,
      CommonSkill.ruinousStrength,
      CommonSkill.hoshigumaDish,
      CommonSkill.adamantHelix,
      CommonSkill.dreadfulWaves,
      CommonSkill.ablityPhenomena,
      CommonSkill.lastFortressPlus,
      CommonSkill.fourDevaOoe,
    ],
    <Skill>[
      Spell.supernaturalPhenomenon,
      Spell.koThreeSteps,
      Spell.irremovableShackles,
    ],
    <Skill>[],
  ),
  meiling(
    'Meirin',
    <TomeStat>[TomeStat.tp, TomeStat.def, TomeStat.mnd],
    <Skill>[
      CommonSkill.sdmResidents,
      CommonSkill.gatekeeperDuty,
      CommonSkill.guts,
      CommonSkill.natural,
      CommonSkill.gatekeeperNap,
      CommonSkill.chinaQigong,
      CommonSkill.rocKillingFist,
      CommonSkill.spiralLightStep,
      CommonSkill.chineseGirlQigong,
      CommonSkill.proofKinship,
    ],
    <Skill>[
      Spell.brilliantGem,
      Spell.mountainBreaker,
      Spell.colorfulRain,
      Spell.healer,
    ],
    <Skill>[],
  ),
  alice(
    'Alice',
    <TomeStat>[TomeStat.hp, TomeStat.mag, TomeStat.mnd],
    <Skill>[
      CommonSkill.manipulationDolls,
      CommonSkill.dollGuard,
      CommonSkill.maliceAlice,
      CommonSkill.finalBlow,
      CommonSkill.rapidCharge,
      CommonSkill.dollMobility,
      CommonSkill.controlledDolls,
      CommonSkill.firstAidDolls,
      CommonSkill.additionalGuards,
    ],
    <Skill>[
      Spell.artfulSacrifice,
      Spell.littleLegion,
      Spell.hangedHourai,
      Spell.tripWire,
    ],
    <Skill>[],
  ),
  patchouli(
    'Patchouli',
    <TomeStat>[TomeStat.mp, TomeStat.mag, TomeStat.aff],
    <Skill>[
      CommonSkill.sdmResidents,
      CommonSkill.grandIncantation,
      CommonSkill.girlKnowledgeShade,
      CommonSkill.passivePhilosopher,
      CommonSkill.rapidCharge,
      CommonSkill.unmovingGreatLibrary,
      CommonSkill.infiniteBookCollection,
      CommonSkill.asthmaMedicine,
      CommonSkill.speedyIncantation,
      CommonSkill.proofKinship,
    ],
    <Skill>[
      Spell.royalFlare,
      Spell.princessUndine,
      Spell.djinnGust,
      Spell.satelliteHimawari,
      Spell.silentSelene,
    ],
    <Skill>[],
  ),
  eirin(
    'Eirin',
    <TomeStat>[TomeStat.hp, TomeStat.mag, TomeStat.res],
    <Skill>[
      CommonSkill.residentsEientei,
      CommonSkill.peopleMoon,
      CommonSkill.healingLimitBreak,
      CommonSkill.coolingDown,
      CommonSkill.pharmacistMixing,
      CommonSkill.thousandExile,
      CommonSkill.specialEndurance,
      CommonSkill.lunarSageWisdom,
      CommonSkill.poisonMixing,
      CommonSkill.proofKinship,
    ],
    <Skill>[
      Spell.mercurySea,
      Spell.omoikaneDevice,
      Spell.houraiElixir,
      Spell.astronomicalEntombing,
    ],
    <Skill>[],
  ),
  reisen(
    'Reisen',
    <TomeStat>[TomeStat.mp, TomeStat.mag, TomeStat.spd],
    <Skill>[
      CommonSkill.residentsEientei,
      CommonSkill.peopleMoon,
      CommonSkill.finalBlow,
      CommonSkill.mindModulation,
      CommonSkill.wavelengthInsanity,
      CommonSkill.intenseVertigo,
      CommonSkill.vaporousRedEyes,
      CommonSkill.enhancedMindModulation,
      CommonSkill.grandVertigo,
      CommonSkill.proofKinship,
    ],
    <Skill>[
      Spell.lunaticRedEyes,
      Spell.mindStarmine,
      Spell.discarder,
      Spell.gasWovenOrb,
      Spell.grandPatriotElixir,
    ],
    <Skill>[],
  ),
  sanae(
    'Sanae',
    <TomeStat>[TomeStat.def, TomeStat.mag, TomeStat.mnd],
    <Skill>[
      CommonSkill.believersMoriya,
      CommonSkill.expansionConsciousness,
      CommonSkill.lastWish,
      CommonSkill.moriyaProtection,
      CommonSkill.powerLivingGod,
      CommonSkill.youkaiBuster,
      CommonSkill.miracleFafrotskies,
      CommonSkill.sacrificalMaiden,
      CommonSkill.hisoutenGuard,
      CommonSkill.proofKinship,
    ],
    <Skill>[
      Spell.nightGuesstStars,
      Spell.mosesMiracle,
      Spell.yasakaWind,
      Spell.miracleFruit,
    ],
    <Skill>[],
  ),
  iku(
    'Iku',
    <TomeStat>[TomeStat.hp, TomeStat.def, TomeStat.mag],
    <Skill>[
      CommonSkill.hisoutenGuard,
      CommonSkill.magicCounter,
      CommonSkill.hagoromoSky,
      CommonSkill.flexibility,
      CommonSkill.suppleHagoromo,
      CommonSkill.heavenlyBlow,
      CommonSkill.lightningFish,
      CommonSkill.magicCounterPlus,
      CommonSkill.thunderAbtruseClouds,
      CommonSkill.pearlClawedDragon,
    ],
    <Skill>[
      Spell.elekiterPalace,
      Spell.lightDragonSigh,
      Spell.thunedrcloudStickleback,
      Spell.whiskersDragonGod,
    ],
    <Skill>[],
  ),
  suika(
    'Suika',
    <TomeStat>[TomeStat.atk, TomeStat.mnd, TomeStat.res],
    <Skill>[
      CommonSkill.ibukiGourd,
      CommonSkill.freeSpiritedOni,
      CommonSkill.fogLabyrinth,
      CommonSkill.artOniBinding,
      CommonSkill.encounterFoe,
      CommonSkill.earthSpiritDense,
      CommonSkill.pandemonicSprinkle,
      CommonSkill.fourDevaOoe,
    ],
    <Skill>[
      Spell.throwingTogakushi,
      Spell.throwingAtlas,
      Spell.gatheringDissipating,
      Spell.missingPower,
      Spell.artSegakiBinding,
    ],
    <Skill>[],
  ),
  ran(
    'Ran',
    <TomeStat>[TomeStat.mp, TomeStat.mag, TomeStat.spd],
    <Skill>[
      CommonSkill.yakumoClan,
      CommonSkill.abilityShikigamis,
      CommonSkill.superFastHardArithmetic,
      CommonSkill.expansionConsciousness,
      CommonSkill.coolingDown,
      CommonSkill.shikigamiDefense,
      CommonSkill.hermitFoxThoughts,
      CommonSkill.kokkuriContract,
      CommonSkill.friedTofuPower,
      CommonSkill.proofKinship,
    ],
    <Skill>[
      Spell.foxTanukiLaser,
      Spell.princessTenko,
      Spell.soaringOzuno,
      Spell.banquetGeneralGods,
      Spell.eightyMillionBoards,
    ],
    <Skill>[],
  ),
  remilia(
    'Remilia',
    <TomeStat>[TomeStat.hp, TomeStat.atk, TomeStat.spd],
    <Skill>[
      CommonSkill.sdmResidents,
      CommonSkill.majesty,
      CommonSkill.beatDown,
      CommonSkill.lastFortress,
      CommonSkill.impactAttack,
      CommonSkill.adversity,
      CommonSkill.mentalConcentration,
      CommonSkill.bloodsuck,
      CommonSkill.proofKinship,
      CommonSkill.piercingAttack,
    ],
    <Skill>[Spell.spearGungnir, Spell.curseVladTepes],
    <Skill>[Spell.badLadyScramble],
  ),
  sakuya(
    'Sakuya',
    <TomeStat>[TomeStat.mp, TomeStat.atk, TomeStat.spd],
    <Skill>[
      CommonSkill.sdmResidents,
      CommonSkill.eyeForEye,
      CommonSkill.flashingMurder,
      CommonSkill.piercingAttack,
      CommonSkill.dexterity,
      CommonSkill.extraAttack,
      CommonSkill.jackLudoBile,
      CommonSkill.jackSilverKnife,
      CommonSkill.sakuyaWorld,
      CommonSkill.proofKinship,
    ],
    <Skill>[
      Spell.misdirection,
      Spell.killingDoll,
      Spell.soulSculpture,
      Spell.lunarClock,
      Spell.privateSquare,
    ],
    <Skill>[],
  ),
  kanako(
    'Kanako',
    <TomeStat>[TomeStat.hp, TomeStat.def, TomeStat.mag],
    <Skill>[
      CommonSkill.believersMoriya,
      CommonSkill.majesty,
      CommonSkill.strongFaith,
      CommonSkill.skyCreation,
      CommonSkill.desperation,
      CommonSkill.sacredAuthorityGods,
      CommonSkill.majestyPlus,
      CommonSkill.proofKinship,
    ],
    <Skill>[
      Spell.madDanceMedoteko,
      Spell.misayamaRitual,
      Spell.beautifulSuiga,
      Spell.virtueWindGod,
    ],
    <Skill>[],
  ),
  suwako(
    'Suwako',
    <TomeStat>[TomeStat.mp, TomeStat.atk, TomeStat.mag],
    <Skill>[
      CommonSkill.believersMoriya,
      CommonSkill.earthCreation,
      CommonSkill.froggyPower,
      CommonSkill.nativeGodEarth,
      CommonSkill.quickwitted,
      CommonSkill.froggyHibernation,
      CommonSkill.chytridiomycosisResistance,
      CommonSkill.proofKinship,
    ],
    <Skill>[
      Spell.moriyaIronRing,
      Spell.longArmLeg,
      Spell.froggyBravesElements,
      Spell.mishagujiSama,
    ],
    <Skill>[],
  ),
  tenshi(
    'Tensi',
    <TomeStat>[TomeStat.tp, TomeStat.aff, TomeStat.res],
    <Skill>[
      CommonSkill.girlBhavaAgra,
      CommonSkill.risingFalling,
      CommonSkill.keystoneFormation,
      CommonSkill.swordHisouOwner,
      CommonSkill.murakumoFormerOwner,
      CommonSkill.freeWorldlyThoughts,
      CommonSkill.enduringCelestial,
      CommonSkill.highSpiritedSword,
      CommonSkill.hugeTemperamentKeystone,
      CommonSkill.peachesImmortality,
    ],
    <Skill>[
      Spell.worldCreationPress,
      Spell.violentMotherland,
      Spell.swordHisou,
      Spell.stateEnlightenment,
    ],
    <Skill>[],
  ),
  flandre(
    'Flandre',
    <TomeStat>[TomeStat.mp, TomeStat.atk, TomeStat.mag],
    <Skill>[
      CommonSkill.sdmResidents,
      CommonSkill.smolderingMadness,
      CommonSkill.impactAttack,
      CommonSkill.beatDown,
      CommonSkill.vampiricWrath,
      CommonSkill.controlMadness,
      CommonSkill.bloodsuck,
      CommonSkill.propagatingMadness,
      CommonSkill.proofKinship,
      CommonSkill.destructionRoulette,
    ],
    <Skill>[Spell.starbowBreak, Spell.forbiddenFruit, Spell.laveatein],
    <Skill>[],
  ),
  yuyuko(
    'Yuyuko',
    <TomeStat>[TomeStat.mp, TomeStat.mag, TomeStat.spd],
    <Skill>[
      CommonSkill.hakugyokurouMistress,
      CommonSkill.liveUnderworld,
      CommonSkill.majesty,
      CommonSkill.banquetRegrets,
      CommonSkill.ticketAgelessLand,
      CommonSkill.saigyouSeal,
      CommonSkill.mistressSerious,
      CommonSkill.majestyPlus,
      CommonSkill.mistressServant,
    ],
    <Skill>[
      Spell.dreamButterfly,
      Spell.swallowtailLance,
      Spell.ghastlyDream,
      Spell.flawlessNirvana,
    ],
    <Skill>[],
  ),
  yuuka(
    'Yuuka',
    <TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.mag],
    <Skill>[
      CommonSkill.extraAttack,
      CommonSkill.majesty,
      CommonSkill.encounterFoe,
      CommonSkill.gensokyoFlower,
      CommonSkill.tormentingNature,
      CommonSkill.perilousSpring,
      CommonSkill.plantationBlessing,
    ],
    <Skill>[Spell.flowerShot, Spell.gensokyoReflowering, Spell.beautyNature],
    <Skill>[Spell.masterSparkYuuka],
  ),
  yukari(
    'Yukari',
    <TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.mnd],
    <Skill>[
      CommonSkill.yakumoClan,
      CommonSkill.manipulationBoundaries,
      CommonSkill.borderPowerMagic,
      CommonSkill.borderWoundsCures,
      CommonSkill.phenomenalForceWill,
      CommonSkill.majesty,
      CommonSkill.perpetualMotionDevice,
      CommonSkill.enhancedShikigamiControl,
      CommonSkill.enhancedBoundaryControl,
      CommonSkill.proofKinship,
    ],
    <Skill>[
      Spell.meshLightDarkness,
      Spell.hyperactiveFlyingObject,
      Spell.shikigamiRanPlus,
      Spell.spiritingAway,
      Spell.quadrupleBarrier,
    ],
    <Skill>[],
  ),
  byakuren(
    'Hijiri',
    <TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.spd],
    <Skill>[
      CommonSkill.sutraStrength,
      CommonSkill.sutraShield,
      CommonSkill.sutraChant,
      CommonSkill.sutraFocus,
      CommonSkill.sutraDrang,
      CommonSkill.sutraRecovery,
      CommonSkill.sutraMana,
      CommonSkill.sutraResistance,
      CommonSkill.sutraImmunity,
      CommonSkill.superhumanLineage,
    ],
    <Skill>[
      Spell.skandaLegs,
      Spell.masterTrichilocosm,
      Spell.magicMilkyWay,
      Spell.starSwordApologetics,
      Spell.sutraDuplicatingChant,
    ],
    <Skill>[],
  ),
  eiki(
    'Eiki',
    <TomeStat>[TomeStat.atk, TomeStat.mag, TomeStat.mnd],
    <Skill>[
      CommonSkill.cleansedMirror,
      CommonSkill.majesty,
      CommonSkill.supremeJudgeParadise,
      CommonSkill.thankfulPreaching,
      CommonSkill.rodRemorse,
      CommonSkill.strongFaith,
      CommonSkill.abilityJudgeMorality,
      CommonSkill.enmaShinigami,
      CommonSkill.moralInversion,
      CommonSkill.superThankfulPreaching,
    ],
    <Skill>[Spell.lastJudgement, Spell.trialTenKings, Spell.wanderingSin],
    <Skill>[],
  ),
  renko(
    'Renko',
    <TomeStat>[TomeStat.spd, TomeStat.eva, TomeStat.res],
    <Skill>[
      CommonSkill.sealingClub,
      CommonSkill.starReading,
      CommonSkill.moonReading,
      CommonSkill.maintenance,
      CommonSkill.astronomicalObservation,
      CommonSkill.easygoing,
      CommonSkill.assaultPoint,
      CommonSkill.readMoreStars,
      CommonSkill.readMoreMoons,
    ],
    <Skill>[Spell.galaxyStop, Spell.charge],
    <Skill>[],
  ),
  maribel(
    'Maribel',
    <TomeStat>[TomeStat.mp, TomeStat.tp, TomeStat.mag],
    <Skill>[
      CommonSkill.sealingClub,
      CommonSkill.manipulationBoundaries,
      CommonSkill.abilitySeeBoundaries,
      CommonSkill.meddlingWithBorders,
      CommonSkill.rapidCharge,
      CommonSkill.grandIncantation,
      CommonSkill.shareVision,
      CommonSkill.controlLiberation,
      CommonSkill.controlUnnatural,
    ],
    <Skill>[
      Spell.liberatedAbilities,
      Spell.chaoticQuadrupleBarrier,
      Spell.overflowingPower,
      Spell.mariDYIBorder,
    ],
    <Skill>[],
  ),
  shou(
    'Toramaru',
    <TomeStat>[TomeStat.hp, TomeStat.def, TomeStat.mnd],
    <Skill>[
      CommonSkill.myourenPersonnel,
      CommonSkill.swindledOne,
      CommonSkill.abilityGatherTreasures,
      CommonSkill.pagodaLightDharma,
      CommonSkill.physicalCounter,
      CommonSkill.bishamontenWrath,
      CommonSkill.personificationEffort,
      CommonSkill.trueBishamontenWrath,
      CommonSkill.moreTreasures,
      CommonSkill.piercingAttack,
    ],
    <Skill>[
      Spell.hungryTiger,
      Spell.radiantTreasureGun,
      Spell.dazzlingGold,
      Spell.auraJustice,
    ],
    <Skill>[],
  ),
  mamizou(
    'Mamizou',
    <TomeStat>[TomeStat.mp, TomeStat.tp, TomeStat.eva],
    <Skill>[
      CommonSkill.elementalTransformations,
      CommonSkill.monsterTanukiPrankster,
      CommonSkill.slipperyTanukiDisguiser,
      CommonSkill.highSpeedNormalAttack,
      CommonSkill.elderTanukiWisdom,
      CommonSkill.heartPerseverance,
      CommonSkill.monsterTanukiWisdom,
      CommonSkill.monsterTanukiWiles,
      CommonSkill.majesty,
    ],
    <Skill>[
      Spell.frolickingAnimals,
      Spell.futatsuiwaClanCurse,
      Spell.tenTransformationsDanmaku,
      Spell.fullMoonPompokolin,
    ],
    <Skill>[],
  ),
  futo(
    'Futo',
    <TomeStat>[TomeStat.tp, TomeStat.atk, TomeStat.res],
    <Skill>[
      CommonSkill.kodokuPlatePileup,
      CommonSkill.royalsChaoticDanceFuto,
      CommonSkill.offeringMikoto,
      CommonSkill.offeringOkami,
      CommonSkill.spiritMausoleum,
      CommonSkill.givingWings,
      CommonSkill.leylineDragonNest,
      CommonSkill.lightningSakeCups,
      CommonSkill.accelerate,
    ],
    <Skill>[
      Spell.mononobeEightySakeCups,
      Spell.catastrophicGateOpening,
      Spell.miwaPlateStorm,
      Spell.taiyiTrueFire,
    ],
    <Skill>[],
  ),
  miko(
    'Miko',
    <TomeStat>[TomeStat.hp, TomeStat.mag, TomeStat.aff],
    <Skill>[
      CommonSkill.asukaHeritageAttack,
      CommonSkill.royalsChaoticDanceMiko,
      CommonSkill.trueAdministrator,
      CommonSkill.princeShotokyOoPArtifact,
      CommonSkill.sageToyosatomimi,
      CommonSkill.meikyoShisui,
      CommonSkill.princeLesson,
      CommonSkill.transcendentalAdministrator,
      CommonSkill.megaAsukaHeritageAttack,
    ],
    <Skill>[
      Spell.traditionJustRewards,
      Spell.haloGuseKannon,
      Spell.wishfulSoulDesire,
    ],
    <Skill>[],
  ),
  kokoro(
    'Kokoro',
    <TomeStat>[TomeStat.atk, TomeStat.def, TomeStat.mag, TomeStat.mnd],
    <Skill>[
      CommonSkill.myourenDisciple,
      CommonSkill.phantasmalEmotion,
      CommonSkill.powerMaskCreator,
      CommonSkill.sixtySixEmotions,
      CommonSkill.manipulationEmotions,
      CommonSkill.lostEmotion,
      CommonSkill.emptyHeartedMasks,
      CommonSkill.maskHope,
      CommonSkill.moraleMaintenance,
    ],
    <Skill>[
      Spell.fourHumorsPossession,
      Spell.invigoratedKaguraLion,
      Spell.worrisomeManOfQi,
    ],
    <Skill>[],
  ),
  tokiko(
    'Tokiko',
    <TomeStat>[
      TomeStat.atk,
      TomeStat.def,
      TomeStat.mag,
      TomeStat.mnd,
      TomeStat.spd,
    ],
    <Skill>[
      CommonSkill.namelessBookwormYoukai,
      CommonSkill.reimuMarisaAbuseVictim,
      CommonSkill.crestedIbisFeather,
      CommonSkill.sugariOntachiOrnament,
      CommonSkill.crossoveredEndangeredBird,
      CommonSkill.eyeForEye,
      CommonSkill.loveWayYouRead,
      CommonSkill.thickBookCQC,
      CommonSkill.bookwormYoukaiArdor,
      CommonSkill.bookwormYoukaiGrudge,
    ],
    <Skill>[
      Spell.youkaiYakuzaKick,
      Spell.countMonteCristo,
      Spell.musketeerDartagnan,
      Spell.nonNeumannSystems,
    ],
    <Skill>[],
  ),
  koishi(
    'Koisi',
    <TomeStat>[TomeStat.mp, TomeStat.mnd, TomeStat.eva],
    <Skill>[
      CommonSkill.earthSpiritsParty,
      CommonSkill.myourenDisciple,
      CommonSkill.superResponsiveSenses,
      CommonSkill.subconsciousManipulation,
      CommonSkill.subconsciousGenetics,
      CommonSkill.expansionConsciousness,
      CommonSkill.embryoDream,
      CommonSkill.superResponsiveSensesPlus,
      CommonSkill.embryoWhyDance,
    ],
    <Skill>[
      Spell.embersLove,
      Spell.superEgo,
      Spell.bedsideAncestors,
      Spell.selflessLove,
    ],
    <Skill>[],
  ),
  akyuu(
    'Akyuu',
    <TomeStat>[TomeStat.hp, TomeStat.mp, TomeStat.tp],
    <Skill>[
      CommonSkill.hyperthymesicMemory,
      CommonSkill.gensokyoChroniclesWisdom,
      CommonSkill.memoriesGensokyo,
      CommonSkill.miareDescendantPower,
      CommonSkill.ultraIncantation,
      CommonSkill.phenomenalForceWill,
      CommonSkill.searchMoreWisdom,
      CommonSkill.protectorKnowledge,
      CommonSkill.trueMaidenMiare,
    ],
    <Skill>[Spell.wiseProtectiveArt, Spell.wiseDefensiveArt],
    <Skill>[Spell.miareExtensiveKnowledge],
  );

  final String filename;
  final List<TomeStat> naturalTomeStats;
  final List<Skill> skills;
  final List<Skill> spells;
  final List<Skill> awakeningSpells;

  const Character(
    this.filename,
    this.naturalTomeStats,
    this.skills,
    this.spells,
    this.awakeningSpells,
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
