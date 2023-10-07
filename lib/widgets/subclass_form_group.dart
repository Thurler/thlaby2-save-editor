import 'package:thlaby2_save_editor/save/subclass.dart';
import 'package:thlaby2_save_editor/widgets/form.dart';
import 'package:thlaby2_save_editor/widgets/form_group.dart';

class SubclassFormGroup extends TFormGroup {
  Subclass original;
  Subclass current;

  SubclassFormGroup({required this.current}) :
    original = current,
    super(
      title: 'Skill levels (Subclass)',
      forms: <FormKey, TForm>{},
    );

  @override
  bool get hasChanges => current != original || super.hasChanges;

  void changeSubclass(Subclass newClass) {}

  void saveCurrent() => original = current;
}
