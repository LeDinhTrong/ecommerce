import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghn_model/create_shipping.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/ghn_repository/create_shipping_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';

class CreateShippingProvider extends ChangeNotifier {
  final CreateShippingRepo createShippingRepo;

  CreateShippingProvider({@required this.createShippingRepo});

  Future<void> createShipping(
      BuildContext context, CreateShippingModel createShippingModel) async {
    final response =
        await createShippingRepo.createShipping(createShippingModel.toJson());
    Map<String, dynamic> result = jsonDecode(response.toString());
    if (result['code'] == 200) {
      createShippingModel = CreateShippingModel.fromJson(result['data']);
      notifyListeners();
      print("thannh cong");
    } else {
      throw Exception(result['message']);
      // ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }
}
