import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/ArticleReader/Bindings/article_reader_binding.dart';
import 'package:jocs/Dashboard/Bindings/dashboard_bindings.dart';
import 'package:jocs/Dashboard/dashboard.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller_windows.dart';
import 'package:jocs/HtmlEditorTest/html_editor_test.dart';
import 'package:jocs/Registration/bindings/register_bindings.dart';
import 'package:jocs/Registration/register.dart';

import 'ArticleReader/article_reader.dart';
import 'Dashboard/Screens/eternal_kbs_screen.dart';
import 'Registration/bindings/login_bindings.dart';
import 'Registration/login.dart';
import 'Theme/custom_theme.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  /// First to make sure Flutter is Initialized [WidgetsFlutterBinding.ensureInitialized()] will be called
  /// It is required for Firebase Initialization
  WidgetsFlutterBinding.ensureInitialized();


  /// Firebase is initialized using firebase_options.dart
  /// firebase_options.dart is generated automatically by flutterfire configure command
  /// It contains all the details to connect with Firebase

  if (defaultTargetPlatform != TargetPlatform.windows || kIsWeb || defaultTargetPlatform == TargetPlatform.android) {
    Get.put(FirebaseController());
  }else {
    if (defaultTargetPlatform == TargetPlatform.windows){
      Get.put(FirebaseControllerWindows());
    }
  }

  bool isDarkTheme = await ThemeColors.getThemeMode();
  print("Is Dark? ${isDarkTheme}");


  /// Entry Point For App
  /// Firebase will go to Login Page initially
  runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        /// Using GetX Library for advanced State Management
        scrollBehavior: MyCustomScrollBehavior(),
        theme: ThemeColors.darkTheme? CustomTheme.darkTheme : CustomTheme.lightTheme,
        /// [GetMaterialApp.getPages] is used to set all the Routes of the Application
        getPages: [
          GetPage(

            /// [GetPage.name] is the name That will be used to refer the page
            /// [GetPage.page] contains reference to the page
            /// [GetPage.binding] binds All the Services or Class Instances
            name: '/login',
            page: ()=>const Login(),
            binding: LoginBindings()
          ),
          GetPage(
              name: '/register',
              page: ()=> const Register(),
            binding: RegisterBindings()
          ),
          GetPage(
            name: '/dashboard',
            page: ()=> const Dashboard(),
            bindings: [DashboardBindings(), ArticleReaderBinding()]
          ),
          GetPage(
            name: "/htmlTest",
            page: ()=> HtmlEditorTest(),
          ),
          GetPage(
            name: '/articleReader',
            page: ()=> ArticleReader(),
            binding: ArticleReaderBinding(),
          ),
        ],
        initialRoute: '/login',
        initialBinding: LoginBindings(),
      )
  );
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}