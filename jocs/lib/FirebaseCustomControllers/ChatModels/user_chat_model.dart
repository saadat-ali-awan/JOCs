/// [MessageModel] is a class that defines the message Structure
class MessageModel {
  String message;
  String timeStamp;
  String sender;
  String senderName;

  MessageModel(this.message, this.sender, this.timeStamp, this.senderName);
}