class PreviewModel {
  int paymentTypeId;
  String note;
  String requiredNote;
  String toName;
  String toPhone;
  String toAddress;
  String toWardCode;
  int toDistrictId;
  String content;
  int weight;
  int length;
  int width;
  int height;
  int serviceTypeId;
  int insuranceValue;

  PreviewModel(
      {this.paymentTypeId,
      this.note,
      this.requiredNote,
      this.toName,
      this.toPhone,
      this.toAddress,
      this.toWardCode,
      this.toDistrictId,
      this.content,
      this.weight,
      this.length,
      this.width,
      this.height,
      this.serviceTypeId,
      this.insuranceValue});

  PreviewModel.fromJson(Map<String, dynamic> json) {
    paymentTypeId = json['payment_type_id'];
    note = json['note'];
    requiredNote = json['required_note'];
    toName = json['to_name'];
    toPhone = json['to_phone'];
    toAddress = json['to_address'];
    toWardCode = json['to_ward_code'];
    toDistrictId = json['to_district_id'];
    content = json['content'];
    weight = json['weight'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    serviceTypeId = json['service_type_id'];
    insuranceValue = json['insurance_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_type_id'] = this.paymentTypeId;
    data['note'] = this.note;
    data['required_note'] = this.requiredNote;
    data['to_name'] = this.toName;
    data['to_phone'] = this.toPhone;
    data['to_address'] = this.toAddress;
    data['to_ward_code'] = this.toWardCode;
    data['to_district_id'] = this.toDistrictId;
    data['content'] = this.content;
    data['weight'] = this.weight;
    data['length'] = this.length;
    data['width'] = this.width;
    data['height'] = this.height;
    data['service_type_id'] = this.serviceTypeId;
    data['insurance_value'] = this.insuranceValue;
    return data;
  }
}

class ResultPreviewModel {
  Fee fee;
  int totalFee;
  String expectedDeliveryTime;

  ResultPreviewModel({this.fee, this.totalFee, this.expectedDeliveryTime});

  ResultPreviewModel.fromJson(Map<String, dynamic> json) {
    fee = json['fee'] != null ? new Fee.fromJson(json['fee']) : null;
    totalFee = json['total_fee'];
    expectedDeliveryTime = json['expected_delivery_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.fee != null) {
      data['fee'] = this.fee.toJson();
    }
    data['total_fee'] = this.totalFee;
    data['expected_delivery_time'] = this.expectedDeliveryTime;
    return data;
  }
}

class Fee {
  int mainService;
  int insurance;

  Fee({this.mainService, this.insurance});

  Fee.fromJson(Map<String, dynamic> json) {
    mainService = json['main_service'];
    insurance = json['insurance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['main_service'] = this.mainService;
    data['insurance'] = this.insurance;
    return data;
  }
}
