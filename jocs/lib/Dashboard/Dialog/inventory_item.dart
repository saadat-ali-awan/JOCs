import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';

/// Show a form to Add or Update Inventory Item
class InventoryItem extends StatefulWidget {
  const InventoryItem({Key? key, required this.previousData, required this.time}) : super(key: key);

  final List<String> previousData;
  final String time;
  @override
  _InventoryItemState createState() => _InventoryItemState();
}

class _InventoryItemState extends State<InventoryItem> {
  final _formKey = GlobalKey<FormState>();

  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  final TextEditingController itemNameController = TextEditingController();

  final TextEditingController itemTypeController = TextEditingController();

  final TextEditingController locationController = TextEditingController();

  final TextEditingController usedByController = TextEditingController();

  final TextEditingController processedByController = TextEditingController();

  final TextEditingController commentsController = TextEditingController();

  bool updateData = false;

  @override
  void initState() {
    print(widget.previousData);
    if (widget.previousData.isNotEmpty){
      itemNameController.text = widget.previousData[0];
      itemTypeController.text = widget.previousData[1];
      locationController.text = widget.previousData[2];
      usedByController.text = widget.previousData[3];
      processedByController.text = widget.previousData[4];
      commentsController.text = widget.previousData[5];
      updateData = true;
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
                child: TextFormField(
                  controller: itemNameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    hintText: 'Mr. Abc',
                  ),
                  validator: (value) {
                    print(value);
                    if (value == null || value.isEmpty) {
                      return 'Item Name?';
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
                  controller: itemTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Item Type',
                    hintText: 'XYZ Problem',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Item Type?';
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
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    hintText: 'XYZ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Location?';
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
                  controller: usedByController,
                  decoration: const InputDecoration(
                    labelText: 'Used By',
                    hintText: 'Used By..',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Used By?';
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
                    controller: processedByController,
                    decoration: const InputDecoration(
                        labelText: 'Processed By', hintText: 'Mr. XYZ'),
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
          Container(
            margin: const EdgeInsets.only(top: 32.0),
            child: TextButton(

              onPressed: () {
                if (_formKey.currentState!.validate()){
                  if (updateData) {
                    print ("Update Data");
                    _dashboardController.updateTableData(
                      "inventory",
                      widget.time,
                      {
                        'item_name': itemNameController.text, // John Doe
                        'item_type': itemTypeController.text, // Stokes and Sons
                        'location': locationController.text, // 42
                        'used_by': usedByController.text,
                        'processed_by': processedByController.text,
                        'comments': commentsController.text,
                      },);
                  } else {
                    _dashboardController.addDataToFirebase({
                      'item_name': itemNameController.text, // John Doe
                      'item_type': itemTypeController.text, // Stokes and Sons
                      'location': locationController.text, // 42
                      'used_by': usedByController.text,
                      'processed_by': processedByController.text,
                      'comments': commentsController.text,
                      'time' : DateTime.now().toUtc().millisecondsSinceEpoch.toString()
                    }, "inventory", "inventoryCount", _dashboardController.metadata.value.inventoryCount);
                  }

                  setState(() {
                    itemNameController.clear();
                    itemTypeController.clear();
                    locationController.clear();
                    usedByController.clear();
                    processedByController.clear();
                    commentsController.clear();
                    commentsController.clear();
                  });
                  Get.back();
                }

              },
              child: widget.time.isEmpty ? Text(
                "Add Inventory Item",
                style: Get.textTheme.bodyText1,
              ) : Text(
                "Update Inventory Data",
                style: Get.textTheme.bodyText1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
