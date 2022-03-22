import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';

/// Show a form to Add or Update Problems Item
class ProblemsItem extends StatefulWidget {
  const ProblemsItem({Key? key, required this.previousData, required this.time}) : super(key: key);

  final List<String> previousData;
  final String time;
  @override
  State<ProblemsItem> createState() => _ProblemsItemState();
}

class _ProblemsItemState extends State<ProblemsItem> {
  final _formKey = GlobalKey<FormState>();

  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  final TextEditingController topicController = TextEditingController();

  String statusValue = "OPEN";

  String priorityValue = "LOW";

  final TextEditingController assignedToController = TextEditingController();

  final TextEditingController departmentController = TextEditingController();

  RxList foundFriend = ["", ""].obs;
  bool assigned = false;

  @override
  void initState() {
    if (widget.previousData.isNotEmpty){
      topicController.text = widget.previousData[1];
      statusValue = widget.previousData[2];
      priorityValue = widget.previousData[3];
      assignedToController.text = widget.previousData[4];
      foundFriend[0] = widget.previousData[4];
      assigned = true;
      departmentController.text = widget.previousData[5];
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
                  child:widget.time.isEmpty ? Text(
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
                      if (value != null && value.isNotEmpty && !assigned) {
                        return 'Assign The Ticket First.';
                      }
                      return null;
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 350,
                child: Material(
                  child: TextFormField(
                    controller: departmentController,
                    decoration: const InputDecoration(
                        labelText: 'Department', hintText: 'Department'),
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return 'Department?';
                      }
                      return null;
                    },
                  ),
                )),
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
                      'department': departmentController.text,
                      'time' : DateTime.now().toUtc().millisecondsSinceEpoch.toString()
                    }, "problems", "problemsCount", _dashboardController.metadata.value.problemsCount);
                  } else {
                    print(widget.time);
                    _dashboardController.updateTableData(
                      "problems",
                      widget.time,
                      {
                        'issued_by': widget.previousData[0], // John Doe
                        'topic': topicController.text, // Stokes and Sons
                        'status': statusValue, // 42
                        'priority': priorityValue,
                        'assigned_to': assignedToController.text,
                        'department': departmentController.text,
                      },
                    );
                  }
                  setState(() {
                    topicController.clear();
                    assignedToController.clear();
                    departmentController.clear();
                  });
                  Get.back();
                }

              },
              child: widget.time.isEmpty ? Text(
                "Add Problem Data",
                style: Get.textTheme.bodyText1,
              ) : Text(
                "Update Problem Data",
                style: Get.textTheme.bodyText1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
