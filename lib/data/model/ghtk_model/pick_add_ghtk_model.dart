class PickAddModel {
  String pickAddressId;
  String address;
  String pickTel;
  String pickName;

  PickAddModel({this.pickAddressId, this.address, this.pickTel, this.pickName});

  PickAddModel.fromJson(Map<String, dynamic> json) {
    pickAddressId = json['pick_address_id'];
    address = json['address'];
    pickTel = json['pick_tel'];
    pickName = json['pick_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pick_address_id'] = this.pickAddressId;
    data['address'] = this.address;
    data['pick_tel'] = this.pickTel;
    data['pick_name'] = this.pickName;
    return data;
  }
}
