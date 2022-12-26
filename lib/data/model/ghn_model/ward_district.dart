class WardDistrictModel {
  int districtId;

  WardDistrictModel({this.districtId});

  WardDistrictModel.fromJson(Map<String, dynamic> json) {
    districtId = json['district_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['district_id'] = this.districtId;
    return data;
  }
}

class ResultWardDistrictModel {
  String wardCode;
  int districtID;
  String wardName;

  ResultWardDistrictModel({this.wardCode, this.districtID, this.wardName});

  ResultWardDistrictModel.fromJson(Map<String, dynamic> json) {
    wardCode = json['WardCode'];
    districtID = json['DistrictID'];
    wardName = json['WardName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['WardCode'] = this.wardCode;
    data['DistrictID'] = this.districtID;
    data['WardName'] = this.wardName;
    return data;
  }
}
