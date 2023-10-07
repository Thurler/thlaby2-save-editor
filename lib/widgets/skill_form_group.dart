import 'package:thlaby2_save_editor/extensions/int_extension.dart';
import 'package:thlaby2_save_editor/save/enums/skill.dart';
import 'package:thlaby2_save_editor/widgets/form.dart';
import 'package:thlaby2_save_editor/widgets/form_group.dart';
import 'package:thlaby2_save_editor/widgets/skill_form.dart';

class SkillFormGroup extends TFormGroup {
  SkillFormGroup({
    required List<Skill> skills,
    required Map<Skill, FormKey> keys,
    required int Function(int) initialValueBuilder,
    required Function(String?) onValueChanged,
    required super.title,
  }) : super(
    forms: Map<FormKey, TForm>.fromEntries(
      skills.asMap().keys.map(
        (int i) => MapEntry<FormKey, TForm>(
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
