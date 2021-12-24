import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Registration/login.dart';

void main() {
  runApp(const GetMaterialApp(home: Login()));
}

class Controller extends GetxController{
  var count = 0.obs;
  increment() => count++;
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);


  @override
  Widget build(context) {

    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final Controller c = Get.put(Controller());

    return Scaffold(
      // Use Obx(()=> to update Text() whenever count is changed.
        appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),

        // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
        body: Center(child: ElevatedButton(
            child: Text("Go to Other"), onPressed: () => Get.to(Other()))),
        floatingActionButton:
        FloatingActionButton(child: Icon(Icons.add), onPressed: c.increment));
  }
}

class Other extends StatelessWidget {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  final Controller c = Get.find();

  @override
  Widget build(context){
    // Access the updated count variable
    return Scaffold(body: Center(child: Text("${c.count}")));
  }
}