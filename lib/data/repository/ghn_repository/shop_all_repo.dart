import 'package:flutter/cupertino.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class ShopAllRepo {
  final DioClient dioClient;
  ShopAllRepo({@required this.dioClient});

  Future<dynamic> getShopAll(Map<String, dynamic> shopAllData) async {
    try {
      final response = await dioClient.post(
          AppConstants.BASE_URL_API + AppConstants.SHOP_ALL,
          data: shopAllData);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
