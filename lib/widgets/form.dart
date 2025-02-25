import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tfields/widgets/clickable.dart';
import 'package:tfields/widgets/form/base.dart';
import 'package:tfields/widgets/form/string.dart';
import 'package:tfields/widgets/spaced_row.dart';
import 'package:thlaby2_save_editor/text_formatter.dart';

typedef NumberFormKey = GlobalKey<TFormNumberState<TFormNumber>>;
typedef FixedFormKey = GlobalKey<TFormFixedState>;

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
              TSpacedRow(
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
