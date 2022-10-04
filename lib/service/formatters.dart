import 'package:flutter/services.dart';

class InputDoubleFormatter extends TextInputFormatter{

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    if (double.tryParse(newValue.text) != null || newValue.text == ''){
      return newValue;
    }

    return oldValue;
  }

}