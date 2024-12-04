import 'package:form_builder_file_picker/form_builder_file_picker.dart';

import '../constant/_index.dart' show ScreenConfigs;

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

FormBuilderTextField createFormBuilderTextField({
  required String name,
  String? labelText,
  bool obscureText = false,
  String? Function(String?)? validator,
  String? initialValue,
  int? minLine = 1,
  int? maxLine = 1,
}) {
  return FormBuilderTextField(
    name: name,
    obscureText: obscureText,
    validator: validator,
    initialValue: initialValue,
    minLines: minLine,
    maxLines: maxLine,
    textAlignVertical: TextAlignVertical.top,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: ScreenConfigs.inputLabelColor),
      fillColor: ScreenConfigs.inputFillColor,
      filled: true,
// floatingLabelBehavior: FloatingLabelBehavior.never,
      border: const OutlineInputBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenConfigs.inputRadius)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenConfigs.inputRadius)),
        borderSide: BorderSide(
          width: 1.5,
          color: ScreenConfigs.inputBorderColor,
        ),
      ),
    ),
  );
}

FormBuilderDropdown createFormBuilderDropdown({
  required String name,
  required List<DropdownMenuItem<dynamic>> items,
  String? labelText,
  String? Function(dynamic)? validator,
}) {
  return FormBuilderDropdown(
    name: name,
    items: items,
    validator: validator,
    focusColor: Colors.transparent,
    decoration: InputDecoration(
      fillColor: ScreenConfigs.inputFillColor,
      labelText: labelText,
      labelStyle: const TextStyle(color: ScreenConfigs.inputLabelColor),
      filled: true,
      border: const OutlineInputBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenConfigs.inputRadius)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenConfigs.inputRadius)),
        borderSide: BorderSide(
          width: 1.5,
          color: ScreenConfigs.inputBorderColor,
        ),
      ),
    ),
  );
}

FormBuilderDateTimePicker createFormBuilderDatePicker({
  required String name,
  String? labelText,
  String? Function(DateTime?)? validator,
}) {
  return FormBuilderDateTimePicker(
    name: name,
    inputType: InputType.date,
    valueTransformer: (datetime) =>
        datetime == null ? null : DateFormat('yyyy-MM-dd').format(datetime),
    format: DateFormat('dd-MM-yyyy'),
    validator: validator,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: ScreenConfigs.inputLabelColor),
      fillColor: ScreenConfigs.inputFillColor,
      filled: true,
      border: const OutlineInputBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenConfigs.inputRadius)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenConfigs.inputRadius)),
        borderSide: BorderSide(
          width: 1.5,
          color: ScreenConfigs.inputBorderColor,
        ),
      ),
    ),
  );
}

FormBuilderDateTimePicker createFormBuilderDateTimePicker({
  required String name,
  String? labelText,
  String? Function(DateTime?)? validator,
}) {
  return FormBuilderDateTimePicker(
    name: name,
    valueTransformer: (datetime) => datetime == null
        ? null
        : DateFormat('yyyy-MM-ddThh:mm').format(datetime),
    format: DateFormat('hh:mm dd-MM-yyyy'),
    validator: validator,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: ScreenConfigs.inputLabelColor),
      fillColor: ScreenConfigs.inputFillColor,
      filled: true,
      border: const OutlineInputBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenConfigs.inputRadius)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenConfigs.inputRadius)),
        borderSide: BorderSide(
          width: 1.5,
          color: ScreenConfigs.inputBorderColor,
        ),
      ),
    ),
  );
}

FormBuilderFilePicker createFormBuilderFilePicker({
  required name,
  String? labelText,
  int? maxFiles,
}) {
  return FormBuilderFilePicker(
    name: name,
    maxFiles: maxFiles,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: ScreenConfigs.inputLabelColor),
      fillColor: ScreenConfigs.inputFillColor,
      filled: true,
      border: const OutlineInputBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenConfigs.inputRadius)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenConfigs.inputRadius)),
        borderSide: BorderSide(
          width: 1.5,
          color: ScreenConfigs.inputBorderColor,
        ),
      ),
    ),
  );
}

TextButton createButton({
  required void Function()? onPressed,
  required Widget child,
}) {
  return TextButton(
    onPressed: onPressed,
    style: const ButtonStyle(
        backgroundColor:
            WidgetStatePropertyAll(ScreenConfigs.buttonBackgroundColor),
        foregroundColor:
            WidgetStatePropertyAll(ScreenConfigs.buttonForegroundColor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenConfigs.buttonRadius)),
          ),
        )),
    child: child,
  );
}

TextButton createUnderlineTextButton({
  required void Function()? onPressed,
  required String text,
}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      text,
      style: const TextStyle(
        color: ScreenConfigs.underlinedTextButtonColor,
        decorationColor: ScreenConfigs.underlinedTextButtonColor,
        decoration: TextDecoration.underline,
      ),
    ),
  );
}

AppBar createAppBar({
  Widget? title,
  List<Widget>? actions,
}) {
  return AppBar(
    toolbarHeight: 65,
    centerTitle: false,
    titleTextStyle: ScreenConfigs.sectionTitleStyle,
    title: title,
    actions: actions,
  );
}
