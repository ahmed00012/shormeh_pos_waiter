

class ProductModel {
  String? id;
  String? departmentId;
  String? price;
  String? newPrice;
  // String? image;
  String? title;
  String? description;

  ProductModel(
      {  this.id,
        this.departmentId,
        this.price,
         this.newPrice,
        // this.image,
         this.title,
         this.description,
});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString() ;
    departmentId = json['department_id'].toString() ;
    price = json['price'].toString() ;
    newPrice = json['new_price'].toString() ;
    // image = json['image'].toString() ;
    title = json['title'].toString() ;
    description = json['description'].toString()  ;
  }
}
