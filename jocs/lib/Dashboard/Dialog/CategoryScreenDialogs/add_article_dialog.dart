import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';
import 'package:jocs/FirebaseCustomControllers/DataModels/article_category.dart';

class AddArticleDialog extends StatefulWidget {
  AddArticleDialog({Key? key}) : super(key: key);

  @override
  State<AddArticleDialog> createState() => _AddArticleDialogState();
}

class _AddArticleDialogState extends State<AddArticleDialog> {
  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  ArticleCategory categorySelected = ArticleCategory("");

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                  Radius.circular(10)),
              color: Get.theme.iconTheme.color,
            ),
            width: 400,
            child: Wrap(
                children: [Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: getArticleForm(),
                ),
                ]),
          ),
        ),
        Positioned(
          right: 0,
          child: ClipOval(
            child: Material(
              color: Get.theme.appBarTheme
                  .backgroundColor, // Button color
              child: InkWell( // Splash color
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.clear,
                  color: Get.theme.iconTheme.color,),
              ),
            ),
          ),

        ),
      ]),
    );
  }

  Widget getArticleForm() {
    var _formKey = GlobalKey<FormState>();
    TextEditingController articleTopicController = TextEditingController();
    TextEditingController articleAuthorController = TextEditingController();
    TextEditingController articleCommentsController = TextEditingController();
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
                  controller: articleTopicController,
                  decoration: const InputDecoration(
                    labelText: 'ARTICLE TOPIC',
                    hintText: 'Enter Article Topic',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Article Topic is required';
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
                  controller: articleAuthorController,
                  decoration: const InputDecoration(
                    labelText: 'AUTHOR',
                    hintText: 'Enter Author Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Author Name is required';
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
                  controller: articleCommentsController,
                  decoration: const InputDecoration(
                    labelText: 'COMMENT',
                    hintText: 'Enter Any Comment',
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
                child: DropdownSearch<ArticleCategory>(
                  dropdownSearchDecoration: const InputDecoration(
                    labelText: "Category"
                  ),
                  mode: Mode.BOTTOM_SHEET,
                  items: _dashboardController.categoryList,
                  showSearchBox: true,
                  filterFn: (category, filter) => category!.userFilterByName(filter!),
                  itemAsString: (ArticleCategory? category) => category!.categoryAsString(),
                  onChanged: (ArticleCategory? data) => categorySelected = data!,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 32.0),
            child: TextButton(

              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _dashboardController.createNewArticle({
                    'topic': articleTopicController.text,
                    'author': articleAuthorController.text,
                    'category-name': categorySelected.name,
                    'comment': articleCommentsController.text,
                    'article': Get.arguments['article'],
                  });
                  setState(() {
                    articleTopicController.clear();
                    articleAuthorController.clear();
                    articleCommentsController.clear();
                  });
                  Get.back();
                }

              },
              child: Text(
                "Add Article",
                style: Get.textTheme.bodyText1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
