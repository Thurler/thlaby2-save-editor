import 'package:flutter/material.dart';
import 'package:tfields/logging.dart';
import 'package:tfields/widgets.dart';
import 'package:thlaby2_save_editor/mixins/navigate.dart';
import 'package:thlaby2_save_editor/save/enums/item.dart';

typedef EquipmentFormKey<I extends Item> = GlobalKey<EquipmentFormState<I>>;

class EquipmentForm<I extends Item> extends TForm<I> {
  final I? emptyItem;

  const EquipmentForm({
    required super.enabled,
    required super.title,
    required super.initialValue,
    this.emptyItem,
    super.readonly,
    super.subtitle,
    super.errorMessage,
    super.onValueChanged,
    super.decoratorIcon,
    super.prefixIcon,
    super.validationCallback,
    super.saveWithErrorOptions,
    super.key,
  });

  @override
  EquipmentFormState<I> createState() => EquipmentFormState<I>();
}

class EquipmentFormState<I extends Item> extends TFormState<I, EquipmentForm<I>>
    with TLoggable, Navigatable<EquipmentForm<I>> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _selectNewItem() async {
    I? selected = await navigateToItemSelect<I>();
    if (selected != null) {
      _controller.text = selected.prettyName;
      value = selected;
      widget.onValueChanged?.call(value);
    }
  }

  void _removeItem() {
    _controller.text = widget.emptyItem?.prettyName ?? '';
    value = widget.emptyItem;
    widget.onValueChanged?.call(value);
  }

  bool get isEmpty => value == widget.emptyItem;

  bool get isNotEmpty => value != widget.emptyItem;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue?.prettyName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: _controller,
      readOnly: true,
      decoration: TInputDecoration(
        enabled: enabled,
        labelText: title,
        helperText: subtitle,
        icon: widget.decoratorIcon,
        prefixIcon: widget.prefixIcon,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (isEmpty)
                TButton.iconOnly(
                  icon: TIcon(
                    icon: Icons.add_circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  text: 'Add equipment',
                  onPressed: enabled && !readonly ? _selectNewItem : null,
                )
              else
                TButton.iconOnly(
                  icon: const TIcon(icon: Icons.edit),
                  text: 'Change equipment',
                  onPressed: enabled && !readonly ? _selectNewItem : null,
                ),
              if (isNotEmpty)
                TButton.iconOnly(
                  icon: TIcon(
                    icon: Icons.cancel,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  text: 'Remove equipment',
                  onPressed: enabled && !readonly ? _removeItem : null,
                ),
            ],
          ),
        ),
      ),
      autovalidateMode: AutovalidateMode.always,
      validator: (_) => errorMessage.isNotEmpty ? errorMessage : null,
    );
  }
}
