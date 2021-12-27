import 'package:flutter/material.dart';

class Colors {
  static Color mainColor = const Color(0xFF002A2B);
  static Color secondaryColor = const Color(0xFFFFFFFF);
  static Color errorColor = const Color(0xFF84000A);
}

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.mainColor,
      scaffoldBackgroundColor: Colors.secondaryColor,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.mainColor,
        foregroundColor: Colors.secondaryColor
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.mainColor
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: Colors.mainColor,
          textStyle: TextStyle(
            color: Colors.secondaryColor,
          ),
          minimumSize: const Size(150, 50)

        )
      ),
      textTheme: TextTheme(
        headline1: TextStyle(color: Colors.secondaryColor),
        headline2: TextStyle(color: Colors.secondaryColor),
        headline3: TextStyle(color: Colors.secondaryColor),
        headline4: TextStyle(color: Colors.secondaryColor),
        headline5: TextStyle(color: Colors.secondaryColor),
        headline6: TextStyle(color: Colors.secondaryColor),
        subtitle1: TextStyle(color: Colors.mainColor),
        subtitle2: TextStyle(color: Colors.secondaryColor),
        bodyText1: TextStyle(
            color: Colors.secondaryColor,
          fontSize: 24
        ),
        bodyText2: TextStyle(
            color: Colors.mainColor,
          fontSize: 24
        ),
        caption: TextStyle(color: Colors.secondaryColor),
        overline: TextStyle(color: Colors.secondaryColor),
        button: TextStyle(color: Colors.secondaryColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: Colors.mainColor
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: Colors.secondaryColor
          )
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                style: BorderStyle.solid,
                color: Colors.mainColor
            )
        ),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                style: BorderStyle.solid,
                color: Colors.errorColor
            )
        ),
        labelStyle: TextStyle(
          color: Colors.mainColor,
        ),
        fillColor: Colors.mainColor,
        helperStyle: TextStyle(
          color: Colors.mainColor
        )

      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.mainColor
      )
    );
  }
}