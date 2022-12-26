class CreateShippingModel {
  int paymentTypeId;
  String note;
  String requiredNote;
  String returnPhone;
  String returnAddress;
  String toName;
  String toPhone;
  String toAddress;
  String toWardCode;
  int toDistrictId;
  int codAmount;
  String content;
  int weight;
  int length;
  int width;
  int height;
  int insuranceValue;
  int serviceTypeId;
  int orderValue;
  List<Items> items;

  CreateShippingModel(
      {this.paymentTypeId,
      this.note,
      this.requiredNote,
      this.returnPhone,
      this.returnAddress,
      this.toName,
      this.toPhone,
      this.toAddress,
      this.toWardCode,
      this.toDistrictId,
      this.codAmount,
      this.content,
      this.weight,
      this.length,
      this.width,
      this.height,
      this.insuranceValue,
      this.serviceTypeId,
      this.orderValue,
      this.items});

  CreateShippingModel.fromJson(Map<String, dynamic> json) {
    paymentTypeId = json['payment_type_id'];
    note = json['note'];
    requiredNote = json['required_note'];
    returnPhone = json['return_phone'];
    returnAddress = json['return_address'];
    toName = json['to_name'];
    toPhone = json['to_phone'];
    toAddress = json['to_address'];
    toWardCode = json['to_ward_code'];
    toDistrictId = json['to_district_id'];
    codAmount = json['cod_amount'];
    content = json['content'];
    weight = json['weight'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    insuranceValue = json['insurance_value'];
    serviceTypeId = json['service_type_id'];
    orderValue = json['order_value'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_type_id'] = this.paymentTypeId;
    data['note'] = this.note;
    data['required_note'] = this.requiredNote;
    data['return_phone'] = this.returnPhone;
    data['return_address'] = this.returnAddress;
    data['to_name'] = this.toName;
    data['to_phone'] = this.toPhone;
    data['to_address'] = this.toAddress;
    data['to_ward_code'] = this.toWardCode;
    data['to_district_id'] = this.toDistrictId;
    data['cod_amount'] = this.codAmount;
    data['content'] = this.content;
    data['weight'] = this.weight;
    data['length'] = this.length;
    data['width'] = this.width;
    data['height'] = this.height;
    data['insurance_value'] = this.insuranceValue;
    data['service_type_id'] = this.serviceTypeId;
    data['order_value'] = this.orderValue;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String name;
  int quantity;
  int price;

  Items({this.name, this.quantity, this.price});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    return data;
  }
}
