import 'package:thlaby2_save_editor/save/enums/subclass.dart';
import 'package:thlaby2_save_editor/widgets/skill_form_group.dart';

class SubclassFormGroup extends SkillFormGroup {
  Subclass original;
  Subclass current;

  SubclassFormGroup({
    required this.current,
    required super.keys,
    required super.initialValueBuilder,
    required super.onValueChanged,
  }) :
    original = current,
    super(
      title: 'Skill levels (Subclass)',
      skills: current.allSkills,
    );

  @override
  bool get hasChanges => current != original || super.hasChanges;

  void changeSubclass(Subclass newClass) {}

  void saveCurrent() => original = current;
}
