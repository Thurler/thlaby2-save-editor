import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thlaby2_save_editor/text_formatter.dart';

@immutable
abstract class TForm extends StatelessWidget {
  static const Color subtitleColor = Colors.grey;
  final TextStyle subtitleStyle = const TextStyle(color: subtitleColor);
  final TextStyle errorStyle = const TextStyle(color: Colors.red);
  final String errorMessage;
  final String subtitle;
  final String title;
  final bool enabled;

  const TForm({
    required this.title,
    required this.subtitle,
    this.enabled = true,
    this.errorMessage = '',
    super.key,
  }) : super();
}

@immutable
class TNumberForm extends TForm {
  final TextEditingController controller;
  final String hintText;
  final int maxLength;
  final String Function(String value) validationCallback;
  final void Function()? onValueUpdate;

  const TNumberForm({
    required super.title,
    required super.subtitle,
    required this.controller,
    required this.maxLength,
    required this.validationCallback,
    this.hintText = '',
    this.onValueUpdate,
    super.errorMessage,
    super.enabled,
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) {
    String errorText = (errorMessage != '') ? '\n$errorMessage' : '';
    return Row(
      children: <Widget>[
        Flexible(
          child: ListTile(
            title: Text(title),
            subtitle: RichText(
              text: TextSpan(
                style: subtitleStyle,
                children: <TextSpan>[
                  TextSpan(text: subtitle),
                  TextSpan(text: errorText, style: errorStyle),
                ],
              ),
            ),
          ),
        ),
        Flexible(
          child: TextFormField(
            enabled: enabled,
            controller: controller,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              NumberInputFormatter(
                maxLength: maxLength,
                validationCallback: validationCallback,
                onValueUpdate: onValueUpdate,
              ),
            ],
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            ),
          ),
        ),
      ],
    );
  }
}

@immutable
class TDropdownForm extends TForm {
  final void Function(String?) onChanged;
  final List<String> options;
  final String hintText;
  final String value;
  final bool hasBorder;

  const TDropdownForm({
    required super.title,
    required super.subtitle,
    required this.value,
    required this.hintText,
    required this.options,
    required this.onChanged,
    this.hasBorder = false,
    super.errorMessage,
    super.enabled,
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) {
    String errorText = (errorMessage != '') ? '\n$errorMessage' : '';
    Widget queryWidget = Expanded(
      child: ListTile(
        title: Text(title),
        subtitle: RichText(
          text: TextSpan(
            style: subtitleStyle,
            children: <TextSpan>[
              TextSpan(text: subtitle),
              TextSpan(text: errorText, style: errorStyle),
            ],
          ),
        ),
      ),
    );
    Widget dropdownWidget = Expanded(
      child: DropdownButton<String>(
        isExpanded: true,
        hint: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 15),
          child: Text(hintText),
        ),
        value: (value != '') ? value : null,
        onChanged: onChanged,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(option),
            ),
          );
        }).toList(),
      ),
    );
    Widget result = Row(
      children: <Widget>[
        queryWidget,
        dropdownWidget,
      ],
    );
    if (hasBorder) {
      result = Padding(
        padding: const EdgeInsets.only(right: 15),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: TForm.subtitleColor),
          ),
          child: result,
        ),
      );
    }
    return result;
  }
}
