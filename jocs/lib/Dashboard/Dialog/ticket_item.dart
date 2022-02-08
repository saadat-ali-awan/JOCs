
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';
import 'package:jocs/Dashboard/Dialog/ChatScreenDialogs/search_user_dialog.dart';

class TicketItem extends StatefulWidget {
  const TicketItem({Key? key, required this.previousData, required this.time}) : super(key: key);

  final List<String> previousData;
  final String time;
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
  void initState() {
    if (widget.previousData.isNotEmpty){
      topicController.text = widget.previousData[1];
      statusValue = widget.previousData[2];
      priorityValue = widget.previousData[3];
      assignedToController.text = widget.previousData[4];
      commentsController.text = widget.previousData[5];
      foundFriend[0] = widget.previousData[4];
      assigned = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 350,
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: widget.time.isEmpty ? Text(
                    'Issued By: ${_dashboardController.firebaseController.currentUserDetails.value.email}',
                  ): Text(
                    'Issued By: ${widget.previousData[0]}',
                  ),
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
                  if (widget.time.isEmpty) {
                    _dashboardController.addDataToFirebase({
                      'issued_by': _dashboardController.firebaseController.currentUserDetails.value.email, // John Doe
                      'topic': topicController.text, // Stokes and Sons
                      'status': statusValue, // 42
                      'priority': priorityValue,
                      'assigned_to': assignedToController.text,
                      'comments': commentsController.text,
                      'time' : DateTime.now().toUtc().millisecondsSinceEpoch.toString()
                    }, "tickets", "ticketsCount", _dashboardController.metadata.value.ticketsCount);
                  } else {
                    _dashboardController.updateTableData(
                      "tickets",
                      widget.time,
                      {
                        'issued_by': widget.previousData[0], // John Doe
                        'topic': topicController.text, // Stokes and Sons
                        'status': statusValue, // 42
                        'priority': priorityValue,
                        'assigned_to': assignedToController.text,
                        'comments': commentsController.text,
                      },
                    );

                    _dashboardController.ticketAdapter.value.adapterData.forEachIndexed((index, ticket) {
                      if (ticket['time'] == widget.time) {
                        // _dashboardController.ticketAdapter.value.adapterData[index]['issued_by'] = widget.previousData[0];
                        // _dashboardController.ticketAdapter.value.adapterData[index]['topic'] = topicController.text;
                        // _dashboardController.ticketAdapter.value.adapterData[index]['status'] = statusValue;
                        // _dashboardController.ticketAdapter.value.adapterData[index]['priority'] = priorityValue;
                        // _dashboardController.ticketAdapter.value.adapterData[index]['assigned_to'] = assignedToController.text;
                        // _dashboardController.ticketAdapter.value.adapterData[index]['comments'] = commentsController.text;
                      }
                    });
                  }

                  setState(() {
                    topicController.clear();
                    assignedToController.clear();
                    commentsController.clear();
                  });
                  Get.back();
                }

              },
              child: widget.time.isEmpty ? Text(
                "Add Ticket",
                style: Get.textTheme.bodyText1,
              ) : Text(
                "Update Ticket",
                style: Get.textTheme.bodyText1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
