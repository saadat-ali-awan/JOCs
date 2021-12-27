import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:jocs/Registration/Controllers/login_controller.dart';
import 'package:flutter/foundation.dart';

import 'Controllers/login_controller_windows.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late var _loginController;

  @override
  void initState() {
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.windows && !kIsWeb){
      _loginController = Get.find<LoginControllerWindows>();
    }else {
      _loginController = Get.find<LoginController>();
    }
    _loginController.initializeLogin();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Flutter TextField Example',
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        body: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 350,
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter Your Email',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 350,
                    child: TextField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter Password'
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 32.0),
                  child: TextButton(

                    onPressed: () {
                      String email = emailController.text;
                      String password = passwordController.text;
                      _loginController.login(email, password);
                    },
                    child: Text(
                        "Login",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),

                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top:32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                    crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Do not have account?", style: Theme.of(context).textTheme.bodyText2,),
                      ),
                      TextButton(

                          onPressed: (){},
                          child: Text("Register", style: Theme.of(context).textTheme.bodyText1,)
                      )
                    ],
                  ),
                )

              ],
            ),
          ),
        )

    );
  }
}

