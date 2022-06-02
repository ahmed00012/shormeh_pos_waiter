


class NotesModel{
  int? id;
  double? price;
  String? title;

  NotesModel({this.title,this.price,this.id});
  factory NotesModel.fromJson(Map<String, dynamic> json) => NotesModel(
    id: json["id"],
    title: json["title"],
    price: double.parse(json["price"].toString()),
  );

}