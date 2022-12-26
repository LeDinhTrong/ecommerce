import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/address_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/user_info_model.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  ProfileRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> getAddressTypeList() async {
    try {
      List<String> addressTypeList = [
        'Permanent',
        'Home',
        'Office',
      ];
      Response response = Response(
          requestOptions: RequestOptions(path: ''),
          data: addressTypeList,
          statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getUserInfo() async {
    try {
      final response = await dioClient
          .get(AppConstants.BASE_URL + AppConstants.CUSTOMER_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getAllAddress() async {
    try {
      final response = await dioClient
          .get(AppConstants.BASE_URL + AppConstants.ADDRESS_LIST_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getProvince() async {
    try {
      final response = await dioClient
          .get(AppConstants.BASE_URL + AppConstants.PROVINCE_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<dynamic> getDistrict(provinceId) async {
    try {
      final response = await dioClient.get(AppConstants.BASE_URL +
          AppConstants.DISTRICT_URI +
          provinceId.toString());
      return response;
    } catch (e) {
      return e;
    }
  }

  Future<ApiResponse> getWard(districtId) async {
    try {
      final response = await dioClient
          .get(AppConstants.BASE_URL + AppConstants.WARD_URI + districtId);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> removeAddressByID(int id) async {
    try {
      final response = await dioClient.delete(
          '${AppConstants.BASE_URL + AppConstants.REMOVE_ADDRESS_URI}$id');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addAddress(AddressModel addressModel) async {
    try {
      Response response = await dioClient.post(
        AppConstants.BASE_URL + AppConstants.ADD_ADDRESS_URI,
        data: addressModel.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> updateProfile(
      UserInfoModel userInfoModel, String pass, File file, String token) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${AppConstants.BASE_URL}${AppConstants.UPDATE_PROFILE_URI}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    file != null
        ? request.files.add(http.MultipartFile(
            'image', file.readAsBytes().asStream(), file.lengthSync(),
            filename: file.path.split('/').last))
        : request.fields.addAll(<String, String>{'image': userInfoModel.image});
    Map<String, String> _fields = Map();
    if (pass.isEmpty) {
      _fields.addAll(<String, String>{
        '_method': userInfoModel.method,
        'f_name': userInfoModel.fName,
        'l_name': userInfoModel.lName,
        'phone': userInfoModel.phone
      });
    } else {
      _fields.addAll(<String, String>{
        '_method': userInfoModel.method,
        'f_name': userInfoModel.fName,
        'l_name': userInfoModel.lName,
        'phone': userInfoModel.phone,
        'password': pass
      });
    }
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  // for save home address
  Future<void> saveHomeAddress(String homeAddress) async {
    try {
      await sharedPreferences.setString(AppConstants.HOME_ADDRESS, homeAddress);
    } catch (e) {
      throw e;
    }
  }

  String getHomeAddress() {
    return sharedPreferences.getString(AppConstants.HOME_ADDRESS) ?? "";
  }

  Future<bool> clearHomeAddress() async {
    return sharedPreferences.remove(AppConstants.HOME_ADDRESS);
  }

  // for save office address
  Future<void> saveOfficeAddress(String officeAddress) async {
    try {
      await sharedPreferences.setString(
          AppConstants.OFFICE_ADDRESS, officeAddress);
    } catch (e) {
      throw e;
    }
  }

  String getOfficeAddress() {
    return sharedPreferences.getString(AppConstants.OFFICE_ADDRESS) ?? "";
  }

  Future<bool> clearOfficeAddress() async {
    return sharedPreferences.remove(AppConstants.OFFICE_ADDRESS);
  }
}
