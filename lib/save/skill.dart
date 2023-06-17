import 'dart:typed_data';
import 'package:thlaby2_save_editor/extensions/int_extension.dart';

abstract class Skill {
  final int maxLevel;
  final int levelCost;
  final String name;

  Skill(this.maxLevel, this.levelCost, this.name);
}

enum BoostSkill implements Skill {
  hp(5, 2, 'HP Boost'),
  mp(5, 2, 'MP Boost'),
  tp(5, 2, 'TP Boost'),
  atk(5, 2, 'ATK Boost'),
  def(5, 2, 'DEF Boost'),
  mag(5, 2, 'MAG Boost'),
  mnd(5, 2, 'MND Boost'),
  spd(5, 2, 'SPD Boost'),
  eva(5, 2, 'EVA Boost'),
  acc(5, 2, 'ACC Boost'),
  aff(5, 2, 'Affinity Boost'),
  res(5, 2, 'Resistance Boost');

  @override
  final int maxLevel;
  @override
  final int levelCost;
  @override
  final String name;

  const BoostSkill(this.maxLevel, this.levelCost, this.name);
}

enum Boost2Skill implements Skill {
  hp(5, 10, 'HP Boost 2'),
  mp(5, 10, 'MP Boost 2'),
  tp(5, 10, 'TP Boost 2'),
  atk(5, 10, 'ATK Boost 2'),
  def(5, 10, 'DEF Boost 2'),
  mag(5, 10, 'MAG Boost 2'),
  mnd(5, 10, 'MND Boost 2'),
  spd(5, 10, 'SPD Boost 2');

  @override
  final int maxLevel;
  @override
  final int levelCost;
  @override
  final String name;

  const Boost2Skill(this.maxLevel, this.levelCost, this.name);
}

enum BoostMegaSkill implements Skill {
  hp(5, 50, 'HP Mega Boost'),
  mp(5, 50, 'MP Mega Boost'),
  tp(5, 50, 'TP Mega Boost'),
  atk(5, 50, 'ATK Mega Boost'),
  def(5, 50, 'DEF Mega Boost'),
  mag(5, 50, 'MAG Mega Boost'),
  mnd(5, 50, 'MND Mega Boost'),
  spd(5, 50, 'SPD Mega Boost');

  @override
  final int maxLevel;
  @override
  final int levelCost;
  @override
  final String name;

  const BoostMegaSkill(this.maxLevel, this.levelCost, this.name);
}

enum BoostHighSkill implements Skill {
  hp(5, 6, 'HP High Boost'),
  mp(5, 3, 'MP High Boost'),
  tp(5, 6, 'TP High Boost'),
  atk(5, 6, 'ATK High Boost'),
  def(5, 6, 'DEF High Boost'),
  mag(5, 6, 'MAG High Boost'),
  mnd(5, 6, 'MND High Boost'),
  spd(5, 6, 'SPD High Boost'),
  eva(5, 6, 'EVA High Boost'),
  acc(5, 6, 'ACC High Boost'),
  aff(5, 6, 'Affinity High Boost'),
  res(5, 6, 'Resistance High Boost');

  @override
  final int maxLevel;
  @override
  final int levelCost;
  @override
  final String name;

  const BoostHighSkill(this.maxLevel, this.levelCost, this.name);
}

enum BoostGigaSkill implements Skill {
  hp(5, 75, 'HP Giga Boost'),
  mp(5, 75, 'MP Giga Boost'),
  tp(5, 75, 'TP Giga Boost'),
  atk(5, 75, 'ATK Giga Boost'),
  def(5, 75, 'DEF Giga Boost'),
  mag(5, 75, 'MAG Giga Boost'),
  mnd(5, 75, 'MND Giga Boost'),
  spd(5, 75, 'SPD Giga Boost');

  @override
  final int maxLevel;
  @override
  final int levelCost;
  @override
  final String name;

  const BoostGigaSkill(this.maxLevel, this.levelCost, this.name);
}

enum ExpSkill implements Skill {
  motivatedHeart(2, 5, 'Motivated Heart'),
  handsOnExperience(2, 5, 'Hands-on Experience');

  @override
  final int maxLevel;
  @override
  final int levelCost;
  @override
  final String name;

  const ExpSkill(this.maxLevel, this.levelCost, this.name);
}

enum CommonSkill implements Skill {
  mainReimu(2, 5, 'Main Character: Reimu'),
  grandIncantation(2, 5, 'Grand Incantation'),
  hakureiProtection(2, 5, "Hakurei's Divine Protection"),
  finalPrayer(2, 5, 'Final Prayer'),
  armoredOrb(2, 5, 'Armored Yin-Yang Orb'),
  youkaiBuster(2, 5, 'Youkai Buster'),
  fantasyBlink(10, 16, 'Fantasy Seal -Blink-'),
  barrierExpert(1, 50, 'Barrier Expert'),
  superYoukaiBuster(2, 40, 'Super Youkai Buster'),
  maliceMarisa(2, 5, 'MAlice Cannon (Marisa)'),
  mainMarisa(2, 5, 'Main Character: Marisa'),
  sheerForce(1, 15, 'Sheer Force'),
  suddenImpulse(2, 5, 'Sudden Impulse'),
  givingWings(2, 5, 'Giving You Wings'),
  magicTraining(2, 5, 'Magic Training'),
  hakkeroCharge(1, 80, 'Hakkero Charge Mode'),
  hakkeroCustom(1, 70, 'Hakkero Custom Mode'),
  magicDrain(7, 10, 'Magic Drain Missile'),
  shopkeeper(10, 1, "Gensokyo's Shopkeeper"),
  shopowner(10, 1, 'Keen-eyed Shop Owner Saga'),
  effectiveChange(2, 5, 'Effective Formation Change'),
  weirdCreatures(2, 5, 'Weird Creatures Knowledge'),
  attackDebuff(2, 5, 'Attack Debuff Add-On'),
  magicDebuff(2, 5, 'Magic Debuff Add-on'),
  murakumoOwner(10, 10, "Murakumo's Previous Owner"),
  guts(2, 5, 'Guts'),
  withMokou(2, 5, 'With Mokou'),
  organizedFormation(1, 10, 'Organized Formation'),
  firmDefense(2, 5, 'Firm Defense'),
  teacherCommand(2, 6, "Teacher's Command"),
  historianSchool(1, 10, "Historian's School"),
  historyAccumulation(3, 16, 'History Accumulation'),
  imperviousChange(1, 50, 'Impervious Formation Change'),
  wereHakutaku(10, 7, 'Were-Hakutaku Form'),
  createHistory(3, 25, 'Ability to Create History'),
  seeFarDistances(2, 5, 'Ability to See Far Distances'),
  tenguWatchful(2, 5, "Tengu's Watchful Eye"),
  accelerate(1, 10, 'Accelerate'),
  perceiveReality(1, 7, 'Eyes that Perceive Reality'),
  instantAttack(1, 12, 'Instant Attack'),
  whiteWolfSwordShield(8, 16, "White Wolf's Sword and Shield"),
  youkaiAlliance(2, 25, 'Youkai Mountain Alliance?'),
  encounterFoe(1, 10, 'Encounter with a Strong Foe'),
  regenerationAbility(1, 10, 'Regeneration Ability'),
  liveUnderworld(2, 5, 'Those Who Live in the Underworld'),
  dexterity(1, 7, 'Dexterity'),
  mentalConcentration(4, 4, 'Mental Concentration'),
  meikyoShisui(2, 5, 'Meikyo Shisui'),
  desperation(2, 5, 'Desperation'),
  swordSpirit(1, 20, 'Sword Spirit'),
  asuraBlood(1, 75, "Asura's Blood"),
  silentNirvana(3, 50, 'As the Silent Nirvana'),
  mistressServant(2, 25, 'Mistress & Servant'),
  surpriseHumans(1, 10, 'Ability to Surprise Humans'),
  easygoing(1, 5, 'Easygoing'),
  heartPerseverance(2, 5, 'Heart of Perseverance'),
  forgottenItem(2, 6, 'Troubled Forgotten Item'),
  waterproofUmbrella(1, 24, 'Waterproof Ghost Umbrella'),
  astonishingUmbrella(1, 24, 'Astonishing Ghost Umbrella'),
  angstfreude(1, 60, 'Angstfreude'),
  terrorDeath(10, 10, 'The Terror Unto Death'),
  speedyFormationChange(2, 5, 'Speedy Formation Change'),
  team9(2, 5, 'Team ⑨'),
  realmDarkness(2, 5, 'Realm of Eternal Darkness'),
  youkaiKnowledge(2, 5, "Youkai's Knowledge"),
  piercingAttack(2, 5, 'Piercing Attack'),
  darknessManipulation(2, 5, 'Darkness Manipulation'),
  greatPiercingAttack(1, 60, 'Great Piercing Attack'),
  robesDarkness(1, 60, 'Robes of Engulfing Darkness'),
  darknessYoukai(10, 10, 'Darkness-Lurking Youkai'),
  proofKinship(1, 100, 'Proof of Kinship'),
  goingAlone(1, 50, 'Going it Alone'),
  risingFalling(3, 4, 'Always Rising after Falling'),
  tomboyishLove(2, 5, 'Tomboyish Girl in Love'),
  manipulateIce(2, 5, 'Ability to Manipulate Ice'),
  blizzardBlowout(5, 8, 'Blizzard Blowout'),
  tomboyishVengeance(1, 70, "Tomboyish Girl's Vengeance"),
  acrobaticFairy(8, 9, 'Acrobatic Tomboyish Fairy'),
  symbolHarvest(2, 5, 'Symbol of Harvest'),
  desireRest(2, 5, 'Desire to Rest'),
  controlHarvests(2, 6, 'Ability to Control Harvests'),
  emergencyRecovery(1, 10, 'Emergency Recovery'),
  rapidCharge(1, 10, 'Rapid Charge'),
  myriadHarvest(1, 75, 'Myriad Goddess of Harvest'),
  plantationBlessing(8, 15, "Plantation's Blessing"),
  abundanceHarvest(2, 40, 'Symbol of Abundance and Harvest'),
  shinigamiWork(1, 10, "The Shinigami's Work"),
  ferryWages(10, 1, 'Ferry Wages of Sanzu River'),
  flexibility(1, 7, 'Flexibility'),
  edokkoDeath(1, 5, 'Edokko God of Death'),
  eyeForEye(2, 5, 'An Eye for an Eye'),
  enmaShinigami(2, 25, 'Enma & Shinigami'),
  shinigamiScythe(8, 12, "Shinigami's Scythe"),
  slackerMotivation(5, 10, "Slacker's Motivation"),
  yakumoClan(2, 5, 'Yakumo Clan'),
  beatDown(2, 6, 'Beat Down'),
  idaten(2, 5, 'Idaten'),
  screwThis(1, 7, "Screw This, I'm Outta Here"),
  shikigamiAccel(1, 75, "Shikigami's Heavy Accel Attack"),
  monsterCat(10, 6, 'Indiscernible Monster Cat'),
  maintenance(1, 15, 'Maintenance'),
  manipulateWater(2, 5, 'Ability to Manipulate Water'),
  kappaObservation(2, 5, "Kappa's Ecology Observation"),
  overheating(1, 10, 'Overheating'),
  coolingDown(2, 12, 'Cooling Down'),
  enhancedMachine(1, 50, 'Enhanced Versatile Machine'),
  kappaAesthetica(1, 75, "Kappa's Material Aesthetica"),
  twoWayCurse(2, 5, 'Two-Way Curse'),
  finalBlow(2, 5, 'Final Blow'),
  jealousyManipulation(1, 10, 'Jealousy Manipulation'),
  flamesJealousy(2, 5, 'Flames of Jealousy'),
  jealousyBomber(1, 40, 'Jealousy Bomber'),
  greenEyedMonster(1, 80, 'Green Eyed Monster'),
  jealousyFinalBlow(1, 66, 'Jealousy-Fueled Final Blow'),
  inhalePoison(2, 5, 'Inhale Poison'),
  kodokuQueen(1, 10, 'Kodoku Queen'),
  toxicVaccine(2, 5, 'Toxic Vaccine'),
  insectCommander(2, 5, "Insect's Commander"),
  poisonTouch(2, 5, 'Poison Touch'),
  fireflySwarm(1, 50, 'Firefly Swarm'),
  nightbugCarnival(1, 40, 'Nightbug Carnival'),
  residentsEientei(2, 5, 'Residents of Eientei'),
  royalPeopleMoon(1, 12, 'Royal People of the Moon'),
  robeFireRat(2, 5, 'Robe of Fire Rat'),
  thousandExile(1, 10, 'Thousand Year Exile'),
  lunarPower(1, 50, 'Lunar Power'),
  lunarIlmenite(5, 20, 'Lunar Ilmenite'),
  fiveRequests(1, 75, 'Five Impossible Requests'),
  withKeine(2, 5, 'With Keine'),
  regeneration(2, 8, 'Regeneration'),
  resurrection(3, 5, 'Resurrection'),
  blazing(2, 5, 'Blazing'),
  fightingSpirit(2, 5, 'Fighting Spirit'),
  moraleMaintenance(1, 60, 'Morale Maintenance'),
  imperishableShooting(1, 80, 'Imperishable Shooting'),
  quickwitted(1, 7, 'Quickwitted'),
  fastestLessons(2, 5, "Gensokyo's Fastest Lessons"),
  tenguWind(2, 6, "Tengu's Wind"),
  manipulateWind(2, 5, 'Ability to Manipulate Wind'),
  extraSteps(1, 12, 'Extra Steps'),
  proofFastest(1, 80, 'Proof of the Fastest'),
  tenguWatchfulEyes(4, 15, "Crow Tengu's Watchful Eyes"),
  divaDarkness(2, 5, 'Diva of Darkness'),
  singingSilence(1, 10, 'Singing in the Silence'),
  soothingType(1, 6, 'Soothing Type?'),
  tunnelVision(1, 66, 'Tunnel Vision'),
  deafAllSong(1, 66, 'Deaf to All but the Song'),
  guideAnimals(2, 5, 'Ability to Guide Animals'),
  adversity(2, 5, 'Adversity'),
  thankfulPreaching(1, 10, 'Thankful Preaching'),
  impactAttack(1, 10, 'Impact Attack'),
  adversityPlus(2, 25, 'Adversity+'),
  healthySpirit(1, 70, 'Healthy Spirit'),
  fourDevaOoe(2, 25, 'Four Deva of Mt. Ooe?'),
  myourenPersonnel(1, 7, 'Myouren Temple Personnel'),
  bishamontenBlessing(2, 5, "Bishamonten's Blessing"),
  dowsing(1, 12, 'Dowsing'),
  bishamontenProtectionMag(4, 12, "Bishamonten's Protection - MAG"),
  bishamontenProtectionSpd(4, 12, "Bishamotnen's Protection - SPD"),
  tinyCommanderWisdom(33, 4, "Tiny Commander's Wisdom"),
  wardingAwayLuck(2, 5, 'Warding Away Bad Luck'),
  curseReversal(1, 8, 'Curse Reversal'),
  misfortuneStockpiling(2, 5, 'Misfortune Stockpilling'),
  spinningMoreUsual(1, 12, 'Spinning More than Usual'),
  roleNagashiBina(2, 6, 'Role of Nagashi-bina'),
  sorrowfulExiled(1, 50, 'Sorrowful Exiled Doll'),
  cursedDoll(1, 120, 'Cursed Hina Doll'),
  earthSpiritsParty(2, 5, 'Earth Spirits Palace Party'),
  hellNecromancer(2, 5, "Hell's Necromancer"),
  extraAttack(2, 12, 'Extra Attack'),
  apparitionCarrier(1, 15, 'Apparition Carrier'),
  vengefulCatStep(1, 120, "Vengeful Cat's Erratic Step"),
  ashRekindling(1, 66, 'Ash Rekindling'),
  selfTokamak(1, 88, 'Self-Tokamak'),
  highBlazing(5, 12, 'High Blazing'),
  smallMpRecovery(1, 10, 'Small MP Recovery'),
  traumaRecollection(2, 5, 'Trauma Recollection'),
  spellRecollection(5, 5, 'Spell Card Recollection'),
  traumaRecreation(1, 70, 'Trauma Recreation'),
  terrifyingHypnotism(3, 40, 'Terrifying Hypnotism'),
  physicalCounter(3, 4, 'Physical Counter'),
  lastFortress(1, 10, 'Last Fortress'),
  ruinousStrength(2, 5, 'Ruinous Super Strength'),
  hoshigumaDish(1, 10, 'Hoshiguma Dish'),
  adamantHelix(1, 12, 'Adamant Helix'),
  dreadfulWaves(1, 40, 'Dreadful Raging Waves'),
  ablityPhenomena(2, 30, 'Ability to Cause Phenomena'),
  lastFortressPlus(1, 50, 'Last Fortress+'),
  sdmResidents(2, 5, 'SDM Residents'),
  gatekeeperDuty(2, 6, "Gatekeeper's Duty"),
  natural(2, 5, 'Natural'),
  gatekeeperNap(2, 5, 'Gatekeeper Nap'),
  chinaQigong(5, 8, 'China Qigong'),
  rocKillingFist(1, 70, 'Roc-Killing Fist'),
  spiralLightStep(1, 45, 'Spiral Light Step'),
  chineseGirlQigong(1, 70, "Chinese Girl's Super Qigong"),
  manipulationDolls(2, 5, 'Manipulation of Dolls'),
  dollGuard(2, 5, 'Doll Guard'),
  maliceAlice(2, 5, 'MAlice Cannon (Alice)'),
  dollMobility(4, 8, 'Enhanced Doll Mobility'),
  controlledDolls(8, 15, 'Precisely Controlled Dolls'),
  firstAidDolls(1, 50, 'First-Aid Dolls'),
  additionalGuards(1, 60, 'Additional Doll Guards'),
  girlKnowledgeShade(1, 10, 'Girl of Knowledge and Shade'),
  passivePhilosopher(2, 4, "Passive Philosopher's Stone"),
  unmovingGreatLibrary(2, 5, 'The Unmoving Great Library'),
  infiniteBookCollection(1, 50, 'Infinite Book Collection'),
  asthmaMedicine(3, 35, 'Asthma Medicine'),
  speedyIncantation(5, 20, 'Speedy Incantation'),
  peopleMoon(1, 8, 'People of the Moon'),
  healingLimitBreak(1, 20, 'Healing Limit Break'),
  pharmacistMixing(1, 10, "Pharmacist's Poison Mixing"),
  specialEndurance(10, 10, 'Special Endurance Medicine'),
  lunarSageWisdom(10, 8, "Lunar Sage's Wisdom"),
  poisonMixing(1, 56, 'Fatal Poison Mixing'),
  mindModulation(2, 5, 'Broad Mind Modulation'),
  wavelengthInsanity(2, 5, 'Wavelength of Insanity'),
  intenseVertigo(1, 10, 'Intense Vertigo'),
  vaporousRedEyes(1, 50, 'Mountain Vaporous Red Eyes'),
  enhancedMindModulation(1, 60, 'Enhanced Mind Modulation'),
  grandVertigo(1, 80, 'Grand Vertigo'),
  believersMoriya(2, 5, 'Believers of Moriya'),
  expansionConsciousness(2, 12, 'Expansion of Consciousness'),
  lastWish(2, 5, 'Last Wish'),
  moriyaProtection(2, 5, "Moriya's Divine Protection"),
  powerLivingGod(2, 5, 'Power of the Living God'),
  miracleFafrotskies(1, 60, 'Miracle of Fafrotskies'),
  sacrificalMaiden(1, 40, 'Sacrificial Shrine Maiden'),
  hisoutenGuard(2, 5, 'Hisouten Guard'),
  magicCounter(3, 4, 'Magic Counter'),
  hagoromoSky(2, 4, 'Hagoromo Like Sky'),
  suppleHagoromo(2, 5, 'Supple Hagoromo'),
  heavenlyBlow(1, 7, "Heavenly Maiden's Blow"),
  lightningFish(6, 10, 'Lightning Fish'),
  magicCounterPlus(1, 80, 'Magic Counter+'),
  thunderAbtruseClouds(1, 40, 'Thunder in the Abtruse Clouds'),
  pearlClawedDragon(3, 66, 'Pearl of the 5-Clawed Dragon'),
  ibukiGourd(2, 8, 'Ibuki Gourd'),
  freeSpiritedOni(1, 12, 'Free-Spirited Oni'),
  fogLabyrinth(2, 5, 'Fog Labyrinth'),
  artOniBinding(3, 4, 'Art of Oni Binding'),
  earthSpiritDense(1, 40, 'Earth Spirit -Dense-'),
  pandemonicSprinkle(8, 30, 'Pandemonic Sprinkle'),
  abilityShikigamis(1, 7, 'Ability to Use Shikigamis'),
  superFastHardArithmetic(1, 20, 'Super-Fast Hard Arithmetic'),
  shikigamiDefense(1, 25, 'Shikigami Defense'),
  hermitFoxThoughts(10, 6, 'Hermit Fox Thoughts'),
  kokkuriContract(40, 4, "Kokkuri's Contract"),
  friedTofuPower(8, 15, 'Fried Tofu Power-Up'),
  other(5, 5, 'a');

  @override
  final int maxLevel;
  @override
  final int levelCost;
  @override
  final String name;

  const CommonSkill(this.maxLevel, this.levelCost, this.name);
}

enum Spell implements Skill {
  yinYang(5, 5, 'Yin-Yang Orb'),
  fantasySeal(5, 5, 'Fantasy Seal'),
  exorcisingBorder(5, 5, 'Exorcising Border'),
  greatBarrier(5, 5, 'Great Hakurei Barrier'),
  magicMissile(5, 5, 'Magic Missile'),
  asteroidBelt(5, 5, 'Asteroid Belt'),
  masterSparkMarisa(5, 5, 'Master Spark'),
  concentration(5, 5, 'Concentration'),
  firstAid(5, 5, 'First Aid'),
  battleCommand(5, 5, 'Battle Command'),
  preciseDiagnosis(5, 25, 'Precise Diagnosis'),
  ancientHistory(5, 5, 'Ancient History -Old History-'),
  newHistory(5, 5, 'New History -Next History-'),
  treasuresSword(5, 5, 'Three Treasures - Sword'),
  treasuresMirror(5, 5, 'Three Treasures - Mirror'),
  rabiesBite(5, 5, 'Rabies Bite'),
  expelleeCanaan(5, 5, "Expellee's Canaan"),
  presentSlash(9, 5, 'Present Life Slash'),
  slashEternity(9, 5, 'Slash of Eternity'),
  slashKarmaWind(9, 5, "God's Slash of Karma Wind"),
  slashSixSenses(9, 5, 'Slash Clearing the Six Senses'),
  karakasaFlash(5, 5, 'Karakasa Surprising Flash'),
  rainyGhostStory(5, 5, "A Rainy Night's Ghost Story"),
  drizzlingRaindrops(5, 5, 'Drizzling Large Raindrops'),
  moonlightRay(5, 5, 'Moonlight Ray'),
  darkSideMoon(5, 5, 'Dark Side of the Moon'),
  demarcation(5, 5, 'Demarcation'),
  icicleFall(5, 5, 'Icicle Fall'),
  diamondBlizzard(5, 5, 'Diamond Blizzard'),
  perfectFreeze(5, 5, 'Perfect Freeze'),
  whiteAlbum(5, 5, 'White Album'),
  autumnSky(5, 5, 'Autumn Sky'),
  warmHarvest(5, 5, 'Warm Colour Harvest'),
  sweetPotato(5, 5, 'Sweet Potato Room'),
  owotoshiHarvester(5, 5, 'Owotoshi Harvester'),
  shortExpectancy(5, 5, 'Short Life Expectancy'),
  ferriageFog(5, 5, 'Ferriage in the Deep Fog'),
  confinesAvici(5, 5, 'Narrow Confines of Avici'),
  scytheChoosesDead(5, 5, 'Scythe that Chooses the Dead'),
  flightIdaten(5, 5, 'Flight of Idaten'),
  phoenixWings(5, 5, 'Phoenix Spread Wings'),
  kimontonkou(5, 5, 'Kimontonkou'),
  kappaWatterfall(5, 5, "Kappa's Illusionary Waterfall"),
  extendingArm(5, 5, 'Exteeeending Aaaaarm'),
  superScope(5, 5, 'Super Scope 3D'),
  portableMachine(5, 5, 'Portable Versatile Machine'),
  largeSmallBox(5, 5, 'Large Box and Small Box'),
  midnightRitual(5, 5, 'Midnight Anathema Ritual'),
  grudgeReturning(5, 5, 'Grudge Returning'),
  jealousyKindLovely(5, 5, 'Jealousy of Kind and Lovely'),
  cometEarth(5, 5, 'Comet on Earth'),
  fireflyPhenomenon(5, 5, 'Firefly Phenomenon'),
  nightbugTornado(5, 5, 'Nightbug Tornado'),
  dragonJewel(5, 5, "Dragon's Neck Jewel"),
  buddhaBowl(5, 5, "Buddha's Stone Bowl"),
  swallowShell(5, 5, "Swallow's Cowrie Shell"),
  bulletHourai(5, 5, 'Bullet Branch of Hourai'),
  firePhoenix(5, 5, 'Fire Bird -Flying Phoenix-'),
  tsukiCurse(5, 5, "Tsuki no Iwakasa's Curse"),
  fujiyamaVolcano(5, 5, 'Fujiyama Volcano'),
  windGodFan(5, 5, "Wind God's Fan"),
  peerlessWindGod(5, 5, 'Peerless Wind God'),
  sarutahikoGuidance(5, 5, "Sarutahiko's Guidance"),
  divineAdvent(5, 5, "Divine Grandson's Advent"),
  illDive(7, 5, 'Ill-Starred Dive'),
  poisonousDance(7, 5, "Poisonous Moth's Dark Dance"),
  midnightChorus(7, 5, 'Midnight Chorus Master'),
  mysteriousSong(5, 5, 'Mysterious Song'),
  higekiriArm(5, 5, "Higekiri's Cursed Arm"),
  echoForestGods(5, 5, 'Echo of the Nine Forest Gods'),
  divingWaltz(5, 5, 'Diving Waltz of the Raijuu'),
  breathHermit(5, 5, 'Breath of the Hermit'),
  summonDragonTiger(5, 25, 'Summon Dragon and Tiger'),
  goldRush(5, 5, 'Gold Rush'),
  rareMetalDetector(5, 5, 'Rare Metal Detector'),
  nazrinPendulum(5, 5, 'Nazrin Pendulum'),
  misfortuneBiorhythm(5, 5, "Misfortune God's Biorhythm"),
  painFlow(5, 5, 'Pain Flow'),
  oldLadyFire(5, 5, "Old Lady Ohgane's Fire"),
  catWalk(7, 5, "Cat's Walk"),
  vengefulSpirit(7, 5, 'Vengeful Cannibal Spirit'),
  hellNeedleHill(7, 5, "Former Hell's Needle Hill"),
  blazingWheel(7, 5, 'Blazing Wheel'),
  gigaFlare(5, 5, 'Giga Flare'),
  nuclearReaction(5, 5, 'Intense Nuclear Reaction'),
  hellTokamak(5, 5, "Hell's Tokamak"),
  brainFingerprint(5, 5, 'Brain Fingerprint'),
  supernaturalPhenomenon(5, 5, 'Supernatural Phenomenon'),
  koThreeSteps(5, 5, 'Knockout in Three Steps'),
  irremovableShackles(5, 5, 'Irremovable Shackles'),
  brilliantGem(5, 5, 'Brilliant Light Gem'),
  mountainBreaker(5, 5, 'Mountain Breaker'),
  colorfulRain(5, 5, 'Colourful Rain'),
  healer(5, 5, 'Healer'),
  artfulSacrifice(7, 5, 'Artful Sacrifice'),
  littleLegion(7, 5, 'Little Legion'),
  hangedHourai(7, 5, 'Hanged Hourai Doll'),
  tripWire(7, 5, 'Trip Wire'),
  royalFlare(7, 5, 'Royal Flare'),
  princessUndine(7, 5, 'Princess Undine'),
  djinnGust(7, 5, 'Djinn Gust'),
  satelliteHimawari(7, 5, 'Satellite Himawari'),
  silentSelene(7, 5, 'Silent Selene'),
  mercurySea(5, 5, 'Mercury Sea'),
  omoikaneDevice(5, 5, "Omoikane's Device"),
  houraiElixir(5, 5, 'Hourai Elixir'),
  astronomicalEntombing(5, 5, 'Astronomical Entombing'),
  lunaticRedEyes(5, 5, 'Lunatic Red Eyes'),
  mindStarmine(5, 5, 'Mind Starmine'),
  discarder(5, 5, 'Discarder'),
  gasWovenOrb(5, 5, 'Gas-Woven Orb'),
  grandPatriotElixir(5, 5, "Grand Patriot's Elixir"),
  nightGuesstStars(9, 5, 'Night of Bright Guest Stars'),
  mosesMiracle(9, 5, "Moses's Miracle"),
  yasakaWind(5, 5, "Yasaka's Divine Wind"),
  miracleFruit(5, 5, 'Miracle Fruit'),
  elekiterPalace(5, 5, 'Elekiter Dragon Palace'),
  lightDragonSigh(5, 5, "Light Dragon's Sigh"),
  thunedrcloudStickleback(5, 5, 'Thundercloud Stickleback'),
  whiskersDragonGod(5, 5, 'Whiskers of the Dragon God'),
  throwingTogakushi(5, 5, 'Throwing Mt.Togakushi'),
  throwingAtlas(5, 5, 'Throwing Atlas'),
  gatheringDissipating(5, 5, 'Gathering and Dissipating'),
  missingPower(5, 5, 'Missing Power'),
  artSegakiBinding(5, 5, 'Art of Segaki Binding'),
  foxTanukiLaser(7, 5, 'Fox-Tanuki Youkai Laser'),
  princessTenko(7, 5, 'Princess Tenko'),
  soaringOzuno(7, 5, 'Soaring En no Ozuno'),
  banquetGeneralGods(5, 5, 'Banquet of General Gods'),
  eightyMillionBoards(5, 5, 'Eighty Million Holy Boards'),
  other(5, 5, 'a');

  @override
  final int maxLevel;
  @override
  final int levelCost;
  @override
  final String name;

  const Spell(this.maxLevel, this.levelCost, this.name);
}

class SkillData {
  late int hpBoost;
  late int mpBoost;
  late int tpBoost;
  late int atkBoost;
  late int defBoost;
  late int magBoost;
  late int mndBoost;
  late int spdBoost;
  late int evaBoost;
  late int accBoost;
  late int affBoost;
  late int resBoost;
  late int motivatedHeart;
  late int handsOnExperience;
  late List<int> personalSkills;
  late List<int> personalSpells;
  late List<int> subclassSkills;
  late List<int> subclassSpells;

  int getBoostData(int index) {
    return <int>[
      hpBoost, mpBoost, tpBoost, atkBoost, defBoost, magBoost,
      mndBoost, spdBoost, evaBoost, accBoost, affBoost, resBoost,
    ][index];
  }

  int getExpData(int index) {
    return <int>[motivatedHeart, handsOnExperience][index];
  }

  void setBoostData(int index, String raw) {
    int value = int.parse(raw);
    switch (index) {
      case 0: hpBoost = value; break;
      case 1: mpBoost = value; break;
      case 2: tpBoost = value; break;
      case 3: atkBoost = value; break;
      case 4: defBoost = value; break;
      case 5: magBoost = value; break;
      case 6: mndBoost = value; break;
      case 7: spdBoost = value; break;
      case 8: evaBoost = value; break;
      case 9: accBoost = value; break;
      case 10: affBoost = value; break;
      case 11: resBoost = value; break;
    }
  }

  void setExpData(int index, String raw) {
    int value = int.parse(raw);
    switch (index) {
      case 0: motivatedHeart = value; break;
      case 1: handsOnExperience = value; break;
    }
  }

  SkillData.fromBytes(List<int> bytes, int offset) {
    hpBoost = bytes[offset];
    mpBoost = bytes[offset + 2];
    tpBoost = bytes[offset + 4];
    atkBoost = bytes[offset + 6];
    defBoost = bytes[offset + 8];
    magBoost = bytes[offset + 10];
    mndBoost = bytes[offset + 12];
    spdBoost = bytes[offset + 14];
    evaBoost = bytes[offset + 16];
    accBoost = bytes[offset + 18];
    affBoost = bytes[offset + 20];
    resBoost = bytes[offset + 22];
    motivatedHeart = bytes[offset + 36];
    handsOnExperience = bytes[offset + 38];
    personalSkills = List<int>.filled(10, 0);
    personalSpells = List<int>.filled(10, 0);
    subclassSkills = List<int>.filled(10, 0);
    subclassSpells = List<int>.filled(10, 0);
    for (int i = 0; i < 10; i++) {
      personalSkills[i] = bytes[offset + 40 + (i * 2)];
      personalSpells[i] = bytes[offset + 60 + (i * 2)];
      subclassSkills[i] = bytes[offset + 80 + (i * 2)];
      subclassSpells[i] = bytes[offset + 100 + (i * 2)];
    }
  }

  SkillData.from(SkillData other) {
    hpBoost = other.hpBoost;
    mpBoost = other.mpBoost;
    tpBoost = other.tpBoost;
    atkBoost = other.atkBoost;
    defBoost = other.defBoost;
    magBoost = other.magBoost;
    mndBoost = other.mndBoost;
    spdBoost = other.spdBoost;
    evaBoost = other.evaBoost;
    accBoost = other.accBoost;
    affBoost = other.affBoost;
    resBoost = other.resBoost;
    motivatedHeart = other.motivatedHeart;
    handsOnExperience = other.handsOnExperience;
    personalSkills = List<int>.from(other.personalSkills);
    personalSpells = List<int>.from(other.personalSpells);
    subclassSkills = List<int>.from(other.subclassSkills);
    subclassSpells = List<int>.from(other.subclassSpells);
  }

  Iterable<int> _skillListToBytes(List<int> skills, Endian endianness) {
    return skills.fold<Iterable<int>>(
      <int>[],
      (Iterable<int> acc, int skill) => acc.followedBy(skill.toU16(endianness)),
    );
  }

  Iterable<int> toBytes(Endian endianness) {
    return <int>[
      ...hpBoost.toU16(endianness),
      ...mpBoost.toU16(endianness),
      ...tpBoost.toU16(endianness),
      ...atkBoost.toU16(endianness),
      ...defBoost.toU16(endianness),
      ...magBoost.toU16(endianness),
      ...mndBoost.toU16(endianness),
      ...spdBoost.toU16(endianness),
      ...evaBoost.toU16(endianness),
      ...accBoost.toU16(endianness),
      ...affBoost.toU16(endianness),
      ...resBoost.toU16(endianness),
      ...List<int>.filled(2 * 6, 0), // 6 empty slots
      ...motivatedHeart.toU16(endianness),
      ...handsOnExperience.toU16(endianness),
      ..._skillListToBytes(personalSkills, endianness),
      ..._skillListToBytes(personalSpells, endianness),
      ..._skillListToBytes(subclassSkills, endianness),
      ..._skillListToBytes(subclassSpells, endianness),
    ];
  }
}
