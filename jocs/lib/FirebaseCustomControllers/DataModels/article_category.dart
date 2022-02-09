import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleCategory {
  String name = "";
  String description = "";
  List<dynamic> articles = [];
  ArticleCategory(this.name, [this.description = "", this.articles = const []]);

  ArticleCategory.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    name = documentSnapshot["category-name"];
    description = documentSnapshot["description"];
    articles = List.from(documentSnapshot["articles"]);
  }

  factory ArticleCategory.fromJson(Map<String, dynamic> json){
    return ArticleCategory(
      json['name']
    );
  }

  static List<ArticleCategory>? fromJsonList(List? list){
    if (list == null){
      return null;
    }
    return list.map((item) => ArticleCategory.fromJson(item)).toList();
  }

  String categoryAsString() {
    return name;
  }

  @override
  String toString() {
    return name;
  }

  bool isEqual(ArticleCategory articleCategory) {
    return name == articleCategory.name;
  }

  bool userFilterByName (String filter) {
    return name.contains(filter);
  }
}