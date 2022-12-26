class AddressModel {
  int id;
  int customerId;
  String contactPersonName;
  String addressType;
  String province;
  String district;
  String ward;
  String address;
  String zip;
  String phone;
  String createdAt;
  String updatedAt;

  AddressModel(
      {this.id,
      this.customerId,
      this.contactPersonName,
      this.addressType,
      this.province,
      this.district,
      this.ward,
      this.address,
      this.zip,
      this.phone,
      this.createdAt,
      this.updatedAt});

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    contactPersonName = json['contact_person_name'];
    addressType = json['address_type'];
    province = json['province'];
    district = json['district'];
    ward = json['ward'];
    address = json['address'];
    zip = json['zip'];
    phone = json['phone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['contact_person_name'] = this.contactPersonName;
    data['address_type'] = this.addressType;

    data['province'] = this.province;
    data['district'] = this.district;
    data['ward'] = this.ward;
    data['address'] = this.address;
    data['zip'] = this.zip;
    data['phone'] = this.phone;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
