class DistrictNameModel {
  String id;
  String name;
  String type;
  String provinceId;

  DistrictNameModel({this.id, this.name, this.type, this.provinceId});

  DistrictNameModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    provinceId = json['provinceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['provinceId'] = this.provinceId;
    return data;
  }
}
