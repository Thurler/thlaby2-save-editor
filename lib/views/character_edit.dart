import 'package:flutter/material.dart';
import 'package:tfields/extensions.dart';
import 'package:tfields/logging.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/mixins/breakablechanges.dart';
import 'package:thlaby2_save_editor/mixins/navigate.dart';
import 'package:thlaby2_save_editor/save.dart';
import 'package:thlaby2_save_editor/save/enums/character.dart';
import 'package:thlaby2_save_editor/widgets/forms/groups/character.dart';

class CharacterValidationMessage {
  final String message;
  final void Function()? fixFunction;

  CharacterValidationMessage({required this.message, this.fixFunction});
}

class CharacterEditWidget extends StatefulWidget {
  final Character character;
  const CharacterEditWidget({required this.character, super.key});

  @override
  State<CharacterEditWidget> createState() => CharacterEditState();
}

class CharacterEditState extends State<CharacterEditWidget>
    with
        TLoggable,
        SaveEditor,
        Navigatable<CharacterEditWidget>,
        TDialogDisplayer<CharacterEditWidget>,
        TDiscardableChanges<CharacterEditWidget>,
        BreakableChanges<CharacterEditWidget> {
  late final CharacterForm _characterForm;

  @override
  bool get hasChanges => _characterForm.hasChanges;

  @override
  Future<void> saveChanges() async {
    // Check if there are invalid fields, properly show them to user
    if (!_characterForm.validate()) {
      await log(TLogLevel.warning, 'Attempting to save invalid data');
      List<String> messages = _characterForm.errorSaveWarningMessages;
      bool doSave = await showSaveWarningDialog(
        'Some validation errors were detected, and some of them might require '
        'an action to be taken in order to save:\n\n${messages.join('\n')}\n\n '
        'Please make sure you are fine with the actions above',
        breaking: false,
      );
      if (!doSave) {
        return;
      }
    }

    // Get save file reference and commit changes to forms
    saveFile.characterData[widget.character.index] =
        _characterForm.makeEntity(null);
    // Saving the form values will already apply any necessary fixes to the
    // save file based on what was wrong (e.g.: unlock main/sub equips)
    _characterForm.saveValues();

    await log(TLogLevel.info, 'Saved character data changes');
    // Refresh widget to get rid of the save symbol
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _characterForm = CharacterForm(
      enabled: true,
      setState: setState,
      character: widget.character,
      saveFile: saveFile,
    );

    // Call setState one last time after build runs for the first time
    // This causes the hasChanges and hasErrors to show up from initState
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _characterForm.recalculateLimits(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasChanges,
      onPopInvokedWithResult: onPopInvoked,
      child: TCommonScaffold(
        title: "Edit ${widget.character.name.upperCaseFirstChar()}'s data",
        floatingActionButton: saveButton,
        padding: const EdgeInsets.fromLTRB(20, 0, 250, 0),
        background: Opacity(
          opacity: 0.8,
          child: Image.asset(
            'img/character/${widget.character.filename}.png',
            alignment: Alignment.bottomRight,
            fit: BoxFit.fitHeight,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        children: <Widget>[
          CharacterFormWidget(form: _characterForm),
        ],
      ),
    );
  }
}
