import 'package:flutter/material.dart';
import 'package:tfields/extensions.dart';
import 'package:tfields/logging.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/save/character_unlock.dart';
import 'package:thlaby2_save_editor/widgets/character_box.dart';

typedef CharacterUnlockFormKey = GlobalKey<CharacterUnlockFormState>;

class CharacterUnlockForm extends TForm<CharacterUnlockFlag> with THoverWidget {
  @override
  final bool hoverEnabled;

  @override
  final void Function()? onHoverTap = null;

  @override
  final void Function() hoverUpdateCallback;

  CharacterUnlockForm({
    required CharacterUnlockFlag super.initialValue,
    required this.hoverUpdateCallback,
    super.onValueChanged,
    super.validationCallback,
    super.saveWithErrorOptions,
    super.enabled = true,
    super.readonly,
    super.key,
  }) : hoverEnabled = enabled, super(title: initialValue.character.name);

  @override
  CharacterUnlockFormState createState() => CharacterUnlockFormState();
}

class CharacterUnlockFormState
    extends TFormState<CharacterUnlockFlag, CharacterUnlockForm>
    with TLoggable, THoverState<CharacterUnlockForm> {
  @override
  bool get hoverEnabled => enabled;

  @override
  Future<void> onHoverTap() async => value != null && enabled && !readonly
    ? setLockValue(isUnlocked: !value!.isUnlocked)
    : null;

  @override
  CharacterUnlockFlag? copyValue(CharacterUnlockFlag? source) =>
      source != null ? CharacterUnlockFlag.from(source) : null;

  Future<void> setLockValue({required bool isUnlocked}) async {
    if (value != null) {
      value!.isUnlocked = isUnlocked;
      String state = (value!.isUnlocked) ? 'locked' : 'unlocked';
      await log(TLogLevel.debug, '${value!.character.name} is now $state');
      widget.onValueChanged?.call(value);
      // This is done just to trigger super's value change
      value = value;
    }
  }

  @override
  Widget buildChild(BuildContext context) {
    bool isUnlocked = value?.isUnlocked ?? false;
    return CharacterBox(
      title: title.upperCaseFirstChar(),
      titleAppend: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            isUnlocked ? 'Unlocked' : 'Locked',
            style: TextStyle(
              color:
                  isHighlighted ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
          Icon(
            isUnlocked ? Icons.lock_open : Icons.lock,
            color: isHighlighted ? Theme.of(context).colorScheme.primary : null,
            size: 14,
          ),
        ],
      ),
      filename: value?.character.filename ?? '',
      unlocked: value?.isUnlocked ?? false,
      isHighlighted: isHighlighted,
    );
  }
}
