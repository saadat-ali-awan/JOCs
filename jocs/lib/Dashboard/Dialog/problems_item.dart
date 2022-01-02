import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProblemsItem extends StatelessWidget {
  ProblemsItem({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(
                8.0),
            child: SizedBox(
              width: 350,
              child: Material(
                child: TextFormField(
                  //controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Issued By',
                    hintText: 'Mr. Abc',
                  ),
                  validator: (value) {
                    if (GetUtils.isEmail(
                        value!)) {
                      return null;
                    }
                    return 'Enter a valid email address';
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(
                8.0),
            child: SizedBox(
              width: 350,
              child: Material(
                child: TextFormField(
                  //controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Topic',
                    hintText: 'XYZ Problem',
                  ),
                  validator: (value) {
                    if (GetUtils.isEmail(
                        value!)) {
                      return null;
                    }
                    return 'Enter a valid email address';
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(
                8.0),
            child: SizedBox(
                width: 350,
                child: Material(
                  child: TextFormField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    //controller: passwordController,
                    decoration: const InputDecoration(
                        labelText: 'Status',
                        hintText: 'Resolved'),
                    validator: (value) {
                      // RegExp regex =
                      // RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      if (value!.isEmpty) {
                        return 'Please enter password';
                      } else {
                        if (value.length <
                            8) {
                          return 'Password must contain at least 8 characters';
                        } else {
                          return null;
                        }
                        // if (!regex.hasMatch(value)) {
                        //   return 'Enter valid password';
                        // } else {
                        //   return null;
                        // }
                      }
                    },
                  ),
                )),
          ),

          Padding(
            padding: const EdgeInsets.all(
                8.0),
            child: SizedBox(
                width: 350,
                child: Material(
                  child: TextFormField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    //controller: passwordController,
                    decoration: const InputDecoration(
                        labelText: 'Priority',
                        hintText: 'High'),
                    validator: (value) {
                      // RegExp regex =
                      // RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      if (value!.isEmpty) {
                        return 'Please enter password';
                      } else {
                        if (value.length <
                            8) {
                          return 'Password must contain at least 8 characters';
                        } else {
                          return null;
                        }
                        // if (!regex.hasMatch(value)) {
                        //   return 'Enter valid password';
                        // } else {
                        //   return null;
                        // }
                      }
                    },
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(
                8.0),
            child: SizedBox(
                width: 350,
                child: Material(
                  child: TextFormField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    //controller: passwordController,
                    decoration: const InputDecoration(
                        labelText: 'Assigned to',
                        hintText: 'Mr. XYZ'),
                    validator: (value) {
                      // RegExp regex =
                      // RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      if (value!.isEmpty) {
                        return 'Please enter password';
                      } else {
                        if (value.length <
                            8) {
                          return 'Password must contain at least 8 characters';
                        } else {
                          return null;
                        }
                        // if (!regex.hasMatch(value)) {
                        //   return 'Enter valid password';
                        // } else {
                        //   return null;
                        // }
                      }
                    },
                  ),
                )),
          ),

          Padding(
            padding: const EdgeInsets.all(
                8.0),
            child: SizedBox(
                width: 350,
                child: Material(
                  child: TextFormField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    //controller: passwordController,
                    decoration: const InputDecoration(
                        labelText: 'Department',
                        hintText: 'Add Department for Problem'),
                    validator: (value) {
                      // RegExp regex =
                      // RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      if (value!.isEmpty) {
                        return 'Please enter password';
                      } else {
                        if (value.length <
                            8) {
                          return 'Password must contain at least 8 characters';
                        } else {
                          return null;
                        }
                        // if (!regex.hasMatch(value)) {
                        //   return 'Enter valid password';
                        // } else {
                        //   return null;
                        // }
                      }
                    },
                  ),
                )),
          ),

          Container(
            margin: const EdgeInsets.only(
                top: 32.0),
            child: TextButton(
              // onPressed: () {
              //   if (_formKey.currentState!.validate()){
              //     String email = emailController.text;
              //     String password = passwordController.text;
              //     _loginController.login(email, password);
              //     emailController.clear();
              //     passwordController.clear();
              //   }
              //
              // },
              onPressed: () {},
              child: Text(
                "Add Item",
                style: Get
                    .textTheme
                    .bodyText1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
