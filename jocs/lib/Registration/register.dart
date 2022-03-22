import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jocs/Registration/Controllers/register_controller.dart';
import 'package:jocs/Registration/Controllers/register_controller_windows.dart';

/// A widget that paints the [Register] Screen
/// It contains simple form with two input fields
/// When Register is pressed User is Registered to Firebase
/// and Logged into The Dashboard
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

/// The State of [Register] Screen is Controlled By [RegisterControllerInterface]
/// The [Register] Controller for Windows is [RegisterControllerWindows]
/// The [Register] Controller for Other Devices is [RegisterController]
class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late var _registerController;

  /// The [RegisterControllerInterface] is initialized based on the Platform
  @override
  void initState() {
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.windows && !kIsWeb){
      _registerController = Get.find<RegisterControllerWindows>();
    }else {
      _registerController = Get.find<RegisterController>();
    }
  }

  /// The [TextEditingController]s are disposed to prevent any memory leak
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
                /// The [SingleChildScrollView] make sure that the Login
                /// Form Always remain in the view even if screen is very small.
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
                            controller: usernameController,
                            decoration: const InputDecoration(
                                labelText: 'Username',
                                hintText: 'Username'
                            ),
                            /// Validator Checks if User entered a
                            /// Valid Username
                            validator: (value){
                              if (value!.isEmpty) {
                                return 'Please enter Username';
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
                            /// Validator Checks if User entered a Valid Email
                            /// The [GetUtils.isEmail] is a GetX Library Function
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
                            /// Validator Checks if User entered a Valid Password
                            /// If Password Length is Greater than or Equal to 8
                            /// than user can login
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
                            /// Validator Checks if User entered a Valid Password
                            /// If Confirm Password Length is Equal to Password
                            /// Field than user can login
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
                          /// The [onPressed] parameter controls the register after
                          /// getting user Details.
                          onPressed: () {
                            String username = usernameController.text;
                            String email = emailController.text;
                            String password = passwordController.text;
                            String confirmPassword = confirmPasswordController.text;
                            /// The details entered by the user are First
                            /// Validated.
                            /// [_formKey.currentState!.validate()] run
                            /// validator for each [TextFormField]
                            if (_formKey.currentState!.validate()){

                              /// To Register [register] defined in
                              /// [RegisterController] or [RegisterControllerWindows]
                              /// is called passing the necessary
                              /// details
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
                              /// If a User want to create a new account than
                              /// [Get.offNamed('/login')] will take the user
                              /// to Registration Screen
                              onPressed: () => Get.offNamed("/login"),
                              child: Text("Login", style: Theme.of(context).textTheme.bodyText1,),
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
