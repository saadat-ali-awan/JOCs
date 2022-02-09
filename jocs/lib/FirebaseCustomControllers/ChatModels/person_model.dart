/// [PersonModel] is used for chat
/// It would contain the Person or group details during chat session
/// If [modelType] is "Friend" than the detailed contained by the instance
/// would be the details of the friend
/// If [modelType] is "Group" than the information stored in the object would
/// be the details of a group Person has joined
class PersonModel {
  String modelId;
  String chatId;
  String modelName;
  String modelType;
  List<dynamic> unreadMessages = [];

  PersonModel({required this.chatId, required this.unreadMessages , required this.modelId, required this.modelName, required this.modelType});
}