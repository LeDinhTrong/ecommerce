class PreviewGHTKModel {
  String pickAddressId;
  String province;
  String district;
  String address;
  int weight;
  int value;
  String transport;
  String deliverOption;

  PreviewGHTKModel({
    this.pickAddressId,
    this.province,
    this.district,
    this.address,
    this.weight,
    this.value,
    this.transport,
    this.deliverOption,
  });

  PreviewGHTKModel.fromJson(Map<String, dynamic> json) {
    pickAddressId = json['pick_address_id'];
    province = json['province'];
    district = json['district'];
    address = json['address'];
    weight = json['weight'];
    value = json['value'];
    transport = json['transport'];
    deliverOption = json['deliver_option'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pick_address_id'] = this.pickAddressId;
    data['province'] = this.province;
    data['district'] = this.district;
    data['address'] = this.address;
    data['weight'] = this.weight;
    data['value'] = this.value;
    data['transport'] = this.transport;
    data['deliver_option'] = this.deliverOption;
    return data;
  }
}

class ResultPreviewGHTKModel {
  int fee;
  int insuranceFee;
  int shipFeeOnly;

  ResultPreviewGHTKModel({this.fee, this.insuranceFee, this.shipFeeOnly});

  ResultPreviewGHTKModel.fromJson(Map<String, dynamic> json) {
    fee = json['fee'];
    insuranceFee = json['insurance_fee'];
    shipFeeOnly = json['ship_fee_only'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fee'] = this.fee;
    data['insurance_fee'] = this.insuranceFee;
    data['ship_fee_only'] = this.shipFeeOnly;
    return data;
  }
}
