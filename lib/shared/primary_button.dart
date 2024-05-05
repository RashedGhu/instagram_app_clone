import 'package:flutter/material.dart';

Widget primaryButton({
  required String title,
  required void Function()? onTap,
  required BuildContext context,
  TextStyle? hintStyle,
  Color backGroundColor = Colors.blue,
  Color titleColor = Colors.white,
  bool isTitleUpperCase = true,
  double width = double.infinity,
  double height = 40.0,
  Color? overLayColor = const Color(0xff17569b),
  
}) {
  return TextButton(
    onPressed: onTap,
    
    child: Text(
      isTitleUpperCase ? title.toUpperCase() : title,
      style: hintStyle,
    ),
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        backGroundColor,
      ),
      maximumSize: MaterialStateProperty.all(Size(width, height)),
      minimumSize: MaterialStateProperty.all(Size(width, height)),
      overlayColor: MaterialStateProperty.all(overLayColor),
    ),
  );
}
