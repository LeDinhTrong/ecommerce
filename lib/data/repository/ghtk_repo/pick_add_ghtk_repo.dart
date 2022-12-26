import 'package:flutter/cupertino.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class PickAddGHTKRepo {
  final DioClient dioClient;
  PickAddGHTKRepo({@required this.dioClient});

  Future<dynamic> getPickAddGHTK() async {
    try {
      final response = await dioClient
          .get(AppConstants.BASE_URL_GHTK + AppConstants.LIST_PICK_ADD);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
