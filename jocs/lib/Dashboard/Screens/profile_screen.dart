import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("User Data", style: context.theme.textTheme.headline4!.copyWith(color: context.theme.appBarTheme.backgroundColor),)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Email: XYZ@Dingdong.com", style: context.theme.textTheme.bodyText2,),
                  IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.edit, color: _dashboardController.tileColor.value,),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Username: Mr. XYZ", style: context.theme.textTheme.bodyText2,),
                  IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.edit, color: _dashboardController.tileColor.value,),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: InkWell(
                        child: Obx(() => _dashboardController.firebaseController.currentUserDetails.downloadUrl == "" ? Image(
                            image: AssetImage('images/avatar.png'),
                            width: 100,
                            height: 100,
                          ): Image.network(_dashboardController.firebaseController.currentUserDetails.downloadUrl.value),
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );

                      if (result != null) {
                        PlatformFile file = result.files.first;

                        Uint8List fileBytes = result.files.first.bytes!;
                        String fileName = result.files.first.name;

                        // Upload file
                        _dashboardController.firebaseController.uploadImage(fileBytes, file.extension!);
                      } else {
                        // User canceled the picker
                      }
                    },
                    child: Text("Change Image"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
