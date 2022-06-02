

class Department {
  int? id;
  String? title;
  List<TableModel>? tables;

  Department({this.id,  this.title, this.tables});

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    title = json['title'];
    if (json['tables'] != null) {
      tables = <TableModel>[];
      json['tables'].forEach((v) {
        tables!.add(new TableModel.fromJson(v));
      });
    }
  }

}

class TableModel {
  int? id;
  int? branchId;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  String? title;
  int? tableSectionId;
  int? seatsNumber;
  CurrentOrder? currentOrder;
  bool? chosen;
  int? numOfGuests;
  String? department;

  TableModel(
      {this.id,
        this.branchId,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.title,
        this.tableSectionId,
        this.seatsNumber,
        this.currentOrder,
      this.chosen=false,
      this.numOfGuests,
      this.department});

  TableModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    title = json['title'];
    tableSectionId = json['table_section_id'];
    seatsNumber = json['seats_number'];
    currentOrder = json['current_order'] != null
        ? new CurrentOrder.fromJson(json['current_order'])
        : null;
  }

}

class CurrentOrder {
  int? id;
  String? uuid;
  int? subtotal;
  int? discount;
  double? tax;
  double? total;
  int? quantity;
  int? paymentStatus;
  int? finished;
  int? paidAmount;
  int? orderStatusId;
  int? branchId;
  int? employeeId;
  String? paymentMethodId;
  int? orderMethodId;
  int? tableId;
  String? createdAt;
  String? updatedAt;
  String? couponId;
  String? discountId;
  int? clientsCount;
  OrderStatus? orderStatus;
  List<Details2>? details;

  CurrentOrder(
      {this.id,
        this.uuid,
        this.subtotal,
        this.discount,
        this.tax,
        this.total,
        this.quantity,
        this.paymentStatus,
        this.finished,
        this.paidAmount,
        this.orderStatusId,
        this.branchId,
        this.employeeId,
        this.paymentMethodId,
        this.orderMethodId,
        this.tableId,
        this.createdAt,
        this.updatedAt,
        this.couponId,
        this.discountId,
        this.clientsCount,
        this.orderStatus,
        this.details});

  CurrentOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    subtotal = json['subtotal'];
    discount = json['discount'];
    tax = double.parse(json['tax'].toString());
    total =double.parse(json['total'].toString());
    quantity = json['quantity'];
    paymentStatus = json['payment_status'];
    finished = json['finished'];
    paidAmount = json['paid_amount'];

    orderStatusId = json['order_status_id'];
    branchId = json['branch_id'];
    employeeId = json['employee_id'];
    paymentMethodId = json['payment_method_id'];
    orderMethodId = json['order_method_id'];
    tableId = json['table_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    couponId = json['coupon_id'];
    discountId = json['discount_id'];
    clientsCount = json['clients_count'];
    orderStatus = json['order_status'] != null
        ? new OrderStatus.fromJson(json['order_status'])
        : null;
    if (json['details'] != null) {
      details = <Details2>[];
      json['details'].forEach((v) {
        details!.add(new Details2.fromJson(v));
      });
    }
  }

}

class OrderStatus {
  int? id;
  String? createdAt;
  String? title;

  OrderStatus({this.id, this.createdAt, this.title});

  OrderStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['title'] = this.title;
    return data;
  }
}

class Details2 {
  int? id;
  int? total;
  int? quantity;
  int? completed;
  List<Notes>? notes;
  int? orderId;
  int? productId;
  String? createdAt;
  String? updatedAt;
  Product? product;


  Details2(
      {this.id,
        this.total,
        this.quantity,
        this.completed,
        this.notes,
        this.orderId,
        this.productId,
        this.createdAt,
        this.updatedAt,
        this.product,
       });

  Details2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'];
    quantity = json['quantity'];
    completed = json['completed'];
    if (json['notes'] != null) {
      notes = <Notes>[];
      json['notes'].forEach((v) {
        notes!.add(new Notes.fromJson(v));
      });
    }
    orderId = json['order_id'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;

  }


}

class Notes {
  int? id;
  String? title;
  double? price;


  Notes({this.id, this.title,this.price});

  Notes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }
}


class Product {
  int? id;
  int? price;
  int? newPrice;
  int? isActive;
  int? stockAlert;
  int? categoryId;
  int? unitId;
  int? departmentId;
  String? createdAt;
  String? updatedAt;
  String? title;
  String? description;


  Product(
      {this.id,
        this.price,
        this.newPrice,
        this.isActive,
        this.stockAlert,
        this.categoryId,
        this.unitId,
        this.departmentId,
        this.createdAt,
        this.updatedAt,
        this.title,
        this.description,
      });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    newPrice = json['new_price'];
    isActive = json['is_active'];
    stockAlert = json['stock_alert'];
    categoryId = json['category_id'];
    unitId = json['unit_id'];
    departmentId = json['department_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    title = json['title'];
    description = json['description'];
  }

}




