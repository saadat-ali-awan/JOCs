import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Dialog/problems_item.dart';
import 'package:jocs/Dashboard/Dialog/ticket_item.dart';
import 'package:jocs/Dashboard/Layout/dashboard_general.dart';
import 'package:jocs/Dashboard/Layout/dashboard_mobile.dart';
import 'package:jocs/Dashboard/Layout/top_menu.dart';
import 'package:jocs/Dashboard/Modals/screen_adapter.dart';
import 'package:jocs/FirebaseCustomControllers/ChatModels/person_model.dart';
import 'package:jocs/FirebaseCustomControllers/ChatModels/user_chat_model.dart';
import 'package:jocs/FirebaseCustomControllers/DataModels/article_category.dart';
import 'package:jocs/FirebaseCustomControllers/DataModels/detailed_metadata.dart';
import 'package:jocs/FirebaseCustomControllers/FirebaseInterface/firebase_controller_interface.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller_windows.dart';
import 'package:jocs/Theme/custom_theme.dart';


/// [DashboardController] is [GetxController] that controlls all the Data
/// being Displayed on [Dashboard] Screen
class DashboardController extends GetxController {
  // Get the Theme details Used in Dashboard Screen
  Rx<TextStyle?> menuItemStyle = ThemeColors.darkTheme?CustomTheme.darkTheme.textTheme.headline5.obs:CustomTheme.lightTheme.textTheme.headline5.obs;
  Rx<TextStyle?> submenuItemStyle = ThemeColors.darkTheme?CustomTheme.darkTheme.textTheme.headline6.obs:CustomTheme.lightTheme.textTheme.headline6.obs;
  Rx<TextStyle?> submenuItemStyle2 = ThemeColors.darkTheme?CustomTheme.darkTheme.textTheme.caption.obs:CustomTheme.lightTheme.textTheme.caption.obs;
  Rx<Color?> iconColor = ThemeColors.darkTheme?CustomTheme.darkTheme.iconTheme.color.obs:CustomTheme.lightTheme.iconTheme.color.obs;
  Rx<Color?> tileColor = ThemeColors.darkTheme?CustomTheme.darkTheme.appBarTheme.backgroundColor.obs:CustomTheme.lightTheme.appBarTheme.backgroundColor.obs;

  /// Value of [mobileDisplay] is used to Check if Layout Width is Less than 600
  /// If the Width is less than 600 than the Layout Designed for small screens
  /// is loaded.
  RxBool mobileDisplay = false.obs;

  /// On The Dashboard Screen The Amount of [openTickets] is required
  /// This amount is stored in [openTickets] which changes whenever there is
  /// update in Firebase Database.
  RxInt openTickets = 0.obs;

  /// On The Dashboard Screen The Amount of [unresolvedTickets] is required
  /// This amount is stored in [unresolvedTickets] which changes whenever there is
  /// update in Firebase Database.
  RxInt unresolvedTickets = 0.obs;

  /// On The Dashboard Screen The Amount of [unassignedTickets] is required
  /// This amount is stored in [unassignedTickets] which changes whenever there is
  /// update in Firebase Database.
  RxInt unassignedTickets = 0.obs;

  /// On The Dashboard Screen The Amount of [ticketsAssignedToMe] is required
  /// This amount is stored in [ticketsAssignedToMe] which changes whenever there is
  /// update in Firebase Database.
  RxInt ticketsAssignedToMe = 0.obs;

  /// [firebaseController] refers to the [FirebaseController] or
  /// [FirebaseControllerWindows] based on the platform the
  /// Application is running.
  late FirebaseControllerInterface firebaseController;

  /// [allChats] contains The List of all the Chats
  /// For Example, if UserA (Logged In User) is Chatting with UserB and UserC
  /// than [allChats] would have Two Items:
  /// 1. One item would Contain All the Chat of UserA with UserB
  /// 2. Other item would Contain All the Chat of UserA with UserC
  Map<String, RxList<MessageModel>> allChats = <String, RxList<MessageModel>>{};

  /// [metadata] Contains the Basic MetaData of Databased Used to
  /// Run the Application.
  /// [DetailedMetadata] contains All The Information About MetaData of
  /// Application.
  Rx<DetailedMetadata> metadata = DetailedMetadata().obs;

  DashboardController() {
    changeTheme();

    menuList = [
      [
        Text(
          "DASHBOARD",
          style: menuItemStyle.value,
        ),
        Icon(
          Icons.dashboard,
          color: iconColor.value,
          size: 32,
        )
      ],
      [
        Text(
          "TICKETS",
          style: menuItemStyle.value,
        ),
        Icon(
          Icons.all_inbox_sharp,
          color: iconColor.value,
          size: 32,
        )
      ],
      [
        Text(
          "PROBLEMS",
          style: menuItemStyle.value,
        ),
        Icon(
          Icons.clear,
          color: iconColor.value,
          size: 32,
        )
      ],
      [
        Text(
          "ASSETS",
          style: menuItemStyle.value,
        ),
        Icon(
          Icons.featured_play_list,
          color: iconColor.value,
          size: 32,
        ),
        Obx(
          () => Text(
            "INVENTORY",
            style: showPanel.value ? submenuItemStyle2.value : submenuItemStyle.value,
            textAlign: TextAlign.left,
          ),
        ),
        Obx(
          () => Text(
            "PURCHASE ORDER",
            style: showPanel.value ? submenuItemStyle2.value : submenuItemStyle.value,
            textAlign: TextAlign.left,
          ),
        )
      ],
      [
        Text(
          "CHAT",
          style: menuItemStyle.value,
        ),
        Icon(
          Icons.message,
          color: iconColor.value,
          size: 32,
        )
      ],
      [
        Text(
          "ETERNAL KBS",
          style: menuItemStyle.value,
        ),
        Icon(
          Icons.attach_file,
          color: iconColor.value,
          size: 32,
        )
      ],
      [
        Text(
          "SETTINGS",
          style: menuItemStyle.value,
        ),
        Icon(
          Icons.settings,
          color: iconColor.value,
          size: 32,
        )
      ],
      [
        Text(
          "Profile",
          style: menuItemStyle.value,
        ),
        Icon(
          Icons.home,
          color: iconColor.value,
          size: 32,
        )
      ]
    ];

    body.value = Stack(children: const [DashboardGeneral()]);

    // Login Controller is Initialized According to The Target Platform To Get
    // the data.
    if (defaultTargetPlatform != TargetPlatform.windows || kIsWeb) {
      firebaseController = Get.find<FirebaseController>();
      // firebaseController.getData("Tickets", 1);
    }else {
      if (defaultTargetPlatform == TargetPlatform.windows){
        firebaseController = Get.find<FirebaseControllerWindows>();
      }
    }

    getDashboardData();
    initializeStream();
    initializeUserData();
  }

  /// Initialize User Data is used to get User Data from The Database
  /// It would Load Username, Email and The Download Url of Profile Image of the
  /// User
  initializeUserData() async {
    await firebaseController.initializeFirebase();
    firebaseController.getCurrentUserData();
  }

  /// [body] refers to the body of Dashboard Screen
  /// For Screen Size > 600 The Navigation Menu is placed in a Row with the [MainScreen]
  /// But For Screen Size < 600 The Navigation Menu is Stacked Above the [MainScreen]
  Rx<Widget> body = Stack(
    children: [],
  ).obs;

  /// [showMenu] Will Show and Hide the Navigation Menu on Small Screens
  /// based on the value
  RxBool showMenu = false.obs;

  /// [showMenuForBigScreen] Will Show and Hide the Navigation Menu on Screens
  /// with size greater than 600 based on the value
  RxBool showMenuForBigScreen = false.obs;

  /// Show or Hide Navigation Menu Text on The Navigation Menu
  RxBool showPanel = false.obs;

  /// On The Mobile Screen [menuIcon] Shows Hamburger[Icons.menu] if Menu is
  /// closed and Shows Close Icon[Icons.clear] When Menu is Open.
  Rx<Widget> menuIcon = const Icon(Icons.menu,).obs;

  /// [menuList] contains List Of Widgets To Be Displayed in The
  /// Side Navigation Menu
  var menuList = [];

  /// ### Navigation Using [selectedMenuItem]
  ///
  /// **[selectedMenuItem]** is the Index Of the Selected Item
  ///
  /// Possible Values are:
  ///
  /// * 0 for Dashboard Screen
  /// * 1 for Tickets Screen
  /// * 2 for Problems Screen
  /// * 32 for Inventory Screen
  /// * 33 for Purchase Screen
  /// * 4 for Chat Screen
  /// * 5 for Eternal KBS
  /// * 6 for Settings Screen
  /// * 7 for Profile Screen
  var selectedMenuItem = 0.obs;

  /// ## Handle Different Layouts According to Screen Size
  ///
  /// Based on the value of [mobileDisplay.value] the Layout of the
  /// Screen Changes. The function [changeBody] changes the value of
  /// [body.value] which would eventualy effect the Layout of
  /// [Dashboard] Screen.
  changeBody(bool mobile) {
    mobileDisplay.value = mobile;
    if (mobile) {
      body.value = Stack(children: const [DashboardMobile()]);
    } else {
      body.value = Stack(children: const [DashboardGeneral()]);
    }
  }

  /// ### Add Tickets, Problems, Inventory and Purchase Data To Database
  ///
  /// When a dialog is opened from [TopMenu] and Data is added from
  /// **[TicketItem]**, **[ProblemsItem]**, **[InventoryItem]**
  /// and **[PurchaseItem]** the Add Button Calls [addDataToFirebase] to add the
  /// data to Firebase Database.
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
  void addDataToFirebase(Map<String, dynamic> data, String collectionName, String metadataKey, int lastId) {
    firebaseController.addDataToFirebase(data, collectionName, metadataKey, lastId);
  }

  /// [getDashboardData] binds the Firebase Snapshot
  /// Stream With [DetailedMetadata].
  ///
  /// Any Change in the Firebase could be seen in the Dashboard Whenever a
  /// record is **added** or **deleted**.
  getDashboardData() {
    metadata.bindStream(firebaseController.getMetaDataFromDatabase());
  }

  /// When there is new Data for DetailedMetadata the function below will update
  /// the values in the UI of Dashboard Screen
  updateDashboard() async {
    openTickets.value = await firebaseController.getDashboardData("status", filter:"OPEN");
    unresolvedTickets.value = await firebaseController.getDashboardData("status", filter: "RESOLVED");
    unresolvedTickets.value = metadata.value.ticketsCount - unresolvedTickets.value;
    unassignedTickets.value = await firebaseController.getDashboardData("assigned_to");
    unassignedTickets.value = metadata.value.ticketsCount - unassignedTickets.value;
    ticketsAssignedToMe.value = await firebaseController.getDashboardData("assigned_to", filter: firebaseController.currentUserDetails.value.email);
  }

  /// # Ticket Screen Adapter
  ///
  /// [ticketAdapter] is [ScreenAdapter] for Ticket Screen.
  /// It Contains All the information Used to Display or Update Data on Tickets
  /// Screen.
  late Rx<ScreenAdapter> ticketAdapter;

  /// ## Get Data For Tickets Screen
  ///
  /// [getTicketsData] is called to get the Data for the Tickets Screen.
  ///
  /// [customFilter] parameter is used for the Filters that can be applied on
  /// the data used by Table on Tickets Screen.
  getTicketsData({Map<String, String> customFilter = const <String, String>{}}) async {
    await ticketAdapter.value.getLatestTimeStamp(firebaseController);
    ticketAdapter.value.getDataForScreen(firebaseController, customFilter: customFilter, filter: ticketAdapter.value.latestTimeStamp);
    ticketAdapter.value.getNewDataForScreen(firebaseController, ticketAdapter.value.latestTimeStamp);
  }

  /// # Problems Screen Adapter
  ///
  /// [problemAdapter] is [ScreenAdapter] for Problems Screen.
  /// It Contains All the information Used to Display or Update Data on Problems
  /// Screen.
  late Rx<ScreenAdapter> problemAdapter;

  /// ## Get Data For Problems Screen
  ///
  /// [getProblemsData] is called to get the Data for the Problems Screen.
  ///
  /// [customFilter] parameter is used for the Filters that can be applied on
  /// the data used by Table on Problems Screen.
  getProblemsData({Map<String, String> customFilter = const <String, String>{}}) async {
    await problemAdapter.value.getLatestTimeStamp(firebaseController);
    problemAdapter.value.getDataForScreen(firebaseController, customFilter: customFilter, filter: problemAdapter.value.latestTimeStamp);
    problemAdapter.value.getNewDataForScreen(firebaseController, problemAdapter.value.latestTimeStamp);
  }

  /// # Inventory Screen Adapter
  ///
  /// [inventoryAdapter] is [ScreenAdapter] for Inventory Screen.
  /// It Contains All the information Used to Display or Update Data on
  /// Inventory Screen.
  late Rx<ScreenAdapter> inventoryAdapter;

  /// ## Get Data For Inventory Screen
  ///
  /// [getInventoryData] is called to get the Data for the Inventory Screen.
  ///
  /// [customFilter] parameter is used for the Filters that can be applied on
  /// the data used by Table on Inventory Screen.
  getInventoryData() async {
    await inventoryAdapter.value.getLatestTimeStamp(firebaseController);
    inventoryAdapter.value.getDataForScreen(firebaseController, filter: inventoryAdapter.value.latestTimeStamp);
    inventoryAdapter.value.getNewDataForScreen(firebaseController, inventoryAdapter.value.latestTimeStamp);
  }

  /// # Purchase Screen Adapter
  ///
  /// [purchaseAdapter] is [ScreenAdapter] for Purchase Screen.
  /// It Contains All the information Used to Display or Update Data on
  /// Purchase Screen.
  late Rx<ScreenAdapter> purchaseAdapter;

  /// ## Get Data For Purchase Screen
  ///
  /// [getPurchaseData] is called to get the Data for the Purchase Screen.
  ///
  /// [customFilter] parameter is used for the Filters that can be applied on
  /// the data used by Table on Purchase Screen.
  getPurchaseData() async {
    await purchaseAdapter.value.getLatestTimeStamp(firebaseController);
    purchaseAdapter.value.getDataForScreen(firebaseController, filter: purchaseAdapter.value.latestTimeStamp);
    purchaseAdapter.value.getNewDataForScreen(firebaseController, purchaseAdapter.value.latestTimeStamp);
  }


  /// [friendList] contains the List Of Friends Who A Person Chats With.
  ///
  /// It is used so that the list of Users can be displayed on the side menu
  /// of Chat Box.
  RxList<PersonModel> friendsList = RxList<PersonModel>();

  /// [groupList] contains the List Of Groups A Person can Chat On.
  ///
  /// It is used so that the list of Groups can be displayed on the side menu
  /// of Chat Box.
  RxList<PersonModel> groupList = RxList<PersonModel>();

  /// [openChat] contains All The Details About the Chat Screen That is opened
  /// for Chatting.
  PersonModel? openChat;

  /// [timer] is used To get the Latest messages after a set Interval of Time.
  Timer? timer;

  /// [initializeStream] is called when a user logs in and Dashboard is
  /// displayed. It initializes Streams For Friends And Groups A User Chats with
  /// which would be used on the side panel of the Chat Box.
  void initializeStream() async{
    await firebaseController.initializeFirebase();
    friendsList.bindStream(firebaseController.friendListStream());
    groupList.bindStream(firebaseController.groupListStream());
    getCategoryData();
    //firebaseController.newChatListener();
  }

  /// When User Creates A New Group on the Chat Screen [createNewGroup] is
  /// called which than eventually calls [createNewGroup] on [firebaseController]
  void createNewGroup(Map<String, dynamic> data){
    firebaseController.createNewGroup(data);
  }

  /// To Search a Friend With Email [searchFriend] calls searchFriend on
  /// FirebaseController and if a user is found than the value is returned.
  /// The Returned Value is of Format [[email, id]]
  /// Here email refers to the Email of The Friend and Id is the Id assigned to
  /// User Inside The FIREBASE Authentication.
  Future<List<String>> searchFriend(String friendEmail) async {
    if (friendEmail == firebaseController.auth.currentUser!.email){
      return ["", ""];
    }
    if (friendsList.contains(friendEmail)){
      return ["", ""];
    }
    return await firebaseController.searchFriend(friendEmail);
  }

  /// Adding a friend in the chat section calls this [addFriend] function which
  /// pass the data of the friend to the FirebaseController.
  ///
  /// [friendData] is [[friendEmail, friendId]]
  void addFriend(List friendData){
    firebaseController.addFriend(friendData);
  }

  /// To Add A Friend to a Group [addFriendToGroup] is called passing the details
  /// of Friend and the Group
  ///
  /// [friendData] is [[friendEmail, friendId]]
  /// [chatId] is The Id of the Group In which Friend Need to be added
  /// [groupName] refers to the Name Of the Group For which New User Will be
  /// added.
  void addFriendToGroup(List friendData, String chatId, String groupName){
    firebaseController.addFriendToGroup(friendData, chatId, groupName);
  }

  /// To Send A Message in a group or to a Friend [sendMessage] is Called from
  /// the Chat Box. This function will send the message to the
  /// FirebaseController so that it would send the message to the Firebase Database.
  sendMessage(String chatId, String sender, String message){
    firebaseController.sendMessage(chatId, message);
  }

  /// To Get The Latest Message in any Chat [getLatestMessage] using the chatId.
  /// If their is any message already present it will get the messages with
  /// Id greater than the message Id of the last Message.
  getLatestChatMessages(String chatId) async {
    if (allChats[chatId] == null || allChats[chatId]!.isEmpty) {
      allChats[chatId] = RxList<MessageModel>();
      List<MessageModel> messages= await firebaseController.getChat(chatId);
      for (MessageModel message in messages){
        allChats[chatId]!.add(message);
      }

    }else{
      List<MessageModel> messages= await firebaseController.getChat(chatId, allChats[chatId]!.last);
      for (MessageModel message in messages){
        allChats[chatId]!.add(message);
      }
    }
  }

  /// When a chat is selected a Timer is initialized that gets calls the
  /// [getLatestChatMessages] is called every 2 seconds to get the new Messages
  /// of the id referenced using [chatId]
  startTimer(String chatId){
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer.periodic(const Duration(seconds: 2),(Timer t) async {
      if ( allChats[chatId] == null){
        return;
      }
      if (allChats[chatId]![0].timeStamp.isEmpty){
        getLatestChatMessages(chatId);
        return;
      }
      List<MessageModel> newMessages = await firebaseController.getRecentChat(chatId, allChats[chatId]!.first.timeStamp);
      allChats[chatId]!.insertAll(0, newMessages.where((ele) => allChats[chatId]!.every((element) => ele.timeStamp != element.timeStamp)));
    });
  }

  /// ## Theme
  /// [changeTheme] is used to initialize the theme of Dashboard
  /// The ThemeName is stored in HiveStore and depending on it the Theme Would
  /// be Loaded
  void changeTheme(){
    menuItemStyle.value = ThemeColors.darkTheme?CustomTheme.darkTheme.textTheme.headline5:CustomTheme.lightTheme.textTheme.headline5;
    submenuItemStyle.value = ThemeColors.darkTheme?CustomTheme.darkTheme.textTheme.headline6:CustomTheme.lightTheme.textTheme.headline6;
    submenuItemStyle2.value = ThemeColors.darkTheme?CustomTheme.darkTheme.textTheme.caption:CustomTheme.lightTheme.textTheme.caption;
    iconColor.value = ThemeColors.darkTheme?CustomTheme.darkTheme.iconTheme.color:CustomTheme.lightTheme.iconTheme.color;
    tileColor.value = ThemeColors.darkTheme?CustomTheme.darkTheme.appBarTheme.backgroundColor:CustomTheme.lightTheme.appBarTheme.backgroundColor;
  }

  /// ## Articles Category List
  /// [categoryList] is the list of Categories that Users Created
  RxList<ArticleCategory> categoryList = RxList<ArticleCategory>();

  /// ## Add A Category
  /// [addArticleCategory] calls addArticleCategory on the firebaseController
  /// to add article category to the Firebase Database.
  /// [data] contains all the data required by the firebase to add the category
  /// [collectionName] would be equal to 'category'
  void addArticleCategory(Map<String, dynamic> data){
    firebaseController.addArticleCategory(data, "category");
  }

  /// ## Create New Article
  /// [createNewArticle] calls createNewArticle on the firebaseController
  /// to create new article and store in the Firebase Database.
  void createNewArticle(Map<String, dynamic> data){
    firebaseController.createNewArticle(data, metadata.value.articlesCount);
  }

  /// ## Get List Of Categories Using Firebase Snapshot Stream
  /// To Get the latest list of categories present in the database
  /// [getCategoryData] binds the Stream with the Categories Collection in the
  /// FirebaseDatabase.
  void getCategoryData() async {
    categoryList.bindStream(firebaseController.getCategoryData());
  }

  /// # Eternal KBS Screen Adapter
  ///
  /// [kbsAdapter] is [ScreenAdapter] for Eternal KBS Screen.
  /// It Contains All the information Used to Display or Update Data on
  /// Eternal KBS Screen.
  late Rx<ScreenAdapter> kbsAdapter;

  /// ## Get Data For Eternal KBS Screen
  ///
  /// [getKBSData] is called to get the Data for the Eternal KBS Screen.
  ///
  /// [customFilter] parameter is used for the Filters that can be applied on
  /// the data used by Table on Eternal KBS Screen.
  getKBSData({Map<String, String> customFilter = const <String, String>{}}) async {
    await kbsAdapter.value.getLatestTimeStamp(firebaseController);
    kbsAdapter.value.getDataForScreen(firebaseController, customFilter: customFilter, filter: kbsAdapter.value.latestTimeStamp);
    kbsAdapter.value.getNewDataForScreen(firebaseController, kbsAdapter.value.latestTimeStamp);
  }

  // void getUpdatedTableData() async {
  //   var snapshot;
  //   ScreenAdapter adapter;
  //   switch (selectedMenuItem.value){
  //     case 1:
  //       snapshot = await firebaseController.getNewData(ticketAdapter.value);
  //       adapter = ticketAdapter.value;
  //       break;
  //     case 2:
  //       snapshot = await firebaseController.getNewData(problemAdapter.value);
  //       adapter = problemAdapter.value;
  //       break;
  //     case 32:
  //       snapshot = await firebaseController.getNewData(inventoryAdapter.value);
  //       adapter = inventoryAdapter.value;
  //       break;
  //     case 33:
  //       snapshot = await firebaseController.getNewData(purchaseAdapter.value);
  //       adapter = purchaseAdapter.value;
  //       break;
  //     case 5:
  //       snapshot = await firebaseController.getNewData(kbsAdapter.value);
  //       adapter = kbsAdapter.value;
  //       break;
  //     default:
  //       return;
  //   }
  //
  //   for (var element in snapshot.docs) {
  //     adapter.adapterData.insert(0, element);
  //   }
  //
  //   RxList<DataRow> tempRows = <DataRow>[].obs;
  //
  //   String metadataKey = "";
  //   int metadataValue = 0;
  //
  //   for (var d in adapter.adapterData) {
  //     var tempData;
  //     if (adapter.screenName == "inventory"){
  //       tempData = [
  //         d["item_name"],
  //         d["item_type"],
  //         d["location"],
  //         d["used_by"],
  //         d["processed_by"],
  //         d["comments"]
  //       ];
  //       metadataKey = "inventoryCount";
  //       metadataValue = metadata.value.inventoryCount;
  //     }else {
  //       if (adapter.screenName == "purchase"){
  //         tempData = [
  //           d["order_no"],
  //           d["order_name"],
  //           d["description"],
  //           d["expected_delivery"],
  //           d["status"],
  //           d["comments"]
  //         ];
  //         metadataKey = "purchaseCount";
  //         metadataValue = metadata.value.purchaseCount;
  //       }else {
  //         if (adapter.screenName == "articles") {
  //           tempData = [
  //             d['author'],
  //             d['category-name'],
  //             d['comment'],
  //             d['topic']
  //           ];
  //           metadataKey = "articlesCount";
  //           metadataValue = metadata.value.articlesCount;
  //         }else {
  //           tempData = [
  //             d["issued_by"],
  //             d["topic"],
  //             d["status"],
  //             d["priority"],
  //             d["assigned_to"],
  //           ];
  //           if (adapter.screenName == "tickets") {
  //             tempData.add(d["comments"]);
  //             metadataKey = "ticketsCount";
  //             metadataValue = metadata.value.ticketsCount;
  //           } else {
  //             if (adapter.screenName == "problems") {
  //               tempData.add(d["department"]);
  //               metadataKey = "problemsCount";
  //               metadataValue = metadata.value.problemsCount;
  //             }
  //           }
  //         }
  //
  //       }
  //     }
  //     int index = tempRows.length;
  //     tempRows.add(ScreenAdapter.createRow(tempData, (){
  //       Get.defaultDialog(
  //           title: "Caution",
  //           titleStyle: TextStyle(color: Get.theme.errorColor),
  //           middleText: "Want to delete the row from Database?",
  //           confirm: TextButton(
  //             onPressed: () {
  //               // adapter.adapterData.removeAt(index);
  //               // adapter.dataTableSource.value.data.removeAt(index);
  //               // adapter.dataTableSource.value.data.refresh();
  //               // adapter.dataTableSource.value.notifyListeners();
  //               firebaseController.removeDataFromTable(adapter.screenName, d["time"], {metadataKey: metadataValue - 1});
  //               if (adapter.screenName == "articles") {
  //                 firebaseController.removeArticleFromCategory(d["category-name"], d.reference);
  //               }
  //               Get.back();
  //             },
  //             child: Text("DELETE", style: Get.textTheme.bodyText1,),
  //             style: Get.theme.textButtonTheme.style!.copyWith(backgroundColor: MaterialStateProperty.all(Get.theme.errorColor)),
  //           ),
  //
  //           cancel: TextButton(
  //             onPressed: () {
  //               Get.back();
  //             },
  //             child: Text("Cancel", style: Get.textTheme.bodyText1,),
  //           ),
  //
  //           onCancel: () {
  //             Get.back();
  //           }
  //       );
  //     }, false, adapter.screenName, d["time"]
  //     )
  //     );
  //   }
  //   adapter.dataTableSource.value = CustomDataTableSource(adapter.screenName, tempRows);
  // }

  /// ## Update Tables Data
  /// Update Tickets, Problems, Inventory and Purchase Data In The Database
  /// Using [firebaseController]
  /// 1. [collectionName] is the name of the collection for which update needs to
  /// done.
  /// 2. [time] is the identifier for the the data that needs to be updated.
  /// 3. [newData] is the updated data of the item that needs an update.
  void updateTableData(String collectionName, String time, Map<String, String> newData) {
    firebaseController.updateTableData(collectionName, time, newData);
  }

  /// ## Upload File For Article
  /// [task] is the [UploadTask] That would contain the information of file
  /// being Uploaded when Article is being created.
  UploadTask? task;

  /// Total Bytes Transferred While Uploading a file for the Article being
  /// created.
  RxString bytesTransferred = "".obs;

  /// Total Bytes in a file being uploaded for the Article being
  /// created.
  RxString totalBytes = "".obs;

  /// [uploadFile] Calls the Upload File in the Firebase Controller and listen for the changes
  /// in the Upload Task
  /// 1. [fileData] contains the data of file as a Uint8List
  /// 2. [fileName] is the name of the file that would be uploaded to Database
  void uploadFile(Uint8List fileData, String fileName) {
    task = firebaseController.uploadFile(fileData, fileName);
    task!.snapshotEvents.listen((TaskSnapshot snapshot) {
      bytesTransferred.value = snapshot.bytesTransferred.toString();
      totalBytes.value = '/'+snapshot.totalBytes.toString();
    });
  }

  /// Call Logout function in Firebase Controller to Log a User Out
  void logOut() {
    firebaseController.logOut();
  }

  /// Initialize Adapters for all the screens before showing the [Dashboard]
  /// Screen
  @override
  void onReady() async {
    ticketAdapter = ScreenAdapter("tickets").obs;
    problemAdapter = ScreenAdapter("problems").obs;
    inventoryAdapter = ScreenAdapter("inventory").obs;
    purchaseAdapter = ScreenAdapter("purchase").obs;
    kbsAdapter = ScreenAdapter("articles").obs;
    super.onReady();
  }

  /// Close All the Timers and Streams to Prevent Memory Leak
  @override
  void onClose() {
    if (timer != null) {
      timer!.cancel();
    }
    for (var element in firebaseController.chatScreenMainStreams) {
      element.cancel();
    }

    friendsList.close();
    metadata.close();
    groupList.close();
    categoryList.close();
    if (firebaseController.currentUserStream != null) {
      firebaseController.currentUserStream!.cancel();
    }

    for (var streamSubscription in ticketAdapter.value.tableSourceStreams) {
      streamSubscription.cancel();
    }

    for (var streamSubscription in kbsAdapter.value.tableSourceStreams) {
      streamSubscription.cancel();
    }

    for (var streamSubscription in purchaseAdapter.value.tableSourceStreams) {
      streamSubscription.cancel();
    }

    for (var streamSubscription in inventoryAdapter.value.tableSourceStreams) {
      streamSubscription.cancel();
    }

    for (var streamSubscription in kbsAdapter.value.tableSourceStreams) {
      streamSubscription.cancel();
    }

    super.onClose();
  }

}
