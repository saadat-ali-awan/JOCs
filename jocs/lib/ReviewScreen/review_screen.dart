import 'package:collection/src/list_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Controllers/review_screen_controller.dart';
import 'package:intl/intl.dart';

class ReviewScreen extends GetView<ReviewScreenController> {
  ReviewScreen({Key? key}) : super(key: key);

  final TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.arrow_back_ios_outlined),
          onTap: () {
            Get.back();
          },
        ),
        title: Text("Write a Review"),
      ),
      body: reviewScreenDataWidget(context),
    );
  }

  Widget reviewScreenDataWidget(BuildContext context) {
    return Container(
      color: context.theme.appBarTheme.foregroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: rowData(),
            ),
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: context.theme.appBarTheme.foregroundColor,
                  child: Row(
                    children: const [
                      Text("Write Your Review:"),
                    ],
                  ),
                ),
                Container(
                  color: context.theme.appBarTheme.foregroundColor,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: TextFormField(
                      minLines: 3,
                      maxLines: 3,
                      controller: reviewController,
                      decoration: InputDecoration(
                        hintText: "Type Here...",
                        suffixIcon: InkWell(
                          child: Icon(Icons.send_outlined, color: context.theme.appBarTheme.backgroundColor),
                          onTap: () {
                            controller.sendReview(reviewController.text);
                            reviewController.clear();
                          },
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: context.theme.appBarTheme.backgroundColor!, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: context.theme.appBarTheme.backgroundColor!, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(()=> ListView.builder(
                      itemCount: controller.reviews.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Container(
                            decoration: BoxDecoration(
                              color: context.theme.appBarTheme.backgroundColor!.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(controller.reviews[index]['review']),
                            ),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(controller.reviews[index]['sender'], style: context.textTheme.bodyText2!.copyWith(fontSize: 12),),
                              Row(
                                children: [
                                  Text('${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(controller.reviews[index]["time"])).toLocal())} - ', style: context.textTheme.bodyText2!.copyWith(fontSize: 12),),
                                  Text(DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(int.parse(controller.reviews[index]['time'])).toLocal()), style: context.textTheme.bodyText2!.copyWith(fontSize: 12),),
                                ],
                              )

                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  List<Widget> rowData() {
    List<Widget> temp = <Widget>[];
    controller.data.forEachIndexed((int index, value) {
      temp.add(
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text('${controller.dataTitle[index]}: ${value}'),
        ),
      );
    });
    return temp;
  }
}
