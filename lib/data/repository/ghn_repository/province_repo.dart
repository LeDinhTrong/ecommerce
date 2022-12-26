import 'package:flutter/cupertino.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class ProvinceRepo {
  final DioClient dioClient;
  ProvinceRepo({@required this.dioClient});

  Future<dynamic> getProvinceList() async {
    try {
      final response = await dioClient
          .get(AppConstants.BASE_URL_API + AppConstants.PROVINCE);
      return response;
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
