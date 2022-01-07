import 'package:flutter/material.dart';


class ThemeColors {
  static Color mainColor = const Color(0xFF00b694);
  static Color hoverColor = const Color(0xff016d70);
  static Color secondaryColor = const Color(0xFFFFFFFF);
  static Color errorColor = const Color(0xFF84000A);
}

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: ThemeColors.mainColor,
      scaffoldBackgroundColor: ThemeColors.secondaryColor,
      appBarTheme: AppBarTheme(
        backgroundColor: ThemeColors.mainColor,
        foregroundColor: ThemeColors.secondaryColor
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: ThemeColors.mainColor
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: ThemeColors.mainColor,
          textStyle: TextStyle(
            color: ThemeColors.secondaryColor,
          ),
          minimumSize: const Size(150, 50)

        )
      ),
      textTheme: TextTheme(
        headline1: TextStyle(color: ThemeColors.secondaryColor),
        headline2: TextStyle(color: ThemeColors.secondaryColor),
        headline3: TextStyle(color: ThemeColors.secondaryColor),
        headline4: TextStyle(color: ThemeColors.secondaryColor),
        headline5: TextStyle(color: ThemeColors.secondaryColor),
        headline6: TextStyle(color: ThemeColors.secondaryColor),
        subtitle1: TextStyle(color: ThemeColors.mainColor),
        subtitle2: TextStyle(color: ThemeColors.errorColor),
        bodyText1: TextStyle(
            color: ThemeColors.secondaryColor,
          fontSize: 24
        ),
        bodyText2: TextStyle(
            color: ThemeColors.mainColor,
          fontSize: 24
        ),
        caption: TextStyle(color: ThemeColors.secondaryColor),
        overline: TextStyle(color: ThemeColors.secondaryColor),
        button: TextStyle(color: ThemeColors.secondaryColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: ThemeColors.mainColor
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: ThemeColors.secondaryColor
          )
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                style: BorderStyle.solid,
                color: ThemeColors.mainColor
            )
        ),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                style: BorderStyle.solid,
                color: ThemeColors.errorColor
            )
        ),
        labelStyle: TextStyle(
          color: ThemeColors.mainColor,
        ),
        fillColor: ThemeColors.mainColor,
        helperStyle: TextStyle(
          color: ThemeColors.mainColor
        )

      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: ThemeColors.mainColor
      ),
      iconTheme: IconThemeData(
        color: ThemeColors.secondaryColor
      ),
      dataTableTheme: DataTableThemeData(
        headingTextStyle: TextStyle(color: ThemeColors.mainColor, fontSize: 24),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          )
        )
      ),
      dividerColor: Colors.black
    );
  }
}