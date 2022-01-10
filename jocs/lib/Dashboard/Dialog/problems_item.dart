import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';

class ProblemsItem extends StatefulWidget {
  const ProblemsItem({Key? key}) : super(key: key);

  @override
  State<ProblemsItem> createState() => _ProblemsItemState();
}

class _ProblemsItemState extends State<ProblemsItem> {
  final _formKey = GlobalKey<FormState>();

  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  final TextEditingController issuedByController = TextEditingController();

  final TextEditingController topicController = TextEditingController();

  String statusValue = "OPEN";

  String priorityValue = "LOW";

  final TextEditingController assignedToController = TextEditingController();

  final TextEditingController departmentController = TextEditingController();

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
                child: TextFormField(
                  controller: issuedByController,
                  decoration: const InputDecoration(
                    labelText: 'Issued By',
                    hintText: 'Mr. Abc',
                  ),
                  validator: (value) {
                    print(value);
                    if (value == null || value.isEmpty) {
                      return 'Issued By?';
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
                    decoration: const InputDecoration(
                        labelText: 'Assigned to', hintText: 'Mr. XYZ'),
                  ),
                )),
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
                  _dashboardController.addDataToFirebase({
                    'issued_by': issuedByController.text, // John Doe
                    'topic': topicController.text, // Stokes and Sons
                    'status': statusValue, // 42
                    'priority': priorityValue,
                    'assigned_to': assignedToController.text,
                    'department': departmentController.text,
                    'time' : DateTime.now().toUtc().millisecondsSinceEpoch.toString()
                  }, "problems");
                  setState(() {
                    issuedByController.clear();
                    topicController.clear();
                    assignedToController.clear();
                    departmentController.clear();
                  });
                }

              },
              child: Text(
                "Add Item",
                style: Get.textTheme.bodyText1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
