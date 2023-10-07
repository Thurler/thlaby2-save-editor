import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/save/enums/skill.dart';
import 'package:thlaby2_save_editor/widgets/form.dart';

typedef SkillFormKey = GlobalKey<TFormSkillState>;

class TFormSkill extends TFormNumber {
  TFormSkill({
    required Skill skill,
    required super.initialValue,
    super.onValueChanged,
    super.key,
  }) : super(
    enabled: true,
    title: skill.name,
    subtitle: _buildSubtitle(skill),
    minValue: BigInt.from(skill.minLevel),
    maxValue: BigInt.from(skill.maxLevel),
  );

  static String skillSubtitle(Skill skill) => skill.maxLevel > 0
    ? 'Must be at most ${skill.maxLevel} | Uses ${skill.levelCost} skill '
        'points per level'
    : 'Innate skill';

  static String spellSubtitle(Skill skill) => 'Must be between 1 and '
      '${skill.maxLevel} | Uses ${skill.levelCost} skill points per level';

  static String _buildSubtitle(Skill skill) =>
      skill is Spell ? spellSubtitle(skill) : skillSubtitle(skill);

  @override
  State<TFormNumber> createState() => TFormSkillState();
}

class TFormSkillState extends TFormNumberState {}
