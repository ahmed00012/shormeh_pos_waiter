class CategoriesModel{
  int? id;
  String? name;
  String? image;
  bool chosen;
  CategoriesModel({this.id, this.name, this.image,this.chosen=false});
  factory CategoriesModel.fromJson(Map<dynamic, dynamic> json) => CategoriesModel(
    id:json['id'],
      name: json['title'],
      image: json['image']);
}