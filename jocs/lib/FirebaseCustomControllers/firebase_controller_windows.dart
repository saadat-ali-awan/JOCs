import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:collection/src/iterable_extensions.dart';
import 'package:firedart/auth/exceptions.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:jocs/Dashboard/Modals/screen_adapter.dart';
import 'package:jocs/FirebaseCustomControllers/ChatModels/person_model.dart';
import 'package:jocs/FirebaseCustomControllers/ChatModels/user_chat_model.dart';
import 'package:jocs/FirebaseCustomControllers/DataModels/article_category.dart';
import 'package:jocs/FirebaseCustomControllers/DataModels/detailed_metadata.dart';
import 'package:jocs/FirebaseCustomControllers/FirebaseInterface/firebase_controller_interface.dart';
import 'package:jocs/Registration/Controllers/hive_store.dart';
import 'package:jocs/Registration/Controllers/login_controller_windows.dart';
import 'package:jocs/Registration/Controllers/register_controller_windows.dart';

import 'ChatModels/user_details_model.dart';

class FirebaseControllerWindows implements FirebaseControllerInterface{

  @override
  late FirebaseAuth auth;
  late Firestore firestore;
  late LoginControllerWindows _loginController;
  late RegisterControllerWindows _registerControllerWindows;

  @override
  List<StreamSubscription> chatScreenMainStreams = [];

  FirebaseControllerWindows(){
    initializeFirebase();
  }

  @override
  void addArticleCategory(Map<String, dynamic> data, String collectionName) async {
    var reference = firestore.collection(collectionName);
    await reference.add(data);
  }

  @override
  Future<void> addDataToFirebase(data, String collectionName, String metadataKey, int lastId) async {
    var reference = firestore.collection(collectionName);
    data["id"] = lastId;
    var docReference = await reference.add(data);
  }

  @override
  Future<void> addFriend(List friendData) async {
    String friendUniqueId = DateTime.now().toUtc().millisecondsSinceEpoch.toString() + auth.userId;
    var tempData = <String, dynamic>{};
    tempData["chatId"] = friendUniqueId;
    tempData["unread"] = [];
    tempData["friendName"] = friendData[0];
    var reference = firestore.collection('Users');
    reference.document(auth.userId)
        .collection("Friends")
        .document(friendData[1])
        .set(tempData)
        .then((value) async {
          User user = await auth.getUser();
          tempData["chatId"] = friendUniqueId;
          tempData["unread"] = [];
          tempData["friendName"] = user.email;
          var reference = firestore.collection('Users');
          reference.document(friendData[1])
              .collection("Friends")
              .document(auth.userId)
              .set(tempData)
              .then((value){
                createNewChat(friendUniqueId);
              })
              .catchError((error) => print("Failed to add Group: $error"));
        })
        .catchError((error) => print("Failed to add Group: $error"));
  }

  @override
  Future<void> addFriendToGroup(List friendData, String groupId, String groupName) async {
    var tempData = <String, dynamic>{};
    tempData["chatId"] = groupId;
    tempData["unread"] = [];
    tempData["groupName"] = groupName;
    var reference = firestore.collection('Users');
    reference.document(friendData[1])
        .collection("Groups")
        .document(groupId).set(tempData)
        .then((value) => print("Friend Added"))
        .catchError((error) => print("Failed to add Friend to group $error"));
  }

  @override
  bool checkFirebaseLoggedIn() {
    auth = FirebaseAuth.instance;
    if (auth.isSignedIn){
      return true;
    }
    return false;
  }

  createChatListener(String collectionName){
    var reference = firestore.collection('Users');
    reference.document(auth.userId).collection(collectionName).get().then((docs){
      for (var element in docs) {
        chatScreenMainStreams.add(reference.document(auth.userId)
            .collection(collectionName)
            .document(element.id)
            .stream
            .listen((document) {
              print(document);
            })
            );
      }
    });

  }

  @override
  void createNewArticle(Map<String, dynamic> data, int lastId) async {
    data['time'] = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    //data["id"] = lastId;
    var reference = firestore.collection('articles');
    reference.add(data).then((value) {
        reference = firestore.collection('category');
        reference.where("category-name", isEqualTo: data['category-name']).get().then((List<Document> docs){
          docs.forEach((element) {
            List articles = element["articles"];
            Map<String, String> tempArticle = {
              'topic': data['topic']!,
              'id': value.id
            };
            articles.add(tempArticle);
            reference.document(element.id).update({"articles": articles});
          });
        });
    });

  }

  @override
  Future<void> createNewChat(id) async {
    var reference = firestore.collection('Chat');
    reference
        .document(id)
        .set(<String, dynamic>{})
        .then((value){
          print("Chat Created");
        })
        .catchError((error) => print("Failed to add Chat Id: $error"));
  }

  @override
  Future<void> createNewGroup(groupData) async {
    String groupUniqueId = DateTime.now().toUtc().millisecondsSinceEpoch.toString() + auth.userId;
    groupData["chatId"] = groupUniqueId;
    groupData["unread"] = [];
    var reference = firestore.collection('Users');
    reference
        .document(auth.userId)
        .collection("Groups")
        .document(groupUniqueId)
        .set(groupData)
        .then((value){
          print("Group Created");
          createNewChat(groupUniqueId);
        })
        .catchError((error) => print("Failed to add Group: $error"));
  }

  @override
  Stream<List<PersonModel>> friendListStream() {
    var reference = firestore.collection('Users');

    return reference
        .document(auth.userId)
        .collection("Friends")
        .stream.map((List<Document> documents){
          List<PersonModel> retVal = [];
          for (Document document in documents){
            retVal.add(PersonModel(chatId: document["chatId"], unreadMessages: document["unread"], modelId: document.id, modelName: document["friendName"], modelType: "Friend"));
          }
          return retVal;
        });
  }

  @override
  Future<Document> getArticle(String documentId) {
    var reference = firestore.collection('articles');
    var snapshot = reference.document(documentId).get();
    print('getArticles() => ${snapshot}');
    return snapshot;
  }

  @override
  Future getArticleByTime(time) async {
    var reference = firestore.collection('articles');
    List<Document> snapshot = await reference.where('time', isEqualTo: time).get();
    return snapshot.first;
  }

  @override
  Stream<List<ArticleCategory>> getCategoryData(){
    var reference = firestore.collection('category');
    return reference.stream.map((List<Document> documents){
      List<ArticleCategory> retVal = [];
      for (Document document in documents){
        print('Category Document: ${document["category-name"]}');
        retVal.add(ArticleCategory(document["category-name"], document["description"], List.from(document["articles"])));
      }
      print(documents.length);
      return retVal;
    });
  }
  @override
  Future<List<MessageModel>> getChat(String chatId, [MessageModel? lastMessage]) async {
    List<MessageModel> temp = [];
    var collectionReference = firestore.collection("Chat");
    if (lastMessage!=null){
      await collectionReference.document(chatId)
          .collection("messages")
          .where("time", isLessThan:lastMessage.timeStamp)
          .orderBy("time", descending: true)
          .limit(20)
          .get()
          .then((documents){
            for (var element in documents) {
              print(element["message"]);
              temp.add(MessageModel(element["message"], element["sender"], element["time"], element["senderName"]));
            }
          });
    }else{
      await collectionReference.document(chatId)
          .collection("messages")
          .orderBy("time", descending: true)
          .limit(20)
          .get()
          .then((documents){
            for (var element in documents) {
              print(element["message"]);
              temp.add(MessageModel(element["message"], element["sender"], element["time"], element["senderName"]));
            }
          });
    }

    return temp;
  }

  @override
  Future<int> getDashboardData(String documentName, {String filter = ""}) async {
    var collectionReference = firestore.collection("tickets");
    List<Document> tempData;
    if (filter.isNotEmpty){
      tempData = await collectionReference.where(documentName, isEqualTo: filter).get();
    }else{
      tempData = await collectionReference.orderBy(documentName, descending: true).get();
    }
    print(documentName+ "${tempData.length}");
    return tempData.length;
  }

  @override
  getData(String collectionName, int page, int length, {String filter = "", Map<String, String> customFilter = const <String, String>{}}) async {
    var collectionReference = firestore.collection(collectionName);
    QueryReference ref;
    if (page > 1) {
      ref = await collectionReference.orderBy("time", descending: true).where("time", isLessThan: filter).limit(length+10);
    } else {
      ref = await collectionReference.orderBy("time", descending: true).limit(length+10);
    }

    customFilter.forEach((key, value) {
      print("Custom Filter: ${key}, ${value}");
      if (key != "S" && key != "P"){
        ref = ref.where(key, isEqualTo: value);
      }
    });

    List<Document> data = await ref.get();

    var returnData = [];
    for (var element in data) {
      returnData.add(element.map);
    }
    return returnData;
  }

  @override
  Future<List<Document>> getNewData(ScreenAdapter adapter) async {
    var ref = firestore.collection(adapter.screenName);
    List<Document> snapshot = await ref.where("time", isEqualTo: adapter.adapterData.first["time"]).get();
    return snapshot;
  }

  @override
  Stream<DetailedMetadata> getMetaDataFromDatabase() {
    var ref = firestore.collection("metadata");
    return ref.document("data").stream.map((Document? document) {
      if (document != null){
        return DetailedMetadata.fromDataSnapshotWindows(document);
      }else {
        return DetailedMetadata();
      }
    });
  }

  @override
  Future<List<MessageModel>> getRecentChat(String chatId, String mostRecentMessageTimeStamp) async {
    List<MessageModel> temp = [];
    var collectionReference = firestore.collection("Chat");
    await collectionReference
        .document(chatId)
        .collection("messages")
        .where("time", isGreaterThan:mostRecentMessageTimeStamp)
        .orderBy("time", descending: true).get().then((value){
          for (var element in value) {
            print(element["message"]);
            temp.add(MessageModel(element["message"], element["sender"], element["time"], element["senderName"]));
          }
        });
    return temp;
  }

  @override
  Stream<List<PersonModel>> groupListStream() {
    var reference = firestore.collection('Users');

    return reference
        .document(auth.userId)
        .collection("Groups")
        .stream.map((List<Document> documents){
      List<PersonModel> retVal = [];
      for (Document document in documents){
        retVal.add(PersonModel(chatId: document["chatId"], unreadMessages: document["unread"], modelId: document.id, modelName: document["groupName"], modelType: "Friend"));
      }
      return retVal;
    });
  }

  @override
  initializeFirebase() async {
    var path = Directory.current.path;
    Hive
        .init(path);
    try {
      Hive.registerAdapter(TokenAdapter());
    }on HiveError catch(e){
      print(e.message);
    }

    try {
      auth = FirebaseAuth.initialize('AIzaSyBqcQEfEXhRUn2Bn4900aOP7BZfxphsKss', await HiveStore.create());
      firestore = Firestore("jocit-b0c8a", auth: auth);
    }on Exception catch (e){
      print("Already Initialized");
    }
  }

  @override
  initializeLoginController(){
    _loginController = Get.find<LoginControllerWindows>();
    //_loginController.initializeLogin();
  }

  @override
  initializeRegisterController(){
    _registerControllerWindows = Get.find<RegisterControllerWindows>();
  }

  @override
  login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signIn(email, password);
    }on AuthException catch (e){
      print(e.message);
      if (e.message == 'EMAIL_NOT_FOUND') {
        print('No user found for that email.');
        _loginController.loginErrorMessage.value = 'No user found for that email.';
      } else if (e.message == 'INVALID_PASSWORD') {
        print('Wrong password provided for that user.');
        _loginController.loginErrorMessage.value = 'Wrong password provided for that user.';
      }
    }
    if (FirebaseAuth.instance.isSignedIn){
      Get.toNamed("/dashboard");
    }
  }

  @override
  void logOut() {
    Get.back();
    auth.signOut();
  }

  @override
  void newChatListener() {
    var collectionReference = firestore.collection("Users");
    createChatListener("Friends");
    createChatListener("Groups");
  }

  @override
  register(String username, String email, String password) async {
    try {
      User user = await FirebaseAuth.instance.signUp(email, password);
      var reference = firestore.collection('Users');
      var docReference = await reference.add(user.toMap());
    }on AuthException catch(e){
      _registerControllerWindows.registerErrorMessage.value = e.message;
    }
  }

  @override
  void removeDataFromTable(String screenName, String time, Map<String, int> map) async {
    var collectionReference = firestore.collection(screenName);
    await collectionReference.where("time", isEqualTo: time).get().then((List<Document> snapshot) {
      snapshot.forEach((element) async {
        print("Element Reference ${element.reference}");
        await element.reference.delete();
      });
      setMetadataInDatabase(map);
    });
  }

  void removeArticleFromCategory(String categoryName, reference) async {
    DocumentReference ref = reference as DocumentReference;
    var collectionReference = firestore.collection('category');
    await collectionReference.where('category-name', isEqualTo: categoryName).get().then((List<Document> snapshot) {
      snapshot.forEach((Document categoryData) {
        List<dynamic> articleList = categoryData['articles'];
        List<dynamic> allArticles = [];
        articleList.forEachIndexed((int index, element) {
          if (element["id"] != ref.id){
            allArticles.add(element);
          }
        });

        categoryData.reference.update({
          'articles': allArticles
        });
      });
    });
  }

  @override
  Future<List<String>> searchFriend(String email) async {
    var collectionReference = firestore.collection("Users");
    var foundUser = await collectionReference.where("email", isEqualTo: email).limit(1).get();
    for (var element in foundUser) {
      return [element["email"], element.id];
    }
    return ["", ""];
  }

  @override
  void sendMessage(String chatId, String messageText) async {
    String uniqueMessageId = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    User user = await auth.getUser();
    Map<String, dynamic> message = <String, dynamic>{
      "sender": auth.userId,
      "message": messageText,
      "time": uniqueMessageId,
      "senderName": user.email
    };
    var collectionReference = firestore.collection("Chat");
    collectionReference.document(chatId).collection("messages").document(uniqueMessageId).set(message);
  }

  @override
  void setMetadataInDatabase(Map<String, int> metaDataMap) {
    var ref = firestore.collection("metadata");
    ref.document("data").update(metaDataMap);
  }

  @override
  String getCurrentUserId() {
    return auth.userId;
  }

  @override
  StreamSubscription? currentUserStream;
  @override
  void getCurrentUserData() {
    var ref = firestore.collection("Users");
    currentUserStream = ref.document(auth.userId).stream.map((Document? document) {
      if (document != null) {
        currentUserDetails.value = CurrentUserDetails.fromDocumentSnapshotWindows(document);
        // TODO
      }
    }).listen((event) { });
  }

  @override
  Rx<CurrentUserDetails> currentUserDetails = CurrentUserDetails(userId: "", email: "", username: "").obs;

  @override
  void uploadImage(Uint8List fileBytes, String extension) {
    Get.defaultDialog(title: "Sorry", textCustom: "Cannot Access Firebase Storage from Windows");
  }

  @override
  void updateUserData(Map<String, dynamic> data) {
    var ref = firestore.collection("Users");
    ref.document(getCurrentUserId()).update(data);
  }

  @override
  void updateTableData(String collectionName, String time, Map<String, String> newData) {
    var ref = firestore.collection(collectionName);
    ref.where("time", isEqualTo: time).get().then((List<Document> snapshot) {
      for (var element in snapshot) {
        element.reference.update(newData);
      }
    });
  }

  @override
  Future<Stream<List<String>>> getReviews(String time, String collectionName) {
    var ref = firestore.collection(collectionName);
    ref.where('time', isEqualTo: time).get().then((List<Document> snapshot) {
      for (var doc in snapshot) {
        return doc.reference.collection('reviews').stream.map((List<Document> snapshot) {
          List<String> reviewsList = <String>[];
          for (var doc in snapshot) {
            reviewsList.add(doc['review']);
          }
          return reviewsList;
        });
      }
    });
    throw "Reviews Not Found";
  }

  @override
  void sendReview(String review, String time, String collectionName) {
    var ref = firestore.collection(collectionName);
    ref.where('time', isEqualTo: time).get().then((List<Document> snapshot) async {
      User user = await auth.getUser();
      for (var doc in snapshot) {
        doc.reference.collection('reviews').add({
          'review': review,
          'sender': user.email,
          'time': DateTime.now().toUtc().millisecondsSinceEpoch.toString()
        });
      }
    });
  }

  @override
  uploadFile(Uint8List fileData, String fileName) async {
    throw 'Unimplemented Error';
  }

  @override
  void downloadFile(String fileName) {
    // TODO: implement downloadFile
  }

}