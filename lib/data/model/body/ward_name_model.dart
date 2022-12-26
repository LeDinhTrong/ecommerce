class WardNameModel {
  int id;
  String name;
  String type;
  int districtId;

  WardNameModel({this.id, this.name, this.type, this.districtId});

  WardNameModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    districtId = json['districtId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['districtId'] = this.districtId;
    return data;
  }
}
