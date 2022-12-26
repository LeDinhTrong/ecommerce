class ShopAllModel {
  int offset;
  int limit;

  ShopAllModel({this.offset, this.limit});

  ShopAllModel.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offset'] = this.offset;
    data['limit'] = this.limit;
    return data;
  }
}

class ResultShopAllModel {
  int iId;
  String name;
  String phone;
  String address;
  String wardCode;
  int districtId;

  ResultShopAllModel(
      {this.iId,
      this.name,
      this.phone,
      this.address,
      this.wardCode,
      this.districtId});

  ResultShopAllModel.fromJson(Map<String, dynamic> json) {
    iId = json['_id'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    wardCode = json['ward_code'];
    districtId = json['district_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.iId;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['ward_code'] = this.wardCode;
    data['district_id'] = this.districtId;
    return data;
  }
}
