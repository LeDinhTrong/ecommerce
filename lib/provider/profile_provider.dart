import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/district_name_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/province_name_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/ward_name_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/address_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/error_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/response_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/user_info_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/profile_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:http/http.dart' as http;

class ProfileProvider extends ChangeNotifier {
  final ProfileRepo profileRepo;
  ProfileProvider({@required this.profileRepo});
  String phone;

  List<String> _addressTypeList = [];
  String _addressType;
  UserInfoModel _userInfoModel;
  bool _isLoading = false;
  List<AddressModel> _addressList;
  bool _hasData;
  bool _isHomeAddress = true;
  String _addAddressErrorText;
  String province;
  int provinceId;
  String district;
  String districtId;
  String ward;
  List<String> provinceName = [];
  List<String> districtName = [];
  List<String> wardName = [];
  List<ProvinceNameModel> provinceNameList = [];
  List<DistrictNameModel> districtNameList = [];
  List<WardNameModel> wardNameList = [];

  List<String> get addressTypeList => _addressTypeList;
  String get addressType => _addressType;
  UserInfoModel get userInfoModel => _userInfoModel;
  bool get isLoading => _isLoading;
  List<AddressModel> get addressList => _addressList;
  bool get hasData => _hasData;
  bool get isHomeAddress => _isHomeAddress;
  String get addAddressErrorText => _addAddressErrorText;

  void setAddAddressErrorText(String errorText) {
    _addAddressErrorText = errorText;
    notifyListeners();
  }

  void updateAddressCondition(bool value) {
    _isHomeAddress = value;
    notifyListeners();
  }

  bool _checkHomeAddress = false;
  bool get checkHomeAddress => _checkHomeAddress;

  bool _checkOfficeAddress = false;
  bool get checkOfficeAddress => _checkOfficeAddress;

  void setHomeAddress() {
    _checkHomeAddress = true;
    _checkOfficeAddress = false;
    notifyListeners();
  }

  void setOfficeAddress() {
    _checkHomeAddress = false;
    _checkOfficeAddress = true;
    notifyListeners();
  }

  updateCountryCode(String value) {
    _addressType = value;
    notifyListeners();
  }

  updateProvince(String value) {
    districtName.clear();
    wardName.clear();
    district = null;
    ward = null;
    province = value;
    provinceNameList.forEach((element) {
      if (element.name == value) {
        provinceId = element.id;
        print("provinceId: $provinceId");
        getDistrict(provinceId);
      }
    });
    notifyListeners();
  }

  updateDistrict(String value) {
    wardName.clear();
    ward = null;
    district = value;
    districtNameList.forEach((element) {
      if (element.name == value) {
        districtId = element.id;
        print("districtId: $districtId");
        getWard(districtId);
      }
    });
    notifyListeners();
  }

  updateWard(String value) {
    ward = value;
    notifyListeners();
  }

  clearAddress() {
    province = null;
    district = null;
    ward = null;
    _addressType = null;
    provinceName.clear();
    districtName.clear();
    wardName.clear();
    notifyListeners();
  }

  Future<void> initAddressList(BuildContext context) async {
    ApiResponse apiResponse = await profileRepo.getAllAddress();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _addressList = [];
      apiResponse.response.data.forEach(
          (address) => _addressList.add(AddressModel.fromJson(address)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void removeAddressById(int id, int index, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await profileRepo.removeAddressByID(id);
    _isLoading = false;

    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _addressList.removeAt(index);
      Map map = apiResponse.response.data;
      String message = map["message"];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated(message, context)),
          backgroundColor: Colors.green));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<String> getUserInfo(BuildContext context) async {
    String userID = '-1';
    ApiResponse apiResponse = await profileRepo.getUserInfo();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _userInfoModel = await UserInfoModel.fromJson(apiResponse.response.data);
      phone = _userInfoModel.phone;
      userID = _userInfoModel.id.toString();
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return userID;
  }

  void initAddressTypeList(BuildContext context) async {
    if (_addressTypeList.length == 0) {
      ApiResponse apiResponse = await profileRepo.getAddressTypeList();
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        _addressTypeList.clear();
        _addressTypeList.addAll(apiResponse.response.data);
        // _addressType = apiResponse.response.data[0];
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  Future getProvince(BuildContext context) async {
    ApiResponse apiResponse = await profileRepo.getProvince();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      provinceNameList = List<ProvinceNameModel>.from(apiResponse
          .response.data['data']
          .map((model) => ProvinceNameModel.fromJson(model)));
      notifyListeners();
      provinceName.clear();
      provinceNameList.forEach((element) {
        provinceName.add(element.name);
      });
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }

  Future<void> getDistrict(provinceId) async {
    final response = await profileRepo.getDistrict(provinceId);
    Map<String, dynamic> result = jsonDecode(response.toString());
    if (result['data'] != null) {
      districtNameList = List<DistrictNameModel>.from(
          result['data'].map((model) => DistrictNameModel.fromJson(model)));
      districtName.clear();
      districtNameList.forEach((element) {
        districtName.add(element.name);
      });
      notifyListeners();
    } else {
      print("Error get District");
      // ApiChecker.checkApi(context, apiResponse);
    }
  }

  Future getWard(districtId) async {
    ApiResponse apiResponse = await profileRepo.getWard(districtId);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      wardNameList = List<WardNameModel>.from(apiResponse.response.data['data']
          .map((model) => WardNameModel.fromJson(model)));
      wardName.clear();
      wardNameList.forEach((element) {
        wardName.add(element.name);
      });
      notifyListeners();
    } else {
      print("Error get ward");
      // ApiChecker.checkApi(context, apiResponse);
    }
  }

  Future addAddress(AddressModel addressModel, Function callback) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await profileRepo.addAddress(addressModel);
    _isLoading = false;

    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      Map map = apiResponse.response.data;
      if (_addressList == null) {
        _addressList = [];
      }
      _addressList.add(addressModel);
      String message = map["message"];
      callback(true, message);
    } else {
      String errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false, errorMessage);
    }
    notifyListeners();
  }

  Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel,
      String pass, File file, String token) async {
    _isLoading = true;
    notifyListeners();

    ResponseModel responseModel;
    http.StreamedResponse response =
        await profileRepo.updateProfile(updateUserModel, pass, file, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String message = map["message"];
      _userInfoModel = updateUserModel;
      responseModel = ResponseModel(message, true);
      print(message);
    } else {
      print('${response.statusCode} ${response.reasonPhrase}');
      responseModel = ResponseModel(
          '${response.statusCode} ${response.reasonPhrase}', false);
    }
    notifyListeners();
    return responseModel;
  }

  // save office and home address
  void saveHomeAddress(String homeAddress) {
    profileRepo.saveHomeAddress(homeAddress).then((_) {
      notifyListeners();
    });
  }

  void saveOfficeAddress(String officeAddress) {
    profileRepo.saveOfficeAddress(officeAddress).then((_) {
      notifyListeners();
    });
  }

  // for home Address Section
  String getHomeAddress() {
    return profileRepo.getHomeAddress();
  }

  Future<bool> clearHomeAddress() async {
    return await profileRepo.clearHomeAddress();
  }

  // for office Address Section
  String getOfficeAddress() {
    return profileRepo.getOfficeAddress();
  }

  Future<bool> clearOfficeAddress() async {
    return await profileRepo.clearOfficeAddress();
  }
}
