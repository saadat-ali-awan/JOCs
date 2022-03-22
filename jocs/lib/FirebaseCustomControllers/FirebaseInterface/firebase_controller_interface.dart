import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Modals/screen_adapter.dart';
import 'package:jocs/FirebaseCustomControllers/ChatModels/person_model.dart';
import 'package:jocs/FirebaseCustomControllers/ChatModels/user_chat_model.dart';
import 'package:jocs/FirebaseCustomControllers/ChatModels/user_details_model.dart';
import 'package:jocs/FirebaseCustomControllers/DataModels/article_category.dart';
import 'package:jocs/FirebaseCustomControllers/DataModels/detailed_metadata.dart';

abstract class FirebaseControllerInterface {
  get auth;

  get chatScreenMainStreams => null;

  Rx<CurrentUserDetails> get currentUserDetails;
  StreamSubscription? get currentUserStream;

  /// ### Add Tickets, Problems, Inventory and Purchase Data To Database
  ///
  /// Using the parameters described below the data is added to the database.
  /// 1. [data] contains data in Json Format. It would have all the data that is
  /// required for a particular field. The data Also Contains the time when the
  /// button was clicked.
  /// 2. [collectionName] is the Name of the Collection or Screen For which the
  /// data was added into the database.
  /// 3. [metadataKey] is the Key That is Used to Update MetaData of the database
  /// in FireStore. **MetaData IT IS NOT PART OF FIREBASE BY DEFAULT. Instead of
  /// Using Word METADATA ONE CAN USE ANY OTHER NAME. METADATA IS CREATED as a
  /// Collection To STORE THE COUNT OF ALL The ITEMS. IF THIS COUNT WAS NOT
  /// STORED THE DASHBOARD SCREEN WOULD HAVE A DIFFICULT AND SLOW WAY OF
  /// GETTING TOTAL COUNT**
  /// 4. [lastId] contains Id of the Last Retrieved Data From Firebase. Infact
  /// it contains the creation `time` of the last document.
  Future<void> addDataToFirebase(data, String collectionName, String metadataKey, int lastId);

  /// ## Add A Category
  /// [addArticleCategory] Add the category using [data] to the database
  /// [data] contains all the data required by the firebase to add the category
  /// [collectionName] would be equal to 'category'
  void addArticleCategory(Map<String, dynamic> data, String collectionName);

  /// [addFriend] will add the [friendData] as a friend of the user in database
  ///
  /// Than the User itself is added as Friend of the friend User wants to chat
  /// with.
  ///
  /// At last a new Chat is created inside the database for this chat to start
  /// chatting.
  Future<void> addFriend(List friendData);

  /// To add a Friend to the group the [chatId] of the group is added to the Users
  /// document in the database. [addFriendToGroup] adds the document to the
  /// Firebase Database.
  Future<void> addFriendToGroup(List friendData, String chatId, String groupName);

  /// To Create a New Group
  /// 1. Create the unique id of the group using the Current Time and the
  /// Id of the Current User.
  /// 2. Add group data to the group document using [groupUniqueId] inside the
  /// Groups of The Current User Document.
  /// 3. Create the Chat for the group using [groupUniqueId]
  Future<void> createNewGroup(groupData);

  /// Create A Document for the Chat using the Chat Id in 'Chat' collection
  Future<void> createNewChat(id);

  /// Check if the user is logged in or not
  bool checkFirebaseLoggedIn();

  /// ### Creates New Article in The Firebase Database based on following Instructions:
  /// 1. Create Identifier for the Article
  /// 2. Add Article to the articles collection
  /// 3. Add reference to the article in the Category for which article was
  /// written
  void createNewArticle(Map<String, dynamic> data, int lastId);

  /// ### Downloads file from the Database
  /// [fileName] is the name of the file that needs to be downloaded from
  /// articles folder.
  void downloadFile(String fileName);

  /// Get Stream of friends from the User Document in the Firebase Database
  /// It just returns the Friends that could be displayed on the side of Chat
  /// Box.
  Stream<List<PersonModel>> friendListStream();

  /// Get Stream of data for one page from database.
  ///
  /// 1. [firebaseController] is reference to the FirebaseController that is used
  /// to get data from Firebase Database.
  /// 2. [filter] is an optional parameter used to Provide the time(which is
  /// identifier of the elements) so that if there was some data already fetched
  /// we can fetched the older data. It helps in pagination.
  /// 3. [customFilter] is the filter that a user can customise. It is present
  /// in Tickets Screen and problems Screen Named as Status and Priority.
  /// 4. [nextPage] specifies if a user is demanding Next Page or Not.
  ///
  /// To get the data all the filters are attached to the collectionReference.
  /// Once the Query is prepared ref.snapshots is used to get the Stream of
  /// documents contained in the query.
  ///
  /// For a batch of [length] one Stream would be created. It would listen to
  /// any changes that occur in the stream.
  Stream<dynamic> getData(String collectionName, int page, int length, {String filter = "", Map<String, String> customFilter = const <String, String>{}});

  /// For the Dashboard Screen [getDashboardData] is used which returns the
  /// details of data to dashboard.
  ///
  /// 1. [documentName] is the field for which the Dashboard data is required.
  /// For Example 'assigned_to' and 'status'.
  ///
  /// 2. [filter] carries the value for which the data has to found. For Example,
  /// For Open ticket filter = 'OPEN'.
  ///
  /// [getDashboardData] return the length of the total records found for the
  /// query.
  Future<int> getDashboardData(String documentName, {String filter= ""});

  /// Get Stream of Groups from the User Document in the Firebase Database
  /// It just returns the Groups that could be displayed on the side of Chat
  /// Box.
  Stream<List<PersonModel>> groupListStream();

  /// Get The Previous Messages from the firebase
  /// 1. [chaId] is the Id of the chat for which Chat has to be Fetched.
  /// 2. [lastMessage] contains the last fetched message from the Database.
  ///
  /// Depending on the Chat Id [getChat] fetches the **Previous** messages from
  /// the database.
  ///
  /// If [lastMessage] was null it meant that there was no previous fetches of
  /// the chat from the database. So the data will be fetched from start. Else
  /// if the there was some previous history than the messages older than the
  /// [lastMessage] would be fetched.
  ///
  /// It returns the list of messages fetched from the database in the form of
  /// [List<MessageModel>]
  Future<List<MessageModel>> getChat(String chatId, [MessageModel? lastMessage]);

  /// To Get the Recent Chat firbase collection 'Chat' is queried with chatId
  /// and getting the messages where the time field of the message has a value
  /// greater than the last fetched Message.
  ///
  /// 1. [chatId] is the reference to the Chat for which recent messages are
  /// required.
  /// 2. [mostRecentMessageTimeStamp] is the Time after which the messages are
  /// required to be fetched.
  ///
  /// Returns [List<MessageModel>] containing the new Messages
  Future<List<MessageModel>> getRecentChat(String chatId, String mostRecentMessageTimeStamp);

  /// Return the Id assigned by Firebase Authentication To The User
  String getCurrentUserId();

  /// Get The User Data from Users Collection
  /// The Email, UserName and User Profile image are fetched and stored in
  /// [currentUserDetails] using [CurrentUserDetails.fromDocumentSnapshot]
  void getCurrentUserData();

  /// Get The Articles written for the category from the database.
  ///
  /// returns a Stream in which it would listen for any changes or adding or
  /// removing article from database.
  Stream<List<ArticleCategory>> getCategoryData();

  /// Using the [documentId] retrieve the Document and return the snapshot of
  /// Document to open the article.
  Future<dynamic> getArticle(String documentId);

  /// Using the [time] at which the article was created retrieve the Document
  /// and return the snapshot of Document to open the article.
  Future<dynamic> getArticleByTime(time);

  /// From the **metadata** collection retrieve the data snapshots and Listen to
  /// the changes in the document.
  ///
  /// Returns the Stream of DetailedMetadata so that any update in the data is
  /// quickly shown
  Stream<DetailedMetadata> getMetaDataFromDatabase();

  /// For an article Retrieve the Reviews from the article in the articles
  /// collection.
  ///
  /// 1. [time] is used to retrieve the article.
  /// 2. [collectionName] is equal to the Collection Name For which the article
  /// was written.
  ///
  /// Returns The Stream to the Reviews so that when some one post a review
  /// it is visible in the screen.
  Future<Stream<List<Map<String, dynamic>>>> getReviews(String time, String collectionName);

  ///
  Stream<dynamic> getNewData(String timeStamp, String screenName);

  Future<String> getLatestTimeStamp(String screenName);

  /// Initialize Firebase App to be used during the entire session
  initializeFirebase();

  /// Get The Login Controller Using Get.find()
  initializeLoginController();

  /// Get The Register Controller Using Get.find()
  initializeRegisterController();

  /// Using [email] and [password] try to login into the Application
  ///
  /// Returns the Error Message If User their was some error else go the
  /// Dashboard Screen if Login was successful.
  login(String email, String password);

  /// Logout User and Move to the Login Screen.
  void logOut();


  // void newChatListener();

  /// Using [username], [email] and [password] try to register the User.
  ///
  /// Returns the Error Message If User their was some error else go the
  /// Dashboard Screen if Register was successful.
  register(String username, String email, String password);

  /// Using [time] as an identifier in a collection referenced by [screenName]
  /// the record is removed from the database
  /// map is used to change the value of Metadata because a document was removed.
  void removeDataFromTable(String screenName, String time, Map<String, int> map);

  /// 1. To Remove The Article From The Category first the category for which the
  /// article was written is accessed using [categoryName]
  /// 2. Than using [reference.id] exact article is found and than deleted from
  /// the array of articles present in the list of articles inside Category.
  void removeArticleFromCategory(String categoryName, reference);

  /// [searchFriend] searches for user in Users collection using "email" as the
  /// key.
  ///
  /// If a user is found an array containing user email and id is returned
  /// else an array with two empty strings is returned.
  Future<List<String>> searchFriend(String email);

  /// 1. To a send a message to friend or a group [sendMessage] reference the chat
  /// using [chatId].
  /// 2. A [uniqueMessageId] is created which refer the current time in milliseconds.
  /// 3. The message using the [uniqueMessageId] is added to the database.
  void sendMessage(String chatId, String message);

  /// Update Metadata in database
  void setMetadataInDatabase(Map<String, int> metaDataMap);

  /// To Send a review to an item in the table first the document is referenced
  /// using the [time] in a collection with name [collectionName].
  ///
  /// After finding the document the review is added to the Firebase Database
  /// where the identifier is the current time in milliseconds.
  void sendReview(String review, String time, String collectionName);

  /// In the Firebase Storage the file is uploaded using the fileBytes in
  /// Uint8List format. The image name is the Auth id of the user assigned
  /// by the database.
  ///
  /// The path of image is stored in Current Users User Details
  void uploadImage(Uint8List imageData, String extension);

  /// To Update the Current User Data User is found in the Users collection
  /// using the auth id. Than the Map of document is passed to change the
  /// required fields.
  void updateUserData(Map<String, dynamic> data);

  /// First [collectionName] is used to reference the Collection which would be
  /// updated.
  ///
  /// The [time] is used to find the record in the collection.
  ///
  /// After the document is found [newData] is updated for the document
  void updateTableData(String collectionName, String time, Map<String, String> newData);

  /// In the Firebase Storage the file is uploaded using the fileBytes in
  /// Uint8List format. The image name is the [fileName].
  ///
  /// This filename is also stored in the article for which article was added.
  ///
  UploadTask uploadFile(Uint8List fileData, String fileName);
}