import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';
import 'package:jocs/Dashboard/Dialog/ChatScreenDialogs/chat_screen_dialog.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  final DashboardController _dashboardController =
      Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    if (_dashboardController.mobileDisplay.value) {
      return MobileChatScreen();
    }
    return DesktopChatScreen();
  }
}

class MobileChatScreen extends StatelessWidget {
  MobileChatScreen({Key? key}) : super(key: key);
  final DashboardController _dashboardController =
      Get.find<DashboardController>();

  RxString selectedChat = "none".obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.favorite,
                  color: Get.theme.appBarTheme.backgroundColor,
                ),
              ),
              Expanded(
                child: Obx(() {
                  return SizedBox(
                    height: 56,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            _dashboardController.friendsList.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: InkWell(
                              onTap: () {
                                selectedChat.value = _dashboardController
                                    .friendsList.value[index].modelName;
                              },
                              child: Container(
                                padding: EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Get.theme.appBarTheme
                                            .backgroundColor!),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0))),
                                child: Text(_dashboardController
                                    .friendsList[index].modelName),
                              ),
                            )),
                          );
                        }),
                  );
                }),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.group,
                  color: Get.theme.appBarTheme.backgroundColor,
                ),
              ),
              Expanded(
                child: Obx(() {
                  return SizedBox(
                    height: 56,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _dashboardController.groupList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: InkWell(
                              onTap: () {
                                if ((_dashboardController.openChat != null &&
                                    _dashboardController.openChat!.chatId == _dashboardController.friendsList[index].chatId)) {
                                  return;
                                }
                                _dashboardController.startTimer(_dashboardController.friendsList[index].chatId);
                                if (_dashboardController.allChats[_dashboardController.friendsList[index].chatId] != null){
                                  selectedChat.value =
                                      _dashboardController
                                          .friendsList[index]
                                          .modelName;
                                  _dashboardController.openChat =
                                  _dashboardController
                                      .friendsList[index];
                                  return;
                                }
                                _dashboardController.openChat =
                                _dashboardController
                                    .friendsList[index];
                                _dashboardController
                                    .startChatStream(
                                    _dashboardController
                                        .openChat!.chatId);
                                selectedChat.value =
                                    _dashboardController
                                        .friendsList[index]
                                        .chatId;
                              },
                              child: Container(
                                padding: EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Get.theme.appBarTheme
                                            .backgroundColor!),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0))),
                                child: Text(_dashboardController
                                    .groupList.value[index].modelName),
                              ),
                            )),
                          );
                        }),
                  );
                }),
              ),
            ],
          ),
          Obx(
            () {
              return Expanded(
                  child: selectedChat == "none"
                      ? Container(
                          child: Center(
                            child: Text("Start Chat.."),
                          ),
                        )
                      : buildChat());
            },
          )
        ],
      ),
    );
  }

  Widget buildChat() {
    return ChatBox();
  }
}

class DesktopChatScreen extends StatelessWidget {
  DesktopChatScreen({Key? key}) : super(key: key);
  final DashboardController _dashboardController =
      Get.find<DashboardController>();

  RxString selectedChat = "none".obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(
                            color: Get.theme.appBarTheme.backgroundColor!))),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Center(
                        child: Text("Friends"),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color:
                                        Get.theme.appBarTheme.backgroundColor!,
                                    width: 2.0),
                                bottom: BorderSide(
                                    color:
                                        Get.theme.appBarTheme.backgroundColor!,
                                    width: 2.0))),
                        child: GetX<DashboardController>(
                          builder: (DashboardController dashboardController) {
                            if (_dashboardController != null &&
                                _dashboardController.friendsList != null) {
                              return ListView.builder(
                                  controller: ScrollController(),
                                  scrollDirection: Axis.vertical,
                                  itemCount:
                                      _dashboardController.friendsList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {
                                              if ((_dashboardController.openChat != null &&
                                                  _dashboardController.openChat!.chatId == _dashboardController.friendsList[index].chatId)) {
                                                return;
                                              }
                                              _dashboardController.startTimer(_dashboardController.friendsList[index].chatId);
                                              if (_dashboardController.allChats[_dashboardController.friendsList[index].chatId] != null){
                                                selectedChat.value =
                                                    _dashboardController
                                                        .friendsList[index]
                                                        .modelName;
                                                _dashboardController.openChat =
                                                _dashboardController
                                                    .friendsList[index];
                                                return;
                                              }
                                              _dashboardController.openChat =
                                                  _dashboardController
                                                      .friendsList[index];
                                              _dashboardController
                                                  .startChatStream(
                                                      _dashboardController
                                                          .openChat!.chatId);
                                              selectedChat.value =
                                                  _dashboardController
                                                      .friendsList[index]
                                                      .chatId;
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Get
                                                              .theme
                                                              .appBarTheme
                                                              .backgroundColor!))),
                                              child: Center(
                                                  child: Text(
                                                      _dashboardController
                                                          .friendsList[index]
                                                          .modelName)),
                                            ),
                                          ),
                                        ));
                                  });
                            } else {
                              return Text("Loading");
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Get.theme.appBarTheme.backgroundColor!,
                                  width: 2.0))),
                      child: const Center(
                        child: Text("Groups"),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color:
                                        Get.theme.appBarTheme.backgroundColor!,
                                    width: 2.0))),
                        child: GetX<DashboardController>(
                          builder: (DashboardController dashboardController) {
                            if (_dashboardController != null &&
                                _dashboardController.groupList != null) {
                              return ListView.builder(
                                  controller: ScrollController(),
                                  scrollDirection: Axis.vertical,
                                  itemCount:
                                      _dashboardController.groupList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {
                                              if ((_dashboardController.openChat != null &&
                                                  _dashboardController.openChat!.chatId == _dashboardController.groupList[index].chatId)) {
                                                return;
                                              }
                                              _dashboardController.startTimer(_dashboardController.groupList[index].chatId);
                                              if (_dashboardController.allChats[_dashboardController.groupList[index].chatId] != null){
                                                selectedChat.value =
                                                    _dashboardController
                                                        .groupList[index]
                                                        .modelName;
                                                _dashboardController.openChat =
                                                _dashboardController
                                                    .groupList[index];
                                                return;
                                              }
                                              selectedChat.value =
                                                  _dashboardController
                                                      .groupList[index]
                                                      .modelName;
                                              _dashboardController.openChat =
                                                  _dashboardController
                                                      .groupList[index];
                                              _dashboardController
                                                  .startChatStream(
                                                      _dashboardController
                                                          .openChat!.chatId);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Get
                                                              .theme
                                                              .appBarTheme
                                                              .backgroundColor!))),
                                              child: Center(
                                                  child: Text(
                                                      _dashboardController
                                                          .groupList[index]
                                                          .modelName)),
                                            ),
                                          ),
                                        ));
                                  });
                            } else {
                              return Text("Loading");
                            }
                          },
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Tooltip(
                            message: 'Create Group',
                            child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: InkWell(
                                    child: Icon(
                                      Icons.group_add,
                                      size: 32,
                                      color:
                                          Get.theme.appBarTheme.backgroundColor,
                                    ),
                                    onTap: () {
                                      Get.dialog(ChatScreenDialog(
                                        selectedDialog: 1,
                                      ));
                                    },
                                  ),
                                )),
                          ),
                        ),
                        Expanded(
                          child: Tooltip(
                            message: 'Search Friend',
                            child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: InkWell(
                                    child: Icon(
                                      Icons.search,
                                      size: 32,
                                      color:
                                          Get.theme.appBarTheme.backgroundColor,
                                    ),
                                    onTap: () {
                                      Get.dialog(ChatScreenDialog(
                                        selectedDialog: 2,
                                      ));
                                    },
                                  ),
                                )),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )),
          Flexible(
              flex: 7,
              child: Obx(
                () {
                  return selectedChat == "none"
                      ? Container(
                          child: Center(
                            child: Text("Start Chat.."),
                          ),
                        )
                      : buildChat();
                },
              ))
        ],
      ),
    );
  }

  Widget buildChat() {
    return ChatBox();
  }
}

class ChatBox extends StatefulWidget {
  const ChatBox({Key? key}) : super(key: key);

  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  TextEditingController message = TextEditingController();

  final DashboardController _dashboardController =
      Get.find<DashboardController>();

  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                  color: Get.theme.appBarTheme.backgroundColor,
                  padding: EdgeInsets.all(8.0),
                  child: Text(_dashboardController.openChat!.modelName,
                      style: Get.textTheme.headline4)),
            )
          ],
        ),
        Expanded(child: ChatWidget()),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Material(
                  child: Theme(
                    data: Get.theme.copyWith(
                        inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Get.theme.appBarTheme.backgroundColor!),
                          borderRadius: BorderRadius.circular(10.0)),
                    )),
                    child: TextFormField(
                      controller: message,
                      focusNode: myFocusNode,
                      decoration: InputDecoration(
                        hintText: "Type Your Message...",
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (message.text.isEmpty) {
                              return;
                            }
                            _dashboardController.sendMessage(
                                _dashboardController.openChat!.chatId,
                                _dashboardController.openChat!.modelId,
                                message.text);
                            message.clear();
                            myFocusNode.requestFocus();
                          },
                          icon: Icon(
                            Icons.send_outlined,
                            color: Get.theme.appBarTheme.backgroundColor,
                          ),
                        ),
                      ),
                      onFieldSubmitted: (value) {
                        if (value.isEmpty) {
                          return;
                        }
                        _dashboardController.sendMessage(
                            _dashboardController.openChat!.chatId,
                            _dashboardController.openChat!.modelId,
                            value);
                        message.clear();
                        myFocusNode.requestFocus();
                      },
                    ),
                  ),
                ),
              ),
              _dashboardController.openChat!.modelType == "Group"? Tooltip(
                message: "Add Friend To Group",
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                      Get.dialog(ChatScreenDialog(selectedDialog: 3));
                    },
                    child: Icon(Icons.add_box, color: Get.theme.appBarTheme.backgroundColor,),
                  ),
                ),
              ): const SizedBox(width: 0, height: 0,)
              ,

            ],
          ),
        )
      ],
    );
  }
}

class ChatWidget extends StatelessWidget {
  ChatWidget({Key? key}) : super(key: key);

  final DashboardController _dashboardController =
      Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    if (_dashboardController.allChats[_dashboardController.openChat!.chatId] ==
        null) {
      return Container(color: Colors.lime);
    }
    return Obx(
      () => ListView.builder(
        controller: ScrollController(),
        itemCount: _dashboardController
            .allChats[_dashboardController.openChat!.chatId]!.length + 1,
        reverse: true,
        itemBuilder: (context, index) {
          if (index == _dashboardController.allChats[_dashboardController.openChat!.chatId]!.length){
            return ListTile(
              title: Center(
                  child: InkWell(
                      child: Text("Load More"),
                    onTap: (){
                        _dashboardController.startChatStream(_dashboardController.openChat!.chatId);
                    },
                  )
              ),
            );
          }
          return ListTile(
            title: createMessageBubble(_dashboardController
                .allChats[_dashboardController.openChat!.chatId]![index]
                .sender == _dashboardController.firebaseController.getCurrentUserId(), _dashboardController
                .allChats[_dashboardController.openChat!.chatId]![index]
                .message,_dashboardController
                .allChats[_dashboardController.openChat!.chatId]![index]
                .senderName,_dashboardController
                .allChats[_dashboardController.openChat!.chatId]![index]
                .timeStamp),
              );
        },
      ),
    );
  }

  Widget createMessageBubble(bool mySelf, String message, String senderName, String time){
    if (mySelf){
      return Align(
        alignment: Alignment.centerRight,
        child: FractionallySizedBox(
          widthFactor: 0.7,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Get.theme.appBarTheme.foregroundColor!,
                  border: Border.all(color: Get.theme.appBarTheme.backgroundColor!, width: 1.0),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)
                  )
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                    child: Text(message, style: Get.textTheme.bodyText2)
                ),
              ),
              Row(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(DateFormat.Hms().format(DateTime.fromMillisecondsSinceEpoch(int.parse(time)).toLocal()), style: TextStyle(color: Get.theme.appBarTheme.backgroundColor, fontSize: 12.0))
                  ),
                  Expanded(child: Container(),),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text(senderName, style: TextStyle(color: Get.theme.appBarTheme.backgroundColor, fontSize: 12.0))
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: Column(
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Get.theme.appBarTheme.backgroundColor!,
                    border: Border.all(color: Get.theme.appBarTheme.backgroundColor!, width: 1.0),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)
                    )
                ),
                child: Text(message, style: Get.textTheme.bodyText1),
              ),
            ),
            Row(
              children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: Text(senderName, style: TextStyle(color: Get.theme.appBarTheme.backgroundColor, fontSize: 12.0))
                ),
                Expanded(child: Container(),),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(DateFormat.Hms().format(DateTime.fromMillisecondsSinceEpoch(int.parse(time)).toLocal()), style: TextStyle(color: Get.theme.appBarTheme.backgroundColor, fontSize: 12.0))
                ),
              ],
            )
          ],
        ),
      ),
    );

  }
}
