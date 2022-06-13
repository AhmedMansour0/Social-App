class CommentModel{
  late String ?name;
  late String? uId;
  late String ?image;
  late String ?dateTime;
  late String ?text;

  CommentModel({
    this.name,
    this.dateTime,
    this.text,
    this.uId,
    this.image,
  });

  CommentModel.fromJson(Map<String,dynamic>json){
    name=json['name'];
    dateTime=json['dateTime'];
    text=json['text'];
    uId=json['uId'];
    image=json['image'];
  }

  Map<String,dynamic>toMap() {
    return{
      'name':name,
      'dateTime':dateTime,
      'text':text,
      'uId':uId,
      'image':image,
    };

  }
}