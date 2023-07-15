import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thlaby2_save_editor/extensions/int_extension.dart';

@immutable
class NumberInputFormatter extends TextInputFormatter {
  final int? maxLength;
  final String Function(String value) validationCallback;

  NumberInputFormatter({
    required this.validationCallback,
    this.maxLength,
  }) : super();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String baseText = newValue.text;
    // Rollback empty value to zero
    if (baseText.isEmpty) {
      baseText = '0';
    }
    // Remove leading zeroes
    while (baseText.length > 1 && baseText[0] == '0') {
      baseText = baseText.substring(1);
    }
    // Prevent adding digits beyond max length
    if (maxLength != null && baseText.length > maxLength!) {
      return oldValue;
    }
    // Pass the new value to the validation callback
    baseText = validationCallback(baseText);
    // Get the cursor shift from our updates
    int cursorShift = baseText.length - oldValue.text.length;
    // Compute and place the commas to separate digits
    String finalText = BigInt.parse(baseText).commaSeparate();
    // Compute the final cursor position
    int textDiff = finalText.length - baseText.length;
    int finalOffset = oldValue.selection.baseOffset + cursorShift + textDiff;
    // Snap back to text end if mass deletion caused negative offset
    // Or if for some reason we ever go overboard, snap back to text end
    if (finalOffset < 1 || finalOffset > finalText.length) {
      finalOffset = finalText.length;
    }
    // Finally, return with the new values
    return newValue.copyWith(
      text: finalText,
      selection: newValue.selection.copyWith(
        baseOffset: finalOffset,
        extentOffset: finalOffset,
      ),
    );
  }  
}
