import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';

class ChangeUserEmailDialog extends StatefulWidget {
  const ChangeUserEmailDialog({Key? key}) : super(key: key);

  @override
  _ChangeUserEmailDialogState createState() => _ChangeUserEmailDialogState();
}

class _ChangeUserEmailDialogState extends State<ChangeUserEmailDialog> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Form(
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
          ),
          Container(
            margin: const EdgeInsets.only(top: 32.0),
            child: TextButton(

              onPressed: () {
                if (_formKey.currentState!.validate()){
                  _dashboardController.firebaseController.updateUserData({
                    'email': emailController.text
                  });
                  setState(() {
                    emailController.clear();
                  });
                  Get.back();
                }

              },
              child: Text(
                "Change Email",
                style: Get.textTheme.bodyText1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
