class DistrictModel {
  int provinceId;

  DistrictModel({this.provinceId});

  DistrictModel.fromJson(Map<String, dynamic> json) {
    provinceId = json['province_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['province_id'] = this.provinceId;
    return data;
  }
}

class ResultDistrictModel {
  int districtID;
  int provinceID;
  String districtName;

  ResultDistrictModel({this.districtID, this.provinceID, this.districtName});

  ResultDistrictModel.fromJson(Map<String, dynamic> json) {
    districtID = json['DistrictID'];
    provinceID = json['ProvinceID'];
    districtName = json['DistrictName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DistrictID'] = this.districtID;
    data['ProvinceID'] = this.provinceID;
    data['DistrictName'] = this.districtName;
    return data;
  }
}
