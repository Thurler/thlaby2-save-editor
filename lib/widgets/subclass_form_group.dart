import 'package:thlaby2_save_editor/save/enums/skill.dart';
import 'package:thlaby2_save_editor/save/enums/subclass.dart';
import 'package:thlaby2_save_editor/widgets/skill_form.dart';
import 'package:thlaby2_save_editor/widgets/skill_form_group.dart';

class SubclassFormGroup extends SkillFormGroup {
  bool subclassChanged = false;

  SubclassFormGroup({
    required Subclass current,
    required super.keys,
    required super.initialValueBuilder,
    required super.onValueChanged,
  }) : super(
    title: 'Skill levels (Subclass)',
    skills: current.allSkills,
  );

  @override
  bool get hasChanges => subclassChanged || super.hasChanges;

  void changeSubclass(Subclass newClass) {
    subclassChanged = true;
    keys.clear();
    forms.clear();
    for (Skill skill in newClass.allSkills) {
      SkillFormKey newKey = SkillFormKey();
      keys[skill] = newKey;
      forms[newKey] = TFormSkill(
        skill: skill,
        initialValue: '0',
        onValueChanged: onValueChanged,
        key: newKey,
      );
    }
  }

  void save() => subclassChanged = false;
}
