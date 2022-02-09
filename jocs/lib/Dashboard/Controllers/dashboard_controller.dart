import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Layout/dashboard_general.dart';
import 'package:jocs/Dashboard/Layout/dashboard_mobile.dart';
import 'package:jocs/Dashboard/Modals/screen_adapter.dart';
import 'package:jocs/Dashboard/Screens/tickets_screen.dart';
import 'package:jocs/FirebaseCustomControllers/ChatModels/person_model.dart';
import 'package:jocs/FirebaseCustomControllers/ChatModels/user_chat_model.dart';
import 'package:jocs/FirebaseCustomControllers/DataModels/article_category.dart';
import 'package:jocs/FirebaseCustomControllers/DataModels/detailed_metadata.dart';
import 'package:jocs/FirebaseCustomControllers/FirebaseInterface/firebase_controller_interface.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller_windows.dart';
import 'package:jocs/Theme/custom_theme.dart';

class DashboardController extends GetxController {
  Rx<TextStyle?> menuItemStyle = ThemeColors.darkTheme?CustomTheme.darkTheme.textTheme.headline5.obs:CustomTheme.lightTheme.textTheme.headline5.obs;
  Rx<TextStyle?> submenuItemStyle = ThemeColors.darkTheme?CustomTheme.darkTheme.textTheme.headline6.obs:CustomTheme.lightTheme.textTheme.headline6.obs;
  Rx<TextStyle?> submenuItemStyle2 = ThemeColors.darkTheme?CustomTheme.darkTheme.textTheme.caption.obs:CustomTheme.lightTheme.textTheme.caption.obs;
  Rx<Color?> iconColor = ThemeColors.darkTheme?CustomTheme.darkTheme.iconTheme.color.obs:CustomTheme.lightTheme.iconTheme.color.obs;
  Rx<Color?> tileColor = ThemeColors.darkTheme?CustomTheme.darkTheme.appBarTheme.backgroundColor.obs:CustomTheme.lightTheme.appBarTheme.backgroundColor.obs;
  late final List<Widget> menuItemWidgets;
  RxBool mobileDisplay = false.obs;
  RxInt openTickets = 0.obs;
  RxInt unresolvedTickets = 0.obs;
  RxInt unassignedTickets = 0.obs;
  RxInt ticketsAssignedToMe = 0.obs;

  late FirebaseControllerInterface firebaseController;

  Map<String, RxList<MessageModel>> allChats = <String, RxList<MessageModel>>{};

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

    ticketAdapter = ScreenAdapter("tickets").obs;
    problemAdapter = ScreenAdapter("problems").obs;
    inventoryAdapter = ScreenAdapter("inventory").obs;
    purchaseAdapter = ScreenAdapter("purchase").obs;
    kbsAdapter = ScreenAdapter("articles").obs;



    body.value = Stack(children: const [DashboardGeneral()]);

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
    firebaseController.getCurrentUserData();
  }

  Rx<Widget> body = Stack(
    children: [],
  ).obs;

  RxBool showMenu = false.obs;
  RxBool showMenuForBigScreen = false.obs;
  RxBool showPanel = false.obs;
  Rx<Widget> menuIcon = const Icon(Icons.menu,).obs;

  var menuList = [];
  var selectedMenuItem = 0.obs;

  changeBody(bool mobile) {
    mobileDisplay.value = mobile;
    if (mobile) {
      body.value = Stack(children: const [DashboardMobile()]);
    } else {
      body.value = Stack(children: const [DashboardGeneral()]);
    }
  }

  void addDataToFirebase(Map<String, dynamic> data, String collectionName, String metadataKey, int lastId) {
    firebaseController.addDataToFirebase(data, collectionName, metadataKey, lastId);
  }

  /// Dashboard Screen Getx Logic
  getDashboardData() {
    metadata.bindStream(firebaseController.getMetaDataFromDatabase());
  }

  updateDashboard() async {
    openTickets.value = await firebaseController.getDashboardData("status", filter:"OPEN");
    unresolvedTickets.value = await firebaseController.getDashboardData("status", filter: "RESOLVED");
    print('TicletsCount: ${metadata.value.ticketsCount}, Resloved Tickets: ${unresolvedTickets.value}');
    unresolvedTickets.value = metadata.value.ticketsCount - unresolvedTickets.value;
    unassignedTickets.value = await firebaseController.getDashboardData("assigned_to");
    unassignedTickets.value = metadata.value.ticketsCount - unassignedTickets.value;
    ticketsAssignedToMe.value = await firebaseController.getDashboardData("assigned_to", filter: firebaseController.currentUserDetails.value.email);
  }

  /// Tickets Screen Getx Logic
  late Rx<ScreenAdapter> ticketAdapter;
  getTicketsData({Map<String, String> customFilter = const <String, String>{}}) async {
    ticketAdapter.value.getScreenData(firebaseController, customFilter: customFilter);
  }
  /**
  * Tickets Screen Getx Logic
  **/

  /// Problems Screen Getx Logic
  late Rx<ScreenAdapter> problemAdapter;
  getProblemsData({Map<String, String> customFilter = const <String, String>{}}) async {
    problemAdapter.value.getScreenData(firebaseController, customFilter: customFilter);
  }
  /**
   * Problems Screen Getx Logic
   **/

  /// Inventory Screen Getx Logic
  late Rx<ScreenAdapter> inventoryAdapter;
  getInventoryData() async {
    inventoryAdapter.value.getScreenData(firebaseController);
  }
  /**
   * Inventory Screen Getx Logic
   **/

  /// Purchase Screen Getx Logic
  late Rx<ScreenAdapter> purchaseAdapter;
  getPurchaseData() async {
    purchaseAdapter.value.getScreenData(firebaseController);
  }
  /**
   * Purchase Screen Getx Logic
   **/

  /// Chat Screen Logic

  RxList<PersonModel> friendsList = RxList<PersonModel>();
  RxList<PersonModel> groupList = RxList<PersonModel>();

  PersonModel? openChat;

  Timer? timer;

  void initializeStream(){
    friendsList.bindStream(firebaseController.friendListStream());
    groupList.bindStream(firebaseController.groupListStream());
    getCategoryData();
    //firebaseController.newChatListener();
  }

  void createNewGroup(Map<String, dynamic> data){
    firebaseController.createNewGroup(data);
  }

  Future<List<String>> searchFriend(String friendEmail) async {
    if (friendEmail == firebaseController.auth.currentUser!.email){
      return ["", ""];
    }
    if (friendsList.contains(friendEmail)){
      return ["", ""];
    }
    return await firebaseController.searchFriend(friendEmail);
  }

  void addFriend(List friendData){
    firebaseController.addFriend(friendData);
  }

  void addFriendToGroup(List friendData, String chatId, String groupName){
    firebaseController.addFriendToGroup(friendData, chatId, groupName);
  }

  sendMessage(String chatId, String sender, String message){
    firebaseController.sendMessage(chatId, message);
  }

  startChatStream(String chatId) async {
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

  startTimer(String chatId){
    if (timer != null) {
      print('Timer REMOVED');
      timer!.cancel();
    }
    print('Timer STARTED');
    timer = Timer.periodic(const Duration(seconds: 2),(Timer t) async {
      if ( allChats[chatId] == null){
        return;
      }
      if (allChats[chatId]![0].timeStamp.isEmpty){
        startChatStream(chatId);
        return;
      }
      List<MessageModel> newMessages = await firebaseController.getRecentChat(chatId, allChats[chatId]!.first.timeStamp);
      allChats[chatId]!.insertAll(0, newMessages.where((ele) => allChats[chatId]!.every((element) => ele.timeStamp != element.timeStamp)));
    });
  }

  /// Theme
  void changeTheme(){
    menuItemStyle.value = ThemeColors.darkTheme?CustomTheme.darkTheme.textTheme.headline5:CustomTheme.lightTheme.textTheme.headline5;
    submenuItemStyle.value = ThemeColors.darkTheme?CustomTheme.darkTheme.textTheme.headline6:CustomTheme.lightTheme.textTheme.headline6;
    submenuItemStyle2.value = ThemeColors.darkTheme?CustomTheme.darkTheme.textTheme.caption:CustomTheme.lightTheme.textTheme.caption;
    iconColor.value = ThemeColors.darkTheme?CustomTheme.darkTheme.iconTheme.color:CustomTheme.lightTheme.iconTheme.color;
    tileColor.value = ThemeColors.darkTheme?CustomTheme.darkTheme.appBarTheme.backgroundColor:CustomTheme.lightTheme.appBarTheme.backgroundColor;
  }

  /// Eternal KBS Screen Functions
  RxList<ArticleCategory> categoryList = RxList<ArticleCategory>();
  void addArticleCategory(Map<String, dynamic> data){
    firebaseController.addArticleCategory(data, "category");
  }

  void createNewArticle(Map<String, dynamic> data){
    firebaseController.createNewArticle(data, metadata.value.articlesCount);
  }

  void getCategoryData() async {
    categoryList.bindStream(firebaseController.getCategoryData());
  }

  late Rx<ScreenAdapter> kbsAdapter;
  getKBSData({Map<String, String> customFilter = const <String, String>{}}) async {
    kbsAdapter.value.getScreenData(firebaseController, customFilter: customFilter);
  }

  void getUpdatedTableData() async {
    var snapshot;
    ScreenAdapter adapter;
    switch (selectedMenuItem.value){
      case 1:
        snapshot = await firebaseController.getNewData(ticketAdapter.value);
        adapter = ticketAdapter.value;
        break;
      case 2:
        snapshot = await firebaseController.getNewData(problemAdapter.value);
        adapter = problemAdapter.value;
        break;
      case 32:
        snapshot = await firebaseController.getNewData(inventoryAdapter.value);
        adapter = inventoryAdapter.value;
        break;
      case 33:
        snapshot = await firebaseController.getNewData(purchaseAdapter.value);
        adapter = purchaseAdapter.value;
        break;
      case 5:
        snapshot = await firebaseController.getNewData(kbsAdapter.value);
        adapter = kbsAdapter.value;
        break;
      default:
        return;
    }

    for (var element in snapshot.docs) {
      adapter.adapterData.insert(0, element);
    }

    RxList<DataRow> tempRows = <DataRow>[].obs;

    String metadataKey = "";
    int metadataValue = 0;

    for (var d in adapter.adapterData) {
      var tempData;
      if (adapter.screenName == "inventory"){
        tempData = [
          d["item_name"],
          d["item_type"],
          d["location"],
          d["used_by"],
          d["processed_by"],
          d["comments"]
        ];
        metadataKey = "inventoryCount";
        metadataValue = metadata.value.inventoryCount;
      }else {
        if (adapter.screenName == "purchase"){
          tempData = [
            d["order_no"],
            d["order_name"],
            d["description"],
            d["expected_delivery"],
            d["status"],
            d["comments"]
          ];
          metadataKey = "purchaseCount";
          metadataValue = metadata.value.purchaseCount;
        }else {
          if (adapter.screenName == "articles") {
            tempData = [
              d['author'],
              d['category-name'],
              d['comment'],
              d['topic']
            ];
            metadataKey = "articlesCount";
            metadataValue = metadata.value.articlesCount;
          }else {
            tempData = [
              d["issued_by"],
              d["topic"],
              d["status"],
              d["priority"],
              d["assigned_to"],
            ];
            if (adapter.screenName == "tickets") {
              tempData.add(d["comments"]);
              metadataKey = "ticketsCount";
              metadataValue = metadata.value.ticketsCount;
            } else {
              if (adapter.screenName == "problems") {
                tempData.add(d["department"]);
                metadataKey = "problemsCount";
                metadataValue = metadata.value.problemsCount;
              }
            }
          }

        }
      }
      int index = tempRows.length;
      tempRows.add(ScreenAdapter.createRow(tempData, (){
        Get.defaultDialog(
            title: "Caution",
            titleStyle: TextStyle(color: Get.theme.errorColor),
            middleText: "Want to delete the row from Database?",
            confirm: TextButton(
              onPressed: () {
                adapter.adapterData.removeAt(index);
                adapter.dataTableSource.value.data.removeAt(index);
                adapter.dataTableSource.value.data.refresh();
                adapter.dataTableSource.value.notifyListeners();
                firebaseController.removeDataFromTable(adapter.screenName, d["time"], {metadataKey: metadataValue - 1});
                if (adapter.screenName == "articles") {
                  firebaseController.removeArticleFromCategory(d["category-name"], d.reference);
                }
                Get.back();
              },
              child: Text("DELETE", style: Get.textTheme.bodyText1,),
              style: Get.theme.textButtonTheme.style!.copyWith(backgroundColor: MaterialStateProperty.all(Get.theme.errorColor)),
            ),

            cancel: TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Cancel", style: Get.textTheme.bodyText1,),
            ),

            onCancel: () {
              Get.back();
            }
        );
      }, false, adapter.screenName, d["time"]
      )
      );
    }
    adapter.dataTableSource.value = CustomDataTableSource(adapter.screenName, tempRows);
  }

  /// Update Pages Data
  void updateTableData(String collectionName, String time, Map<String, String> newData) {
    firebaseController.updateTableData(collectionName, time, newData);
  }

  UploadTask? task;
  RxString bytesTransfered = "".obs;
  RxString totalBytes = "".obs;
  void uploadFile(Uint8List fileData, String fileName) {
    task = firebaseController.uploadFile(fileData, fileName);
    task!.snapshotEvents.listen((TaskSnapshot snapshot) {
      bytesTransfered.value = snapshot.bytesTransferred.toString();
      totalBytes.value = '/'+snapshot.totalBytes.toString();
    });
  }

  void logOut() {
    firebaseController.logOut();
  }

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

    super.onClose();
  }

}
