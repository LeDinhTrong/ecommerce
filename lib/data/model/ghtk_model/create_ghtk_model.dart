class CreateGHTKModel {
  List<Products> products;
  Order order;

  CreateGHTKModel({this.products, this.order});

  CreateGHTKModel.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    if (this.order != null) {
      data['order'] = this.order.toJson();
    }
    return data;
  }
}

class Products {
  String name;
  double weight;
  int quantity;
  int price;

  Products({this.name, this.weight, this.quantity, this.price});

  Products.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    weight = json['weight'];
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['weight'] = this.weight;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    return data;
  }
}

class Order {
  String id;
  String pickName;
  int pickMoney;
  String pickAddressId;
  String pickAddress;
  String pickProvince;
  String pickDistrict;
  String pickTel;
  String name;
  String address;
  String province;
  String district;
  String ward;
  String hamlet;
  String tel;
  String note;
  String isFreeship;
  int value;
  String transport;

  Order(
      {this.id,
      this.pickName,
      this.pickMoney,
      this.pickAddressId,
      this.pickAddress,
      this.pickProvince,
      this.pickDistrict,
      this.pickTel,
      this.name,
      this.address,
      this.province,
      this.district,
      this.ward,
      this.hamlet,
      this.tel,
      this.note,
      this.isFreeship,
      this.value,
      this.transport});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pickName = json['pick_name'];
    pickMoney = json['pick_money'];
    pickAddressId = json['pick_address_id'];
    pickAddress = json['pick_address'];
    pickProvince = json['pick_province'];
    pickDistrict = json['pick_district'];
    pickTel = json['pick_tel'];
    name = json['name'];
    address = json['address'];
    province = json['province'];
    district = json['district'];
    ward = json['ward'];
    hamlet = json['hamlet'];
    tel = json['tel'];
    note = json['note'];
    isFreeship = json['is_freeship'];
    value = json['value'];
    transport = json['transport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pick_name'] = this.pickName;
    data['pick_money'] = this.pickMoney;
    data['pick_address_id'] = this.pickAddressId;
    data['pick_address'] = this.pickAddress;
    data['pick_province'] = this.pickProvince;
    data['pick_district'] = this.pickDistrict;
    data['pick_tel'] = this.pickTel;
    data['name'] = this.name;
    data['address'] = this.address;
    data['province'] = this.province;
    data['district'] = this.district;
    data['ward'] = this.ward;
    data['hamlet'] = this.hamlet;
    data['tel'] = this.tel;
    data['note'] = this.note;
    data['is_freeship'] = this.isFreeship;
    data['value'] = this.value;
    data['transport'] = this.transport;
    return data;
  }
}
