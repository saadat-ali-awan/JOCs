import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';
import 'package:get/get.dart';

class CurrentUserDetails {
  String userId = "";
  String email = "";
  String username = "";
  String imageUrl = "";
  RxString downloadUrl = "".obs;

  CurrentUserDetails({required this.userId, required this.email, required this.username});

  CurrentUserDetails.fromDocumentSnapshot(DocumentSnapshot doc){
    userId = doc.id;
    email = doc["email"];
    username = doc["username"];
    imageUrl = doc["imageName"];
    print(email);
  }

  CurrentUserDetails.fromDocumentSnapshotWindows(Document doc){
    userId = doc.id;
    email = doc["email"];
    username = doc["username"];
    imageUrl = doc["imageName"];
  }
}