import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';

/// Show Dialog to search a user and Message to the User
class SearchUserDialog extends StatefulWidget {
  SearchUserDialog({Key? key}) : super(key: key);

  @override
  State<SearchUserDialog> createState() => _SearchUserDialogState();
}

class _SearchUserDialogState extends State<SearchUserDialog> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  RxList foundFriend = ["", ""].obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
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
                        hintText: 'Enter Friend Email',
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

                  onPressed: () async {
                    if (_formKey.currentState!.validate()){
                      foundFriend.value = await _dashboardController.searchFriend(emailController.text);
                      setState(() {
                        emailController.clear();
                      });
                    }

                  },
                  child: Text(
                    "Search User",
                    style: Get.textTheme.bodyText1,
                  ),
                ),
              ),
            ],
          ),
        ),
        Material(
          child: InkWell(
              onTap: (){
                _dashboardController.addFriend(foundFriend.value);
                Get.back();
              },
              child: Text(
                foundFriend.value[0],
                style: Get.textTheme.bodyText2,
              )
          ),
        )
      ],
    );
  }
}