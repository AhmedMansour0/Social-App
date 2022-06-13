
class MessageModel {
  String ? receiverId;
  String ? senderId;
  String ? dateTime;
  String ? text;
  String ? image;


  MessageModel({
    this.receiverId,
    this.senderId,
    this.dateTime,
    this.text,
    this.image,
  });

  MessageModel.fromJson(Map<String , dynamic> ? json)
  {
    receiverId = json!['receiverId'];
    senderId = json['senderId'];
    dateTime = json['dateTime'];
    text = json['text'];
    image = json['image'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'receiverId':receiverId,
      'senderId':senderId,
      'dateTime':dateTime,
      'text':text,
      'image':image,
    };
  }
}