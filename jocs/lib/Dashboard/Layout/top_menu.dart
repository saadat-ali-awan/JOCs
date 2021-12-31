import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';

class TopMenu extends StatelessWidget {
  TopMenu({Key? key}) : super(key: key);

  final DashboardController _dashboardController =
      Get.find<DashboardController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Get.theme.appBarTheme.backgroundColor,
      child: Row(children: [
        Expanded(
            child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: getTitle(),
                  )),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      if (_dashboardController.selectedMenuItem>0) {
                        Get.dialog(
                          Center(
                            child: Stack(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    color: Get.theme.iconTheme.color,
                                  ),
                                  width: 400,
                                  child: Wrap(
                                      children: [Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            children: getDialogOptions(),
                                          ),
                                        ),
                                      ),
                                      ]),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: ClipOval(
                                  child: Material(
                                    color: Get.theme.appBarTheme
                                        .backgroundColor, // Button color
                                    child: InkWell( // Splash color
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Icon(Icons.clear,
                                        color: Get.theme.iconTheme.color,),
                                    ),
                                  ),
                                ),

                              ),
                            ]),
                          ),
                        );
                      }else{
                        Get.defaultDialog(
                          titlePadding: const EdgeInsets.all(16.0),
                            title: "Can not add when in Dashboard Tab",
                          middleText: "Switch Tab and come back.",
                          titleStyle: TextStyle(color: Get.theme.appBarTheme.backgroundColor),
                          onConfirm: (){
                              Get.back();
                          },
                          confirmTextColor:  Get.theme.iconTheme.color,
                          buttonColor: Get.theme.appBarTheme.backgroundColor
                        );
                      }
                    },
                    icon: const Icon(Icons.add_box)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.perm_contact_calendar_rounded)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_active))
              ],
            )
          ],
        )),
      ]),
    );
  }

  List<Widget> getTitle() {
    List<Widget> temp = [];
    if (_dashboardController.mobileDisplay.value) {
      temp.add(
        Obx(
          () => IconButton(
              onPressed: () {
                _dashboardController.showMenu.value =
                    !_dashboardController.showMenu.value;
                _dashboardController.menuIcon.value =
                    _dashboardController.showMenu.value
                        ? const Icon(Icons.clear)
                        : const Icon(Icons.menu);
              },
              icon: _dashboardController.menuIcon.value),
        ),
      );
    }
    if (_dashboardController.selectedMenuItem.value == 32 || _dashboardController.selectedMenuItem.value == 33) {
      temp.add(Container(
        margin: const EdgeInsets.all(8.0),
        child: _dashboardController
            .menuList[3][1],
      ));
      temp.add(_dashboardController
          .menuList[3][0]);
    } else {
      temp.add(Container(
        margin: const EdgeInsets.all(8.0),
        child: _dashboardController
            .menuList[_dashboardController.selectedMenuItem.value][1],
      ));
      temp.add(_dashboardController
          .menuList[_dashboardController.selectedMenuItem.value][0]);
    }
    return temp;
  }

  getDialogOptions(){
    switch (_dashboardController.selectedMenuItem.value){
      case 1:
        return [
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
                        labelText: 'Comments',
                        hintText: 'Add Your Comments'),
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
        ];
      case 2:
        return [
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
        ];
    }
    return [Container()];
  }
}
