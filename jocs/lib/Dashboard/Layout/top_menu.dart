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
                      Get.dialog(
                        Center(
                          child: Stack(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: Get.theme.iconTheme.color,
                                ),
                                width: 400,
                                child: Wrap(
                                  children: [Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: 350,
                                              child: Material(
                                                child: TextFormField(
                                                  //controller: emailController,
                                                  decoration: const InputDecoration(
                                                    labelText: 'Email',
                                                    hintText: 'Enter Your Email',
                                                  ),
                                                  validator: (value) {
                                                    if (GetUtils.isEmail(value!)) {
                                                      return null;
                                                    }
                                                    return 'Enter a valid email address';
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: 350,
                                              child: Material(
                                                child: TextFormField(
                                                  //controller: emailController,
                                                  decoration: const InputDecoration(
                                                    labelText: 'Email',
                                                    hintText: 'Enter Your Email',
                                                  ),
                                                  validator: (value) {
                                                    if (GetUtils.isEmail(value!)) {
                                                      return null;
                                                    }
                                                    return 'Enter a valid email address';
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                                width: 350,
                                                child: Material(
                                                  child: TextFormField(
                                                    obscureText: true,
                                                    enableSuggestions: false,
                                                    autocorrect: false,
                                                    //controller: passwordController,
                                                    decoration: const InputDecoration(
                                                        labelText: 'Password',
                                                        hintText: 'Enter Password'),
                                                    validator: (value) {
                                                      // RegExp regex =
                                                      // RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                                      if (value!.isEmpty) {
                                                        return 'Please enter password';
                                                      } else {
                                                        if (value.length < 8) {
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
                                            margin: const EdgeInsets.only(top: 32.0),
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
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                            ),
                                          ),
                                          // Obx( () => Container(
                                          //   margin: const EdgeInsets.only(top: 32.0),
                                          //   child: _loginController.loginErrorMessage == "" ?  const SizedBox(width: 0, height: 0):Container(
                                          //     child: Padding(
                                          //       padding: const EdgeInsets.all(8.0),
                                          //       child: Text(
                                          //         "${_loginController.loginErrorMessage}",
                                          //         style: Theme.of(context).textTheme.subtitle2,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          // )
                                        ],
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
                                  color: Get.theme.appBarTheme.backgroundColor, // Button color
                                  child: InkWell( // Splash color
                                    onTap: () { Get.back(); },
                                    child: Icon(Icons.clear, color: Get.theme.iconTheme.color,),
                                  ),
                                ),
                              )  ,

                            ),
                          ]),
                        ),
                      );
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
    if (_dashboardController.selectedMenuItem.value == 32) {
      temp.add(_dashboardController.menuList[3][2]);
    } else {
      if (_dashboardController.selectedMenuItem.value == 33) {
        temp.add(_dashboardController.menuList[3][3]);
      } else {
        temp.add(Container(
          margin: const EdgeInsets.all(8.0),
          child: _dashboardController
              .menuList[_dashboardController.selectedMenuItem.value][1],
        ));
        temp.add(_dashboardController
            .menuList[_dashboardController.selectedMenuItem.value][0]);
      }
    }
    return temp;
  }
}
