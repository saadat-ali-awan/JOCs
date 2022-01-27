import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';

class SearchGroupUserDialog extends StatefulWidget {
  SearchGroupUserDialog({Key? key}) : super(key: key);

  @override
  State<SearchGroupUserDialog> createState() => _SearchGroupUserDialogState();
}

class _SearchGroupUserDialogState extends State<SearchGroupUserDialog> {
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
                    "Add Item",
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
                _dashboardController.addFriendToGroup(foundFriend.value, _dashboardController.openChat!.chatId, _dashboardController.openChat!.modelName);
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