import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Dialog/ChatScreenDialogs/search_group_user_dialog.dart';
import 'package:jocs/Dashboard/Dialog/ChatScreenDialogs/search_user_dialog.dart';

import 'create_group_dialog.dart';

/// ## Show Dialog on Chat Screen
/// Depending on the value of [selectedDialog] a dialog is displayed on the Chat
/// Screen.
///
/// The Dialogs That will be displayed based on [selectedDialog] are:
/// * [selectedDialog] = 1 => [CreateGroupDialog]
/// * [selectedDialog] = 2 => [SearchUserDialog]
/// * [selectedDialog] = 3 => [SearchGroupUserDialog]
class ChatScreenDialog extends StatelessWidget {
  ChatScreenDialog({Key? key, required this.selectedDialog}) : super(key: key);

  final int selectedDialog;
  @override
  Widget build(BuildContext context) {
    return Center(
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
                  child: getDialogOptions(),
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
    );
  }

  Widget getDialogOptions(){
    switch (selectedDialog){
      case 1:
        return CreateGroupDialog();
      case 2:
        return SearchUserDialog();
      case 3:
        return SearchGroupUserDialog();
    }
    return Column();
  }
}