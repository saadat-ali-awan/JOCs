import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Layout/dashboard_general.dart';
import 'package:jocs/Dashboard/Layout/dashboard_mobile.dart';
import 'package:jocs/Dashboard/Modals/screen_adapter.dart';
import 'package:jocs/FirebaseCustomControllers/ChatModels/person_model.dart';
import 'package:jocs/FirebaseCustomControllers/ChatModels/user_chat_model.dart';
import 'package:jocs/FirebaseCustomControllers/FirebaseInterface/firebase_controller_interface.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller_windows.dart';

class DashboardController extends GetxController {
  var menuItemStyle = Get.theme.textTheme.headline5;
  var submenuItemStyle = Get.theme.textTheme.headline6;
  var submenuItemStyle2 = Get.theme.textTheme.caption;
  var iconColor = Get.theme.iconTheme.color;
  var tileColor = Get.theme.appBarTheme.backgroundColor;
  late final List<Widget> menuItemWidgets;
  RxBool mobileDisplay = false.obs;
  RxInt openTickets = 0.obs;
  RxInt unresolvedTickets = 0.obs;
  RxInt unassignedTickets = 0.obs;
  RxInt ticketsAssignedToMe = 0.obs;

  late FirebaseControllerInterface firebaseController;

  Map<String, RxList<MessageModel>> allChats = <String, RxList<MessageModel>>{};

  DashboardController() {
    menuList = [
      [
        Text(
          "DASHBOARD",
          style: menuItemStyle,
        ),
        Icon(
          Icons.dashboard,
          color: iconColor,
          size: 32,
        )
      ],
      [
        Text(
          "TICKETS",
          style: menuItemStyle,
        ),
        Icon(
          Icons.all_inbox_sharp,
          color: iconColor,
          size: 32,
        )
      ],
      [
        Text(
          "PROBLEMS",
          style: menuItemStyle,
        ),
        Icon(
          Icons.clear,
          color: iconColor,
          size: 32,
        )
      ],
      [
        Text(
          "ASSETS",
          style: menuItemStyle,
        ),
        Icon(
          Icons.featured_play_list,
          color: iconColor,
          size: 32,
        ),
        Obx(
          () => Text(
            "INVENTORY",
            style: showPanel.value ? submenuItemStyle2 : submenuItemStyle,
            textAlign: TextAlign.left,
          ),
        ),
        Obx(
          () => Text(
            "PURCHASE ORDER",
            style: showPanel.value ? submenuItemStyle2 : submenuItemStyle,
            textAlign: TextAlign.left,
          ),
        )
      ],
      [
        Text(
          "CHAT",
          style: menuItemStyle,
        ),
        Icon(
          Icons.message,
          color: iconColor,
          size: 32,
        )
      ],
      [
        Text(
          "ETERNAL KBS",
          style: menuItemStyle,
        ),
        Icon(
          Icons.attach_file,
          color: iconColor,
          size: 32,
        )
      ],
      [
        Text(
          "SETTINGS",
          style: menuItemStyle,
        ),
        Icon(
          Icons.settings,
          color: iconColor,
          size: 32,
        )
      ]
    ];

    ticketAdapter = ScreenAdapter("tickets").obs;
    problemAdapter = ScreenAdapter("problems").obs;
    inventoryAdapter = ScreenAdapter("inventory").obs;
    purchaseAdapter = ScreenAdapter("purchase").obs;



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

  void addDataToFirebase(Map<String, dynamic> data, String collectionName) {
    firebaseController.addDataToFirebase(data, collectionName);
  }

  /// Dashboard Screen Getx Logic
  getDashboardData() async{
    ticketAdapter.value.lastId.value = await firebaseController.getLastId("tickets");
    openTickets.value = await firebaseController.getDashboardData("status", filter:"OPEN");
    unresolvedTickets.value = await firebaseController.getDashboardData("status", filter: "RESOLVED");
    print("${unresolvedTickets.value} - ${ticketAdapter.value.lastId.value}");
    unresolvedTickets.value = ticketAdapter.value.lastId.value - unresolvedTickets.value - 1;
    unassignedTickets.value = await firebaseController.getDashboardData("assigned_to");
    unassignedTickets.value = ticketAdapter.value.lastId.value - unassignedTickets.value - 1;
  }

  /// Tickets Screen Getx Logic
  late Rx<ScreenAdapter> ticketAdapter;
  getTicketsData() async {
    ticketAdapter.value.getScreenData(firebaseController);
    ticketAdapter.value.lastId.value = await firebaseController.getLastId("tickets");
  }
  /**
  * Tickets Screen Getx Logic
  **/

  /// Problems Screen Getx Logic
  late Rx<ScreenAdapter> problemAdapter;
  getProblemsData() async {
    problemAdapter.value.getScreenData(firebaseController);
    problemAdapter.value.lastId.value = await firebaseController.getLastId("problems");
  }
  /**
   * Problems Screen Getx Logic
   **/

  /// Inventory Screen Getx Logic
  late Rx<ScreenAdapter> inventoryAdapter;
  getInventoryData() async {
    inventoryAdapter.value.getScreenData(firebaseController);
    inventoryAdapter.value.lastId.value = await firebaseController.getLastId("inventory");
  }
  /**
   * Inventory Screen Getx Logic
   **/

  /// Purchase Screen Getx Logic
  late Rx<ScreenAdapter> purchaseAdapter;
  getPurchaseData() async {
    purchaseAdapter.value.getScreenData(firebaseController);
    purchaseAdapter.value.lastId.value = await firebaseController.getLastId("purhase");
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
      timer!.cancel();
    }
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


}
