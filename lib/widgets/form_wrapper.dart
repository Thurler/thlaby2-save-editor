import 'package:flutter/material.dart';
import 'package:thlaby2_save_editor/extensions/int_extension.dart';
import 'package:thlaby2_save_editor/extensions/list_extension.dart';
import 'package:thlaby2_save_editor/widgets/badge.dart';
import 'package:thlaby2_save_editor/widgets/form.dart';

typedef SetStateFunction = void Function(void Function());

class TFormGroup {
  final String title;
  bool expanded;
  List<TFormWrapper> forms;
  bool hasChanges = false;
  bool hasErrors = false;

  void toggleExpanded() {
    expanded = !expanded;
  }

  TFormGroup({
    required this.title,
    required this.forms,
    this.expanded = false,
  });

  bool checkChanges() {
    return hasChanges = forms.any(
      (TFormWrapper form) => form.initialValue != form.getValue(),
    );
  }

  bool checkErrors() {
    return hasErrors = forms.any((TFormWrapper form) => form.error != '');
  }

  // ignore: avoid_positional_boolean_parameters
  Widget _buildHeader(BuildContext context, bool isExpanded) {
    Widget titleWidget = Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w700),
    );
    List<Widget> badges = <Widget>[];
    if (hasChanges) {
      badges.add(
        const TBadge(
          text: 'Has Changes',
          color: Colors.green,
        ),
      );
    }
    if (hasErrors) {
      badges.add(
        const TBadge(
          text: 'Has Issues',
          color: Colors.red,
        ),
      );
    }
    if (badges.isNotEmpty) {
      titleWidget = Row(
        children: <Widget>[
          Expanded(child: titleWidget),
          ...badges.separateWith(const SizedBox(width: 5)),
        ],
      );
    }
    return ListTile(title: titleWidget);
  }

  ExpansionPanel build() {
    return ExpansionPanel(
      backgroundColor: Colors.white.withOpacity(0.9),
      canTapOnHeader: true,
      isExpanded: expanded,
      headerBuilder: _buildHeader,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
        child: Column(
          children: forms.map(
            (TFormWrapper f)=>f.toForm(),
          ).toList(),
        ),
      ),
    );
  }
}

abstract class TFormWrapper {
  final SetStateFunction setStateCallback;
  final TextEditingController controller = TextEditingController();
  final String title;
  final String subtitle;
  final bool readOnly;
  String initialValue = '';
  String error = '';

  TFormWrapper({
    required this.title,
    required this.subtitle,
    required this.setStateCallback,
    this.readOnly = false,
  });

  String getValue() {
    return controller.text;
  }

  String saveValue() {
    return initialValue = getValue();
  }

  void initForm(String value) {
    initialValue = value;
    controller.text = initialValue;
  }

  Widget toForm();
}

class TStringFormWrapper extends TFormWrapper {
  void Function()? onValueUpdate;

  TStringFormWrapper({
    required super.title,
    required super.subtitle,
    required super.setStateCallback,
    this.onValueUpdate,
    super.readOnly,
  });

  @override
  Widget toForm() {
    return TStringForm(
      title: title,
      subtitle: subtitle,
      errorMessage: error,
      controller: controller,
      onValueUpdate: onValueUpdate,
      enabled: !readOnly,
    );
  }
}

class TNumberFormWrapper extends TFormWrapper {
  late BigInt minValue;
  late BigInt maxValue;
  void Function()? onValueUpdate;

  TNumberFormWrapper({
    required super.title,
    required super.subtitle,
    required super.setStateCallback,
    required this.minValue,
    required this.maxValue,
    this.onValueUpdate,
    super.readOnly,
  });

  String validate(String raw, {bool callSetState = true}) {
    String ret = raw;
    BigInt value = BigInt.parse(raw);
    if (value < minValue) {
      ret = minValue.toString();
    } else if (value > maxValue) {
      ret = maxValue.toString();
    }
    if (callSetState) {
      setStateCallback((){});
    }
    return ret;
  }

  void initNumberForm(BigInt value) {
    validate(value.toString(), callSetState: false);
    super.initForm(value.toCommaSeparatedNotation());
  }

  void updateMaxValue(BigInt newMaxValue) {
    maxValue = newMaxValue;
    if (getIntValue() > maxValue) {
      controller.text = maxValue.toCommaSeparatedNotation();
      setStateCallback((){});
    }
  }

  BigInt getIntValue() {
    return BigInt.parse(super.getValue().replaceAll(',', ''));
  }

  @override
  String saveValue() {
    return super.saveValue().replaceAll(',', '');
  }

  @override
  Widget toForm() {
    return TNumberForm(
      title: title,
      subtitle: subtitle,
      errorMessage: error,
      controller: controller,
      maxLength: maxValue.toString().length,
      validationCallback: validate,
      onValueUpdate: onValueUpdate,
      enabled: !readOnly,
    );
  }
}

class TDropdownFormWrapper extends TFormWrapper {
  final List<String> options;
  late String Function(String) validateFunction;

  TDropdownFormWrapper({
    required super.title,
    required super.subtitle,
    required super.setStateCallback,
    required this.options,
  });

  void onChanged(String? chosen, {bool callSetState = true}) {
    if (chosen != null) {
      error = validateFunction(chosen);
      controller.text = chosen;
      if (callSetState) {
        setStateCallback((){});
      }
    }
  }

  void initDropdownForm(String value, String Function(String) validation) {
    validateFunction = validation;
    onChanged(value, callSetState: false);
    super.initForm(value);
  }

  @override
  Widget toForm() {
    return TDropdownForm(
      title: title,
      subtitle: subtitle,
      errorMessage: error,
      value: controller.text,
      options: options,
      onChanged: onChanged,
      hintText: '',
    );
  }
}
