
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';
import 'package:jocs/Dashboard/Dialog/ChatScreenDialogs/search_user_dialog.dart';

class TicketItem extends StatefulWidget {
  TicketItem({Key? key}) : super(key: key);

  @override
  State<TicketItem> createState() => _TicketItemState();
}

class _TicketItemState extends State<TicketItem> {
  final _formKey = GlobalKey<FormState>();

  final DashboardController _dashboardController =
      Get.find<DashboardController>();

  final TextEditingController topicController = TextEditingController();

  String statusValue = "OPEN";

  String priorityValue = "LOW";

  final TextEditingController assignedToController = TextEditingController();

  final TextEditingController commentsController = TextEditingController();

  RxList foundFriend = ["", ""].obs;
  bool assigned = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: SizedBox(
          //     width: 350,
          //     child: Material(
          //       child: TextFormField(
          //         controller: issuedByController,
          //         decoration: const InputDecoration(
          //           labelText: 'Issued By',
          //           hintText: 'Mr. Abc',
          //         ),
          //         validator: (value) {
          //           print(value);
          //           if (value == null || value.isEmpty) {
          //             return 'Issued By?';
          //           }
          //           return null;
          //         },
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 350,
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text('Issued By: ${_dashboardController.firebaseController.currentUserDetails.value.email}'),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 350,
              child: Material(
                child: TextFormField(
                  controller: topicController,
                  decoration: const InputDecoration(
                    labelText: 'Topic',
                    hintText: 'XYZ Problem',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Topic?';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 350,
                child: Material(
                  child: DropdownButton(
                    value: statusValue,
                    items: <String>["OPEN", "PENDING", "RESOLVED", "CLOSED"].map((value){
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (String? newValue){
                      setState(() {
                        statusValue = newValue!;
                      });
                    },
                    isExpanded: true,

                  ),

                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 350,
                child: Material(
                  child: DropdownButton(
                    value: priorityValue,
                    items: <String>["LOW", "MEDIUM", "HIGH", "URGENT"].map((value){
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (String? newValue){
                      setState(() {
                        priorityValue = newValue!;
                      });
                    },
                    isExpanded: true,

                  ),
                )),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: SizedBox(
          //       width: 350,
          //       child: Material(
          //         child: TextFormField(
          //           controller: assignedToController,
          //           decoration: const InputDecoration(
          //               labelText: 'Assigned to', hintText: 'Mr. XYZ'),
          //         ),
          //       )),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 350,
                child: Material(
                  child: TextFormField(
                    controller: commentsController,
                    decoration: const InputDecoration(
                        labelText: 'Comments', hintText: 'Add Your Comments'),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 350,
                child: Material(
                  child: TextFormField(
                    controller: assignedToController,
                    decoration: InputDecoration(
                      labelText: 'Assigned To', hintText: 'Enter Email',
                      suffixIcon: assigned ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            assigned = false;
                            foundFriend.value = <String>["", ""];
                            assignedToController.clear();
                          });
                        },
                      ) : IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () async {
                          if (assignedToController.text == "") {
                            return;
                          }
                          foundFriend.value = await _dashboardController.searchFriend(assignedToController.text);
                          setState(() {
                            assignedToController.clear();
                          });
                        },
                      ),
                    ),
                    validator: (String? value) {
                      if (assigned) {
                        return null;
                      }
                      return 'Assign The Ticket First.';
                    },
                  ),
                )),
          ),
          Material(
            child: InkWell(
                onTap: (){
                  setState(() {
                    assignedToController.text = foundFriend.value[0];
                    assigned = true;
                  });
                },
                child: Text(
                  foundFriend.value[0],
                  style: Get.textTheme.bodyText2,
                )
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 32.0),
            child: TextButton(

              onPressed: () {
                if (_formKey.currentState!.validate()){
                  _dashboardController.addDataToFirebase({
                    'issued_by': _dashboardController.firebaseController.currentUserDetails.value.email, // John Doe
                    'topic': topicController.text, // Stokes and Sons
                    'status': statusValue, // 42
                    'priority': priorityValue,
                    'assigned_to': assignedToController.text,
                    'comments': commentsController.text,
                    'time' : DateTime.now().toUtc().millisecondsSinceEpoch.toString()
                  }, "tickets", "ticketsCount", _dashboardController.metadata.value.ticketsCount);
                  setState(() {
                    topicController.clear();
                    assignedToController.clear();
                    commentsController.clear();
                  });
                  Get.back();
                }

              },
              child: Text(
                "Add Ticket",
                style: Get.textTheme.bodyText1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
