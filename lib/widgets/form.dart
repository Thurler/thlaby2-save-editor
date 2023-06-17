import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thlaby2_save_editor/text_formatter.dart';
import 'package:thlaby2_save_editor/widgets/spaced_row.dart';

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

abstract class TFormField extends StatelessWidget {
  final bool enabled;
  const TFormField({required this.enabled, super.key});
}

class TFormDropdownField extends TFormField {
  final void Function(String?) onChanged;
  final List<String> options;
  final String hintText;
  final String value;

  const TFormDropdownField({
    required this.value,
    required this.hintText,
    required this.options,
    required this.onChanged,
    required super.enabled,
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
      onChanged: enabled ? onChanged : null,
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

class TForm extends StatelessWidget {
  final TFormTitle title;
  final TFormField field;

  const TForm({required this.title, required this.field, super.key});

  @override
  Widget build(BuildContext context) {
    return SpacedRow(children: <Widget>[title, field]);
  }
}

// MARKED FOR DELETION - EVERYTHING BELOW
enum FormBorder {
  full,
  fieldUnderline,
  none,
}

abstract class TLegacyForm extends StatelessWidget {

  final String title;
  final String subtitle;
  final String errorMessage;
  final bool enabled;
  final FormBorder border;

  const TLegacyForm({
    required this.title,
    required this.subtitle,
    this.enabled = true,
    this.border = FormBorder.none,
    this.errorMessage = '',
    super.key,
  }) : super();

  Widget buildFormField();

  @override
  Widget build(BuildContext context) {
    Widget field = buildFormField();
    if (border == FormBorder.fieldUnderline) {
      field = DecoratedBox(
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
          child: field,
        ),
      );
    }
    Widget result = Row(
      children: <Widget>[
        Expanded(
          child: TFormTitle(
            title: title,
            subtitle: subtitle,
            errorMessage: errorMessage,
          ),
        ),
        Expanded(child: field),
      ],
    );
    if (border == FormBorder.full) {
      result = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: TFormTitle.subtitleColor),
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
class TStringForm extends TLegacyForm {
  final TextEditingController controller;
  final String hintText;
  final void Function()? onValueUpdate;

  TStringForm({
    required super.title,
    required super.subtitle,
    required this.controller,
    this.hintText = '',
    this.onValueUpdate,
    super.errorMessage,
    super.border,
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
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      ),
    );
  }
}

@immutable
class TUneditableStringForm extends TStringForm {
  final Widget suffix;

  TUneditableStringForm({
    required super.title,
    required super.subtitle,
    required super.controller,
    required this.suffix,
    super.hintText,
    super.onValueUpdate,
    super.errorMessage,
    super.border,
    super.enabled,
    super.key,
  });

  @override
  Widget buildFormField() {
    return Row(
      children: <Widget>[
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            controller.text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(width: 10),
        suffix,
      ],
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
class TDropdownForm extends TLegacyForm {
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
    super.border,
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
