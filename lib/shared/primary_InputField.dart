import 'package:flutter/material.dart';


Widget primaryInputField({
  required BuildContext context,
  required TextEditingController controller,
  required String hintText,
  void Function(String value)? onChanged,
  void Function(String? value)? onSaved,
  void Function(String value)? onFieldSubmitted,
  void Function()? onTap,
  bool obscureText = false,
  Widget? suffixIcon,
  Widget? prefixIcon,
  Widget? suffix,
  Widget? prefix,
  BoxConstraints? prefixIconConstraints,
  TextInputType keyBoardType = TextInputType.text,
  int? maxLines,
  Color? fillColor,
  double? cursorHeight,
  bool autoFocusKeyboard = false,
  EdgeInsets? contentPadding,
  InputBorder? focusBorder,
  InputBorder? enabledBorder,
  String? initialValue,
  TextStyle? inputStyle,
  FocusNode? focusNode,
}) {
  return TextFormField(
  
    style: inputStyle ,
    focusNode: focusNode,
    cursorHeight: cursorHeight,
    controller: controller,
    onChanged: onChanged,
    onSaved: onSaved,
    initialValue: initialValue,
    onFieldSubmitted: onFieldSubmitted,
    onTap: onTap,
    obscureText: obscureText,
    keyboardType: keyBoardType,
    maxLines: maxLines,
    autofocus: autoFocusKeyboard,
    decoration: InputDecoration(
      prefixIconConstraints: prefixIconConstraints,
      fillColor: fillColor,
      filled: true,
      hintText: hintText,
      hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
      border: Theme.of(context).inputDecorationTheme.border,
      focusedBorder: focusBorder,
      enabledBorder: enabledBorder,
      suffix: suffix,
      prefix: prefix,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      contentPadding: contentPadding,
    ),
  );
}
