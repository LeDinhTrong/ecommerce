import 'package:flutter/cupertino.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ghn_model/shop_all_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/ghn_repository/shop_all_repo.dart';

class ShopAllProvider extends ChangeNotifier {
  final ShopAllRepo shopAllRepo;

  ShopAllProvider({@required this.shopAllRepo});

  List<ResultShopAllModel> resultShopAllList = [];

  Future<void> getShopAll(ShopAllModel shopAllModel) async {
    ApiResponse apiResponse =
        await shopAllRepo.getShopAll(shopAllModel.toJson());
    if (apiResponse.response.data['code'] == 200) {
      resultShopAllList = List<ResultShopAllModel>.from(apiResponse
          .response.data['data']['shops']
          .map((model) => ResultShopAllModel.fromJson(model)));
      print("zzz ${resultShopAllList.length}");
    } else {
      throw Exception(apiResponse.response.data['message']);
    }
    notifyListeners();
  }
}
