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
  final bool hasBorder;

  const TForm({
    required this.title,
    required this.subtitle,
    this.enabled = true,
    this.hasBorder = false,
    this.errorMessage = '',
    super.key,
  }) : super();

  Widget buildTitleTile(String errorText) {
    return ListTile(
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
    );
  }

  Widget buildFormField();

  @override
  Widget build(BuildContext context) {
    String errorText = (errorMessage != '') ? '\n$errorMessage' : '';
    Widget result = Row(
      children: <Widget>[
        Expanded(child: buildTitleTile(errorText)),
        Expanded(child: buildFormField()),
      ],
    );
    if (hasBorder) {
      result = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: TForm.subtitleColor),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: result,
        ),
      );
    }
    return result;
  }
}

@immutable
class TStringForm extends TForm {
  final TextEditingController controller;
  final String hintText;
  final void Function()? onValueUpdate;
  final Widget? suffixIcon;

  TStringForm({
    required super.title,
    required super.subtitle,
    required this.controller,
    this.hintText = '',
    this.onValueUpdate,
    this.suffixIcon,
    super.errorMessage,
    super.hasBorder,
    super.enabled,
    super.key,
  }) : super() {
    if (onValueUpdate != null) {
      controller.addListener(onValueUpdate!);
    }
  }

  List<TextInputFormatter> getFormatters() => <TextInputFormatter>[];

  @override
  Widget buildFormField() {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      style: const TextStyle(fontSize: 18),
      inputFormatters: getFormatters(),
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      ),
    );
  }
}

@immutable
class TNumberForm extends TStringForm {
  final int maxLength;
  final String Function(String value) validationCallback;

  TNumberForm({
    required super.title,
    required super.subtitle,
    required super.controller,
    required this.maxLength,
    required this.validationCallback,
    super.hintText,
    super.onValueUpdate,
    super.errorMessage,
    super.enabled,
    super.key,
  }) : super() {
    if (onValueUpdate != null) {
      controller.addListener(onValueUpdate!);
    }
  }

  @override
  List<TextInputFormatter> getFormatters() => <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    NumberInputFormatter(
      maxLength: maxLength,
      validationCallback: validationCallback,
    ),
  ];
}

@immutable
class TDropdownForm extends TForm {
  final void Function(String?) onChanged;
  final List<String> options;
  final String hintText;
  final String value;

  const TDropdownForm({
    required super.title,
    required super.subtitle,
    required this.value,
    required this.hintText,
    required this.options,
    required this.onChanged,
    super.errorMessage,
    super.hasBorder,
    super.enabled,
    super.key,
  }) : super();

  @override
  Widget buildFormField() {
    return DropdownButton<String>(
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
    );
  }
}
