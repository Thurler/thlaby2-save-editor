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
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  monk(
    'Monk',
    skills: <Skill>[],
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  warrior(
    'Warrior',
    skills: <Skill>[],
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  sorcerer(
    'Sorcerer',
    skills: <Skill>[],
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  healer(
    'Healer',
    skills: <Skill>[],
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  enhancer(
    'Enhancer',
    skills: <Skill>[],
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  hexer(
    'Hexer',
    skills: <Skill>[],
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  toxicologist(
    'Toxicologist',
    skills: <Skill>[],
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  magician(
    'Magician',
    skills: <Skill>[],
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  herbalist(
    'Herbalist',
    skills: <Skill>[],
    spells: <SubclassSpell>[],
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
    spells: <SubclassSpell>[],
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
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  archmage(
    'Archmage',
    skills: <Skill>[
      CommonSkill.sutraStrength,
      CommonSkill.sutraShield,
      CommonSkill.sutraChant,
      CommonSkill.sutraFocus,
      CommonSkill.sutraDrang,
      CommonSkill.sutraRecovery,
      CommonSkill.sutraMana,
      CommonSkill.sutraResistance,
      CommonSkill.sutraImmunity,
    ],
    spells: <SubclassSpell>[SubclassSpell.test1, SubclassSpell.test2],
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
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  ninja(
    'Ninja',
    skills: <Skill>[],
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  oracle(
    'Oracle',
    skills: <Skill>[],
    spells: <SubclassSpell>[],
    isUnique: false,
  ),
  holyblessing(
    'Holy Blessing',
    skills: <Skill>[],
    spells: <SubclassSpell>[],
    isUnique: true,
  ),
  dragongodpower(
    "Dragon God's Power",
    skills: <Skill>[],
    spells: <SubclassSpell>[],
    isUnique: true,
  ),
  winner(
    '*WINNER*',
    skills: <Skill>[],
    spells: <SubclassSpell>[],
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
}
