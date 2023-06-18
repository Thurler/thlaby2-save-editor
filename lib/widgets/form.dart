import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thlaby2_save_editor/text_formatter.dart';
import 'package:thlaby2_save_editor/widgets/spaced_row.dart';

typedef FormKey = GlobalKey<TFormFieldState<TFormField>>;
typedef DropdownFormKey = GlobalKey<TFormDropdownFieldState>;
typedef StringFormKey = GlobalKey<TFormStringFieldState<TFormStringField>>;
typedef NumberFormKey = GlobalKey<TFormStringFieldState<TFormStringField>>;
typedef FixedFormKey = GlobalKey<TFormFixedFieldState>;

class TFormTitle extends StatelessWidget {
  static const Color subtitleColor = Colors.grey;

  final String title;
  final String subtitle;
  final String errorMessage;

  const TFormTitle({
    required this.title,
    required this.subtitle,
    this.errorMessage = '',
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

abstract class TFormField extends StatefulWidget {
  static String _alwaysValid(String value) => '';

  final bool enabled;
  final String initialValue;
  final String Function(String) validationCallback;
  final ValueChanged<String?>? onValueChanged;

  const TFormField({
    required this.enabled,
    required this.initialValue,
    this.validationCallback = _alwaysValid,
    this.onValueChanged,
    super.key,
  });
}

abstract class TFormFieldState<T extends TFormField> extends State<T> {
  late bool enabled;
  String errorMessage = '';
  String initialValue = '';
  String _value = '';

  bool get hasChanges => value != initialValue;

  bool get hasErrors => errorMessage != '';

  String get value => _value;

  set value(String newValue) {
    _value = newValue;
    validate();
  }

  void validate() {
    errorMessage = widget.validationCallback(value);
  }

  void resetInitialValue() {
    initialValue = value;
  }

  String saveValue() {
    resetInitialValue();
    return value;
  }

  int saveIntValue() {
    resetInitialValue();
    return int.parse(value.replaceAll(',', ''));
  }

  BigInt saveBigIntValue() {
    resetInitialValue();
    return BigInt.parse(value.replaceAll(',', ''));
  }

  @override
  void initState() {
    super.initState();
    enabled = widget.enabled;
    value = widget.initialValue;
    initialValue = widget.initialValue;
  }
}

class TFormDropdownField extends TFormField {
  final List<String> options;
  final String hintText;

  const TFormDropdownField({
    required this.hintText,
    required this.options,
    required super.enabled,
    required super.initialValue,
    super.validationCallback,
    super.onValueChanged,
    super.key,
  });

  @override
  State<TFormDropdownField> createState() => TFormDropdownFieldState();
}

class TFormDropdownFieldState extends TFormFieldState<TFormDropdownField> {
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
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      hint: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 15),
        child: Text(widget.hintText),
      ),
      value: (super.value != '') ? super.value : null,
      onChanged: enabled ? _updateValue : null,
      items: widget.options.map((String option) {
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
  final List<TextInputFormatter> formatters;
  final String hintText;

  const TFormStringField({
    required super.enabled,
    required super.initialValue,
    this.hintText = '',
    this.formatters = const <TextInputFormatter>[],
    super.validationCallback,
    super.onValueChanged,
    super.key,
  });

  @override
  State<TFormStringField> createState() =>
    TFormStringFieldState<TFormStringField>();
}

class TFormStringFieldState<T extends TFormStringField>
    extends TFormFieldState<T> {
  final TextEditingController controller = TextEditingController();

  @override
  set value(String newValue) {
    controller.text = newValue;
    super.value = newValue;
  }

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialValue;
    controller.addListener(() {
      super.value = controller.text;
      widget.onValueChanged?.call(controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      style: const TextStyle(fontSize: 18),
      inputFormatters: widget.formatters,
      decoration: InputDecoration(
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      ),
    );
  }
}

class TFormNumberField extends TFormStringField {
  static String _forceMinMax(BigInt? min, BigInt? max, String current) {
    BigInt value = BigInt.parse(current);
    if (min != null && value < min!) {
      return min.toString();
    }
    if (max != null && value > max!) {
      return max.toString();
    }
    return current;
  }

  final BigInt? minValue;
  final BigInt? maxValue;

  TFormNumberField({
    required super.enabled,
    required super.initialValue,
    this.minValue,
    this.maxValue,
    super.validationCallback,
    super.onValueChanged,
    super.key,
  }) : super(
    formatters: <TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
      NumberInputFormatter(
        maxLength: maxValue?.toString().length,
        validationCallback: (String v) => _forceMinMax(minValue, maxValue, v),
      ),
    ],
  );
}

class TFormFixedField extends TFormStringField {
  final List<Widget> icons;

  const TFormFixedField({
    required super.initialValue,
    this.icons = const <Widget>[],
    super.validationCallback,
    super.onValueChanged,
    super.key,
  }) : super(enabled: false);

  @override
  State<TFormFixedField> createState() => TFormFixedFieldState();
}

class TFormFixedFieldState extends TFormStringFieldState<TFormFixedField> {
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
                controller.text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 10),
            if (widget.icons.isNotEmpty)
              SpacedRow(
                mainAxisSize: MainAxisSize.min,
                spacer: const SizedBox(width: 2),
                children: widget.icons,
              ),
          ],
        ),
      ),
    );
  }
}

@immutable
class TFormData {
  final String title;
  final String subtitle;
  final TFormField field;

  const TFormData({
    required this.title,
    required this.subtitle,
    required this.field,
  });
}

class TForm extends StatelessWidget {
  final TFormTitle title;
  final TFormField field;

  const TForm({required this.title, required this.field, super.key});

  @override
  Widget build(BuildContext context) {
    return SpacedRow(children: <Widget>[title, field]);
  }
}
