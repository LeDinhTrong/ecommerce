import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/onboarding_model.dart';

class OnBoardingRepo{
  final DioClient dioClient;
  OnBoardingRepo({@required this.dioClient});

  Future<ApiResponse> getOnBoardingList() async {
    try {
      List<OnboardingModel> onBoardingList = [
        OnboardingModel('assets/images/onboarding_image_one.png', 'Chào mừng đến IZI Shop', 'Here shopping is easy and fun with 50 thousands products, exclusive deals, offers and promotions.'),
        OnboardingModel('assets/images/onboarding_image_two.png', 'Thanh toán dễ dàng bảo mật', 'Enjoy safer & faster payments. We offer world famous four payment gateway for smooth and safe payment for your purchase.'),
        OnboardingModel('assets/images/onboarding_image_three.png', 'Giao hàng nhanh', 'Thousand of seller are waiting for your order, place an order, get fast delivery and enjoy your daily life.'),
      ];

      Response response = Response(requestOptions: RequestOptions(path: ''), data: onBoardingList,statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}