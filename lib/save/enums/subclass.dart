import 'package:thlaby2_save_editor/save/enums/skill.dart';

enum Subclass {
  none(
    'None',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  guardian(
    'Guardian',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  monk(
    'Monk',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  warrior(
    'Warrior',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  sorcerer(
    'Sorcerer',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  healer(
    'Healer',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  enhancer(
    'Enhancer',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  hexer(
    'Hexer',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  toxicologist(
    'Toxicologist',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  magician(
    'Magician',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  herbalist(
    'Herbalist',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  strategist(
    'Strategist',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  gambler(
    'Gambler',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  diva(
    'Diva',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  transcendent(
    'Transcendent',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  swordmaster(
    'Swordmaster',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  archmage(
    'Archmage',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  appraiser(
    'Appraiser',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  elementalist(
    'Elementalist',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  ninja(
    'Ninja',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  oracle(
    'Oracle',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: false,
  ),
  holyblessing(
    'Holy Blessing',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: true,
  ),
  dragongodpower(
    "Dragon God's Power",
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: true,
  ),
  winner(
    '*WINNER*',
    skills: <Skill>[],
    spells: <Spell>[],
    isUnique: true,
  );

  final String prettyName;
  final bool isUnique;
  final List<Skill> skills;
  final List<Spell> spells;

  const Subclass(
    this.prettyName, {
    required this.skills,
    required this.spells,
    required this.isUnique,
  });
}
