import 'package:thlaby2_save_editor/extensions/int_extension.dart';
import 'package:thlaby2_save_editor/save/enums/skill.dart';
import 'package:thlaby2_save_editor/widgets/form.dart';
import 'package:thlaby2_save_editor/widgets/form_group.dart';
import 'package:thlaby2_save_editor/widgets/skill_form.dart';

class SkillFormGroup extends TFormGroup<String> {
  final Map<Skill, FormKey<String>> keys;
  final Function(String?) onValueChanged;
  final int Function(int) initialValueBuilder;

  SkillFormGroup({
    required List<Skill> skills,
    required this.keys,
    required this.onValueChanged,
    required this.initialValueBuilder,
    required super.title,
  }) : super(
    forms: Map<FormKey<String>, TForm<String>>.fromEntries(
      skills.asMap().keys.map(
        (int i) => MapEntry<FormKey<String>, TForm<String>>(
          keys[skills[i]]!,
          TFormSkill(
            skill: skills[i],
            initialValue: initialValueBuilder(i).commaSeparate(),
            onValueChanged: onValueChanged,
            key: keys[skills[i]],
          ),
        ),
      ),
    ),
  );
}
