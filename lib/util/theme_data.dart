import 'package:flutter/material.dart';

const mobileBackgroundColor = Color.fromRGBO(0, 0, 0, 1);
const webBackgroundColor = Color.fromRGBO(18, 18, 18, 1);
const mobileSearchColor = Color.fromRGBO(38, 38, 38, 1);
const blueColor = Color.fromRGBO(0, 149, 246, 1);
const primaryColor = Colors.white;
const secondaryColor = Colors.grey;

BuildContext? context;
void getThemeContext(BuildContext conxt) {
  context = conxt;
}

final ThemeData darkModeTheme = ThemeData.dark().copyWith(
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Colors.grey,
    linearMinHeight: 0.1,
    circularTrackColor: Colors.grey,
  ),
  iconTheme: IconThemeData(color: Colors.white),
  scaffoldBackgroundColor: mobileBackgroundColor,
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Color(0xFF333333),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: Divider.createBorderSide(context),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: Divider.createBorderSide(context),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: Divider.createBorderSide(context),
    ),
    hintStyle: TextStyle(
      fontSize: 14.0,
    ),
  ),
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    actionsIconTheme: IconThemeData(color: Colors.white),
    backgroundColor: mobileBackgroundColor,
    elevation: 0.0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: mobileBackgroundColor,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white,
    selectedIconTheme: IconThemeData(size: 25),
    unselectedIconTheme: IconThemeData(size: 25),
  ),
  textTheme: TextTheme(
    subtitle2: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    headline6: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.grey[900],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.grey[800],
  ),
);

final ThemeData lightTheme = ThemeData.light().copyWith(
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Colors.grey[600],
    linearMinHeight: 0.3,
    circularTrackColor: Colors.grey,
  ),
  scaffoldBackgroundColor: primaryColor,
  iconTheme: IconThemeData(color: Colors.black),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(
      fontSize: 14.0,
    ),
  ),
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    actionsIconTheme: IconThemeData(
      color: Colors.black,
    ),
    backgroundColor: primaryColor,
    elevation: 0.0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: primaryColor,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.black,
    selectedIconTheme: IconThemeData(size: 25),
    unselectedIconTheme: IconThemeData(size: 25),
  ),
  textTheme: TextTheme(
    subtitle2: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    headline6: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
  ),
  tabBarTheme: TabBarTheme(),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.grey[200],
  ),
);
