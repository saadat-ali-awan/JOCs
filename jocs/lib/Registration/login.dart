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


  late var _loginController;

  @override
  void initState() {
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.windows){
      _loginController = Get.find<LoginControllerWindows>();
    }else {
      _loginController = Get.find<LoginController>();
    }
    _loginController.initializeLogin();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter TextField Example'),
        ),
        body: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 350,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                      hintText: 'Enter Your Name',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 350,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter Password'
                    ),
                  ),
                ),

                TextButton(

                  onPressed: () {

                  },
                  child: Text("Login"),

                )

              ],
            ),
          ),
        )
        // body: Padding(
        //     padding: EdgeInsets.all(15),
        //     child: Column(
        //       children: <Widget>[
        //         Padding(
        //           padding: EdgeInsets.all(15),
        //           child: TextField(
        //             decoration: InputDecoration(
        //               border: OutlineInputBorder(),
        //               labelText: 'User Name',
        //               hintText: 'Enter Your Name',
        //             ),
        //           ),
        //         ),
        //         Padding(
        //           padding: EdgeInsets.all(15),
        //           child: TextField(
        //             obscureText: true,
        //             decoration: InputDecoration(
        //               border: OutlineInputBorder(),
        //               labelText: 'Password',
        //               hintText: 'Enter Password',
        //             ),
        //           ),
        //         ),
        //         RaisedButton(
        //           textColor: Colors.white,
        //           color: Colors.blue,
        //           child: Text('Sign In'),
        //           onPressed: (){},
        //         )
        //       ],
        //     )
        // )
    );
  }
}

