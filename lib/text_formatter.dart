import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
class NumberInputFormatter extends TextInputFormatter {
  final int minValue;
  final int maxValue;
  final void Function(String value) validationCallback;

  NumberInputFormatter({
    required this.minValue,
    required this.maxValue,
    required this.validationCallback,
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
    // Pass the new value to the validation callback
    validationCallback(baseText);
    // Get the cursor shift from our updates
    int cursorShift = baseText.length - oldValue.text.length;
    // Compute and place the commas to separate digits
    int startingDigits = baseText.length % 3;
    if (startingDigits == 0) {
      startingDigits = 3;
    }
    StringBuffer copy = StringBuffer();
    copy.write(baseText.substring(0, startingDigits));
    for (int i = startingDigits; i < baseText.length; i += 3) {
      copy.write(',${baseText.substring(i, i+3)}');
    }
    String finalText = copy.toString();
    // Compute the final cursor position
    int textDiff = finalText.length - baseText.length;
    int finalOffset = oldValue.selection.baseOffset + cursorShift + textDiff;
    // Snap back to text end if mass deletion caused negative offset
    // Or if for some reason we ever go overboard, snap back to text end
    if (finalOffset < 0 || finalOffset > finalText.length) {
      finalOffset = finalText.length;
    }
    // Finally, return with the new values
    return newValue.copyWith(
      text: copy.toString(),
      selection: newValue.selection.copyWith(
        baseOffset: finalOffset,
        extentOffset: finalOffset,
      ),
    );
  }  
}
