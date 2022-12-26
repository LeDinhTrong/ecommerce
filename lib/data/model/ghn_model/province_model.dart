class ProvinceModel {
  int provinceID;
  String provinceName;
  List<String> nameExtension;

  ProvinceModel({this.provinceID, this.provinceName, this.nameExtension});

  ProvinceModel.fromJson(Map<String, dynamic> json) {
    provinceID = json['ProvinceID'];
    provinceName = json['ProvinceName'];
    nameExtension = json['NameExtension'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProvinceID'] = this.provinceID;
    data['ProvinceName'] = this.provinceName;
    data['NameExtension'] = this.nameExtension;
    return data;
  }
}
