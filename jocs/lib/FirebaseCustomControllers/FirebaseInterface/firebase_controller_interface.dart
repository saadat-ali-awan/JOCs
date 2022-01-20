import 'dart:typed_data';

import 'package:jocs/FirebaseCustomControllers/ChatModels/person_model.dart';
import 'package:jocs/FirebaseCustomControllers/ChatModels/user_chat_model.dart';
import 'package:jocs/FirebaseCustomControllers/ChatModels/user_details_model.dart';

abstract class FirebaseControllerInterface {
  get auth;

  get chatScreenMainStreams => null;

  get currentUserDetails;

  /// Initialize Firebase App to be used during the entire session
  initializeFirebase();


  initializeLoginController();
  initializeRegisterController();
  login(String email, String password);
  bool checkFirebaseLoggedIn();
  Future<void> addDataToFirebase(data, String collectionName);
  register(String username, String email, String password);
  getData(String collectionName, int page, int length, {String filter = ""});
  Future<int> getDashboardData(String documentName, {String filter= ""});
  void newChatListener();
  Stream<List<PersonModel>> friendListStream();
  Stream<List<PersonModel>> groupListStream();
  Future<void> createNewGroup(groupData);
  Future<void> createNewChat(id);
  Future<List<String>> searchFriend(String email);
  Future<void> addFriend(List friendData);
  Future<void> addFriendToGroup(List friendData, String chatId, String groupName);
  Future<int> getLastId(String collectionName);

  void sendMessage(String chatId, String message);

  Future<List<MessageModel>> getChat(String chatId, [MessageModel? lastMessage]);
  Future<List<MessageModel>> getRecentChat(String chatId, String mostRecentMessageTimeStamp);

  String getCurrentUserId();

  void uploadImage(Uint8List imageData, String extension);

  void getCurrentUserData();
}