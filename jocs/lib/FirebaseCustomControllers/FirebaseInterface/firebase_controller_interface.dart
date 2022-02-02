import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jocs/FirebaseCustomControllers/ChatModels/person_model.dart';
import 'package:jocs/FirebaseCustomControllers/ChatModels/user_chat_model.dart';
import 'package:jocs/FirebaseCustomControllers/ChatModels/user_details_model.dart';
import 'package:jocs/FirebaseCustomControllers/DataModels/article_category.dart';
import 'package:jocs/FirebaseCustomControllers/DataModels/detailed_metadata.dart';

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
  Future<void> addDataToFirebase(data, String collectionName, String metadataKey, int lastId);
  register(String username, String email, String password);
  getData(String collectionName, int page, int length, {String filter = "", Map<String, String> customFilter = const <String, String>{}});
  Future<int> getDashboardData(String documentName, {String filter= ""});
  void newChatListener();
  Stream<List<PersonModel>> friendListStream();
  Stream<List<PersonModel>> groupListStream();
  Future<void> createNewGroup(groupData);
  Future<void> createNewChat(id);
  Future<List<String>> searchFriend(String email);
  Future<void> addFriend(List friendData);
  Future<void> addFriendToGroup(List friendData, String chatId, String groupName);
  //Future<int> getLastId(String collectionName);

  void sendMessage(String chatId, String message);

  Future<List<MessageModel>> getChat(String chatId, [MessageModel? lastMessage]);
  Future<List<MessageModel>> getRecentChat(String chatId, String mostRecentMessageTimeStamp);

  String getCurrentUserId();

  void uploadImage(Uint8List imageData, String extension);
  void updateUserData(Map<String, dynamic> data);

  void getCurrentUserData();

  void addArticleCategory(Map<String, dynamic> data, String collectionName);

  Stream<List<ArticleCategory>> getCategoryData();

  void createNewArticle(Map<String, dynamic> data, int lastId);

  Future<dynamic> getArticle(String documentId);

  Stream<DetailedMetadata> getMetaDataFromDatabase();

  void setMetadataInDatabase(Map<String, int> metaDataMap);

  void removeDataFromTable(String screenName, String time, Map<String, int> map);

  void removeArticleFromCategory(String categoryName, reference);
}