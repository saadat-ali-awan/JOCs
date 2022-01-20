import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class LightThemeColors {
  static Color mainColor = const Color(0xFF00b694);
  static Color hoverColor = const Color(0xff016d70);
}

class DarkThemeColors {
  static Color mainColor = const Color(0xff000000);
  static Color hoverColor = const Color(0xff393939);
}

/// Theme Colors are colors for the App Theme
/// In case of multiple themes just add a function that changes colors value
/// at runtime
class ThemeColors {
  static Color secondaryColor = const Color(0xFFFFFFFF);
  static Color errorColor = const Color(0xFF84000A);

  static bool darkTheme = false;

  static Future<void> changeTheme(bool dark) async {
    var box = await Hive.openBox("theme");
    box.put("mode", dark);
    darkTheme = dark;
    //Get.changeThemeMode(dark ? ThemeMode.dark: ThemeMode.light);
    Get.changeTheme(dark? CustomTheme.darkTheme:CustomTheme.lightTheme);
    print("${Get.isDarkMode} ${dark}");
  }

  static Future<bool> getThemeMode() async {
    var box = await Hive.openBox("theme");
    if (box.get("mode") != null && box.get("mode")){
      darkTheme = true;
      return true;
    }else {
      darkTheme = false;
      return false;
    }
  }

  static Color getHoverColor(){
    if (darkTheme){
      return DarkThemeColors.hoverColor;
    }
    return LightThemeColors.hoverColor;
  }
}

/// [CustomTheme] defines theme for the Application
/// For consistency do not change this
class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: LightThemeColors.mainColor,
        scaffoldBackgroundColor: ThemeColors.secondaryColor,
        appBarTheme: AppBarTheme(
            backgroundColor: LightThemeColors.mainColor,
            foregroundColor: ThemeColors.secondaryColor
        ),
        //canvasColor: LightThemeColors.mainColor,
        buttonTheme: ButtonThemeData(
            buttonColor: LightThemeColors.mainColor
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                backgroundColor: LightThemeColors.mainColor,
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
          subtitle1: TextStyle(color: LightThemeColors.mainColor),
          subtitle2: TextStyle(color: ThemeColors.errorColor),
          bodyText1: TextStyle(
              color: ThemeColors.secondaryColor,
              fontSize: 24
          ),
          bodyText2: TextStyle(
              color: LightThemeColors.mainColor,
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
                  color: LightThemeColors.mainColor
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
                    color: LightThemeColors.mainColor
                )
            ),
            errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    style: BorderStyle.solid,
                    color: ThemeColors.errorColor
                )
            ),
            labelStyle: TextStyle(
              color: LightThemeColors.mainColor,
            ),
            fillColor: LightThemeColors.mainColor,
            helperStyle: TextStyle(
                color: LightThemeColors.mainColor
            )

        ),
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: LightThemeColors.mainColor
        ),
        iconTheme: IconThemeData(
            color: ThemeColors.secondaryColor
        ),
        dataTableTheme: DataTableThemeData(
            headingTextStyle: TextStyle(color: LightThemeColors.mainColor, fontSize: 24),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                )
            )
        ),
        dividerColor: Colors.black
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
        primaryColor: DarkThemeColors.mainColor,
        scaffoldBackgroundColor: ThemeColors.secondaryColor,
        appBarTheme: AppBarTheme(
            backgroundColor: DarkThemeColors.mainColor,
            foregroundColor: ThemeColors.secondaryColor
        ),
        //canvasColor: DarkThemeColors.mainColor,
        buttonTheme: ButtonThemeData(
            buttonColor: DarkThemeColors.mainColor
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                backgroundColor: DarkThemeColors.mainColor,
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
          subtitle1: TextStyle(color: DarkThemeColors.mainColor),
          subtitle2: TextStyle(color: ThemeColors.errorColor),
          bodyText1: TextStyle(
              color: ThemeColors.secondaryColor,
              fontSize: 24
          ),
          bodyText2: TextStyle(
              color: DarkThemeColors.mainColor,
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
                  color: DarkThemeColors.mainColor
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
                    color: DarkThemeColors.mainColor
                )
            ),
            errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    style: BorderStyle.solid,
                    color: ThemeColors.errorColor
                )
            ),
            labelStyle: TextStyle(
              color: DarkThemeColors.mainColor,
            ),
            fillColor: DarkThemeColors.mainColor,
            helperStyle: TextStyle(
                color: DarkThemeColors.mainColor
            )

        ),
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: DarkThemeColors.mainColor
        ),
        iconTheme: IconThemeData(
            color: ThemeColors.secondaryColor
        ),
        dataTableTheme: DataTableThemeData(
            headingTextStyle: TextStyle(color: DarkThemeColors.mainColor, fontSize: 24),
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