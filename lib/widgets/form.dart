import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thlaby2_save_editor/text_formatter.dart';
import 'package:thlaby2_save_editor/widgets/clickable.dart';
import 'package:thlaby2_save_editor/widgets/spaced_row.dart';
import 'package:thlaby2_save_editor/widgets/switch.dart';

typedef FormKey<T> = GlobalKey<TFormState<T, TForm<T>>>;
typedef SwitchFormKey = GlobalKey<TFormSwitchState>;
typedef DropdownFormKey = GlobalKey<TFormDropdownState>;
typedef StringFormKey = GlobalKey<TFormStringState<TFormString>>;
typedef NumberFormKey = GlobalKey<TFormNumberState<TFormNumber>>;
typedef FixedFormKey = GlobalKey<TFormFixedState>;

class TFormTitle extends StatelessWidget {
  static const Color subtitleColor = Colors.grey;

  final String title;
  final String subtitle;
  final String errorMessage;

  const TFormTitle({
    required this.title,
    required this.subtitle,
    required this.errorMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: RichText(
        text: TextSpan(
          style: const TextStyle(color: subtitleColor),
          children: <TextSpan>[
            TextSpan(text: subtitle),
            TextSpan(
              text: errorMessage != '' ? '\n$errorMessage' : '',
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

abstract class TFormField extends StatelessWidget {
  const TFormField({super.key});
}

class TFormSwitchField extends TFormField {
  final bool enabled;
  final bool value;
  final String offText;
  final String onText;
  final void Function(bool value) updateValue;

  const TFormSwitchField({
    required this.enabled,
    required this.value,
    required this.offText,
    required this.onText,
    required this.updateValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TSwitch(
      onChanged: enabled ? updateValue : null,
      offText: offText,
      onText: onText,
      value: value,
    );
  }
}

class TFormDropdownField extends TFormField {
  final bool enabled;
  final String value;
  final String hintText;
  final List<String> options;
  final void Function(String? value) updateValue;

  const TFormDropdownField({
    required this.enabled,
    required this.value,
    required this.hintText,
    required this.options,
    required this.updateValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      hint: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 15),
        child: Text(hintText),
      ),
      value: (value != '') ? value : null,
      onChanged: enabled ? updateValue : null,
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(option),
          ),
        );
      }).toList(),
    );
  }
}

class TFormStringField extends TFormField {
  final bool enabled;
  final String hintText;
  final TextEditingController controller;
  final List<TextInputFormatter> formatters;
  final List<Widget> icons;

  const TFormStringField({
    required this.enabled,
    required this.hintText,
    required this.controller,
    required this.formatters,
    this.icons = const <Widget>[],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      style: const TextStyle(fontSize: 18),
      inputFormatters: formatters,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        suffixIcon: icons.isNotEmpty
          ? SpacedRow(
              mainAxisSize: MainAxisSize.min,
              spacer: const SizedBox(width: 2),
              children: icons,
            )
          : null,
      ),
    );
  }
}

class TFormFixedField extends TFormField {
  final String text;
  final List<Widget> icons;

  const TFormFixedField({
    required this.text,
    required this.icons,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: TFormTitle.subtitleColor.withOpacity(0.5),
            width: 2,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: <Widget>[
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 10),
            if (icons.isNotEmpty)
              SpacedRow(
                mainAxisSize: MainAxisSize.min,
                spacer: const SizedBox(width: 2),
                children: icons,
              ),
          ],
        ),
      ),
    );
  }
}

abstract class TForm<U> extends StatefulWidget {
  static String _alwaysValid(dynamic value) => '';

  final bool enabled;
  final String title;
  final String subtitle;
  final String errorMessage;
  final U initialValue;
  final String Function(U) validationCallback;
  final ValueChanged<U?>? onValueChanged;

  const TForm({
    required this.enabled,
    required this.title,
    required this.subtitle,
    required this.initialValue,
    this.validationCallback = _alwaysValid,
    this.errorMessage = '',
    this.onValueChanged,
    super.key,
  });
}

abstract class TFormState<U, T extends TForm<U>> extends State<T> {
  String errorMessage = '';
  late U initialValue;

  String _title = '';
  String get title => _title;
  set title(String newValue) {
    setState(() {
      _title = newValue;
    });
  }

  String _subtitle = '';
  String get subtitle => _subtitle;
  set subtitle(String newValue) {
    setState(() {
      _subtitle = newValue;
    });
  }

  TFormField get field;

  bool get hasChanges => value != initialValue;
  bool get hasErrors => errorMessage != '';

  late U _value;
  U get value => _value;
  set value(U newValue) {
    _value = newValue;
    validate();
  }

  int get intValue;
  BigInt get bigIntValue;

  void validate() {
    setState(() {
      errorMessage = widget.validationCallback(value);
    });
  }

  void resetInitialValue() {
    initialValue = value;
  }

  U saveValue() {
    resetInitialValue();
    return value;
  }

  int saveIntValue() {
    resetInitialValue();
    return intValue;
  }

  BigInt saveBigIntValue() {
    resetInitialValue();
    return bigIntValue;
  }

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _subtitle = widget.subtitle;
    value = widget.initialValue;
    initialValue = widget.initialValue;
    validate();
  }

  @override
  Widget build(BuildContext context) {
    return SpacedRow(
      children: <Widget>[
        TFormTitle(
          title: _title,
          subtitle: _subtitle,
          errorMessage: errorMessage,
        ),
        field,
      ],
    );
  }
}

class TFormSwitch extends TForm<bool> {
  final String offText;
  final String onText;

  const TFormSwitch({
    required this.offText,
    required this.onText,
    required super.enabled,
    required super.title,
    required super.subtitle,
    required super.initialValue,
    super.validationCallback,
    super.onValueChanged,
    super.errorMessage,
    super.key,
  });

  @override
  State<TFormSwitch> createState() => TFormSwitchState();
}

class TFormSwitchState extends TFormState<bool, TFormSwitch> {
  void _updateValue(bool value) {
    setState(() {
      super.value = value;
    });
    widget.onValueChanged?.call(value);
  }

  @override
  TFormField get field => TFormSwitchField(
    enabled: widget.enabled,
    offText: widget.offText,
    onText: widget.onText,
    updateValue: _updateValue,
    value: super.value,
  );

  @override
  int get intValue => value ? 1 : 0;

  @override
  BigInt get bigIntValue => value ? BigInt.one : BigInt.zero;
}

class TFormDropdown extends TForm<String> {
  final List<String> options;
  final String hintText;

  const TFormDropdown({
    required this.hintText,
    required this.options,
    required super.enabled,
    required super.title,
    required super.subtitle,
    required super.initialValue,
    super.validationCallback,
    super.onValueChanged,
    super.errorMessage,
    super.key,
  });

  @override
  State<TFormDropdown> createState() => TFormDropdownState();
}

class TFormDropdownState extends TFormState<String, TFormDropdown> {
  void _updateValue(String? value) {
    if (value == null) {
      return;
    }
    setState(() {
      super.value = value;
    });
    widget.onValueChanged?.call(value);
  }

  @override
  TFormField get field => TFormDropdownField(
    enabled: widget.enabled,
    value: super.value,
    hintText: widget.hintText,
    options: widget.options,
    updateValue: _updateValue,
  );

  @override
  int get intValue => 0;

  @override
  BigInt get bigIntValue => BigInt.zero;
}

class TFormString extends TForm<String> {
  final List<TextInputFormatter> formatters;
  final String hintText;

  const TFormString({
    required super.enabled,
    required super.title,
    required super.subtitle,
    required super.initialValue,
    this.hintText = '',
    this.formatters = const <TextInputFormatter>[],
    super.errorMessage = '',
    super.validationCallback,
    super.onValueChanged,
    super.key,
  });

  @override
  State<TFormString> createState() => TFormStringState<TFormString>();
}

class TFormStringState<T extends TFormString> extends TFormState<String, T> {
  final TextEditingController controller = TextEditingController();
  late List<TextInputFormatter> formatters;

  @override
  set value(String newValue) {
    controller.text = newValue;
    super.value = newValue;
  }

  @override
  void initState() {
    super.initState();
    formatters = widget.formatters;
    controller.text = widget.initialValue;
    controller.addListener(() {
      super.value = controller.text;
      widget.onValueChanged?.call(controller.text);
    });
  }

  @override
  TFormField get field => TFormStringField(
    enabled: widget.enabled,
    hintText: widget.hintText,
    controller: controller,
    formatters: formatters,
  );

  @override
  int get intValue => int.parse(_value.replaceAll(',', ''));

  @override
  BigInt get bigIntValue => BigInt.parse(_value.replaceAll(',', ''));
}

class TFormNumber extends TFormString {
  static String _forceMinMax(BigInt? min, BigInt? max, String current) {
    BigInt value = BigInt.parse(current);
    if (min != null && value < min) {
      return min.toString();
    }
    if (max != null && value > max) {
      return max.toString();
    }
    return current;
  }

  static NumberInputFormatter makeFormatter(BigInt? min, BigInt? max) {
    return NumberInputFormatter(
      maxLength: max != null ? max.toString().length + 1 : null,
      validationCallback: (String v) => _forceMinMax(min, max, v),
    );
  }

  final BigInt? minValue;
  final BigInt? maxValue;

  TFormNumber({
    required super.enabled,
    required super.title,
    required super.subtitle,
    required super.initialValue,
    this.minValue,
    this.maxValue,
    super.errorMessage = '',
    super.validationCallback,
    super.onValueChanged,
    super.key,
  }) : super(
    formatters: <TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
      makeFormatter(minValue, maxValue),
    ],
  );

  @override
  State<TFormNumber> createState() => TFormNumberState<TFormNumber>();
}

class TFormNumberState<T extends TFormNumber> extends TFormStringState<T> {
  BigInt? _minValue;
  BigInt? _maxValue;

  BigInt? get minValue => _minValue;
  set minValue(BigInt? newValue) {
    _minValue = newValue;
    formatters[1] = TFormNumber.makeFormatter(newValue, maxValue);
  }

  BigInt? get maxValue => _maxValue;
  set maxValue(BigInt? newValue) {
    _maxValue = newValue;
    formatters[1] = TFormNumber.makeFormatter(minValue, newValue);
  }

  @override
  void initState() {
    super.initState();
    minValue = widget.minValue;
    maxValue = widget.maxValue;
  }
}

class TFormFixed extends TFormString {
  final void Function() setCallback;
  final String emptyValue;

  const TFormFixed({
    required super.initialValue,
    required super.title,
    required super.subtitle,
    required this.setCallback,
    required this.emptyValue,
    super.errorMessage = '',
    super.validationCallback,
    super.onValueChanged,
    super.key,
  }) : super(enabled: false);

  @override
  State<TFormFixed> createState() => TFormFixedState();
}

class TFormFixedState extends TFormStringState<TFormFixed> {
  void _removeCallback() => value = widget.emptyValue;

  @override
  TFormField get field {
    bool isEmpty = controller.text == widget.emptyValue;
    return TFormFixedField(
      text: controller.text,
      icons: <Widget>[
        TClickable(
          onTap: widget.setCallback,
          child: Icon(
            isEmpty ? Icons.add_circle : Icons.edit,
            color: isEmpty ? Colors.green.shade300 : Colors.grey,
          ),
        ),
        if (!isEmpty)
          TClickable(
            onTap: _removeCallback,
            child: Icon(
              Icons.cancel,
              color: Colors.red.shade300,
            ),
          ),
      ],
    );
  }
}
