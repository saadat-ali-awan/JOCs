import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'change_user_email_dialog.dart';
import 'change_username_dialog.dart';

/// ## Show Dialog on Chat Screen
/// Depending on the value of [selectedDialog] a dialog is displayed on the
/// Profile Screen.
///
/// The Dialogs That will be displayed based on [selectedDialog] are:
/// * [selectedDialog] = 1 => [ChangeUsernameDialog]
/// * [selectedDialog] = 2 => [ChangeUserEmailDialog]
class ChangeUserDetailsDialog extends StatelessWidget {
  const ChangeUserDetailsDialog({Key? key, required this.selectedDialog}) : super(key: key);

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
        return ChangeUsernameDialog();
      case 2:
        return ChangeUserEmailDialog();
    }
    return Column();
  }
}
