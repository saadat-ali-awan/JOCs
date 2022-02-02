import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jocs/Registration/Controllers/register_controller.dart';
import 'package:jocs/Registration/Controllers/register_controller_windows.dart';

/// A widget that paints the Register Screen
/// It contains simple form with two input fields
/// When Login is pressed User is Registered to Firebase
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late var _registerController;

  @override
  void initState() {
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.windows && !kIsWeb){
      _registerController = Get.find<RegisterControllerWindows>();
    }else {
      _registerController = Get.find<RegisterController>();
    }
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
            child: Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 350,
                          child: TextFormField(
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: usernameController,
                            decoration: const InputDecoration(
                                labelText: 'Username',
                                hintText: 'Username'
                            ),
                            validator: (value){
                              if (value!.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 350,
                          child: TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter Your Email',
                            ),
                            validator: (value){
                              if (GetUtils.isEmail(value!)){
                                return null;
                              }
                              return 'Enter a valid email address';
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 350,
                          child: TextFormField(
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: passwordController,
                            decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter Password'
                            ),
                            validator: (value){
                              if (value!.isEmpty) {
                                return 'Please enter password';
                              } else {
                                if (value.length < 8){
                                  return 'Password must contain at least 8 characters';
                                }else {
                                  return null;
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 350,
                          child: TextFormField(
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: confirmPasswordController,
                            decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Confirm Password',
                            ),
                            validator: (value){
                              if (value != passwordController.text){
                                return 'Password do not match';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(top: 32.0),
                        child: TextButton(

                          onPressed: () {
                            String username = usernameController.text;
                            String email = emailController.text;
                            String password = passwordController.text;
                            String confirmPassword = confirmPasswordController.text;
                            if (_formKey.currentState!.validate()){
                              _registerController.register(username, email, password);
                              emailController.clear();
                              passwordController.clear();
                              confirmPasswordController.clear();
                            }

                          },
                          child: Text(
                            "Register",
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
                              child: Text("Have an account?", style: Theme.of(context).textTheme.bodyText2,),
                            ),
                            TextButton(

                                onPressed: (){
                                  Get.offNamed("/login");
                                },
                                child: Text("Login", style: Theme.of(context).textTheme.bodyText1,)
                            )
                          ],
                        ),
                      ),
                      Obx( () => Container(
                        margin: const EdgeInsets.only(top: 32.0),
                        child: _registerController.registerErrorMessage == "" ?  const SizedBox(width: 0, height: 0):Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${_registerController.registerErrorMessage}",
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                        ),
                      ),
                      )

                    ],
                  ),
                ),
              ),
            ),
          ),
        )

    );
  }
}
